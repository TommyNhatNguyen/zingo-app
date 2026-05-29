/// sentence_matcher.dart
///
/// Duolingo-style spoken-sentence matcher for a Flutter English app.
///
/// Design:
///   • Order-independent coverage. The learner can say words in any order;
///     each target word is matched the first time it's heard and STAYS matched
///     (sticky). The attempt passes once coverage reaches a threshold that is
///     deliberately below 100%.
///   • Per-word predicate is a 3-tier union, cheapest/surest first:
///         exact  ->  Double Metaphone (sound-alike)  ->  Dice >= 0.7 (spelling)
///     Any tier passing counts as a match. Words of 1-2 letters use exact only,
///     because short metaphone codes collide with too much.
///   • Contractions are NOT expanded. "I've" normalizes to "ive" and matches a
///     recognized "I've" on the exact tier, keeping a clean 1:1 word mapping.
///
/// No external dependencies. Pair with the `speech_to_text` package:
///
///   final matcher = SentenceMatcher("I've a brown wallet taken from Jake's bag");
///   final stopwatch = Stopwatch();
///   _speech.listen(
///     partialResults: true,
///     localeId: 'en_US',
///     onResult: (r) {
///       if (!stopwatch.isRunning) stopwatch.start();
///       final m = matcher.update(r.recognizedWords); // cumulative transcript
///       setState(() {
///         _tokens = m.tokens;          // per-word states for the highlight UI
///         _completion = m.completion;  // 0.0 .. 1.0 for the progress bar
///         _passed = m.passed;          // coverage >= threshold
///         _wpm = SentenceMatcher.wordsPerMinute(m.matchedCount, stopwatch.elapsed);
///       });
///     },
///   );
///
/// Run `dart run sentence_matcher.dart` to see the worked example at the bottom.

enum WordState { pending, matched }

/// One target word + its state, aligned 1:1 with the displayed sentence.
class TokenResult {
  final String display; // original word, punctuation kept ("Jake's")
  final WordState state;
  const TokenResult(this.display, this.state);
}

class MatchResult {
  final List<TokenResult> tokens;
  final int matchedCount; // real words heard (excludes punctuation-only)
  final int totalCount; // real words in the sentence
  final double passThreshold;
  const MatchResult(
    this.tokens,
    this.matchedCount,
    this.totalCount,
    this.passThreshold,
  );

  double get completion => totalCount == 0 ? 0 : matchedCount / totalCount;
  bool get passed => completion >= passThreshold;
}

class SentenceMatcher {
  /// Minimum Dice (bigram) similarity to accept two words as the same.
  final double diceThreshold;

  /// Coverage needed to count the whole attempt as correct. Below 1.0 on
  /// purpose — one missed word shouldn't fail a real read.
  final double passThreshold;

  final List<String> _display = []; // original words (UI)
  final List<String> _norm = []; // normalized words, 1:1 with _display
  final List<Set<String>> _codes = []; // cached metaphone codes per target word
  late List<bool> _matched;
  int _totalCountable = 0;

  SentenceMatcher(
    String target, {
    this.diceThreshold = 0.7,
    this.passThreshold = 0.8,
  }) {
    for (final w in _tokenize(target)) {
      final n = _normalizeWord(w);
      _display.add(w);
      _norm.add(n);
      _codes.add(n.length <= 2 ? const {} : _metaphoneCodes(n));
    }
    _totalCountable = _norm.where((n) => n.isNotEmpty).length;
    reset();
  }

  /// Clear progress for a fresh attempt at the same sentence.
  void reset() {
    _matched = List<bool>.filled(_norm.length, false);
    for (var j = 0; j < _norm.length; j++) {
      if (_norm[j].isEmpty) _matched[j] = true; // punctuation-only: auto
    }
  }

  /// Feed the full cumulative transcript on every (interim or final) callback.
  /// Matches are sticky, order-independent, and COUNT-CORRECT for repeated
  /// words: if the sentence has two "I"s, the first spoken "I" claims the
  /// first, and the second target "I" stays unmatched until "I" is heard a
  /// second time.
  ///
  /// We recompute from scratch each call (fresh array) so re-scanning the
  /// growing cumulative transcript can't double-count a single utterance, then
  /// OR the result into the sticky array so an interim revision never
  /// un-highlights a word that was already matched.
  MatchResult update(String recognized) {
    final recTokens = _tokenize(
      recognized,
    ).map(_normalizeWord).where((t) => t.isNotEmpty).toList();

    // Fresh, clean pass over the WHOLE transcript. Each spoken token claims at
    // most one target word, and occurrence N of a word claims occurrence N of
    // that word in the target (first-come, left-to-right).
    final fresh = List<bool>.generate(_norm.length, (j) => _norm[j].isEmpty);
    for (final r in recTokens) {
      final rc = r.length <= 2 ? null : _metaphoneCodes(r);
      for (var j = 0; j < _norm.length; j++) {
        if (fresh[j]) continue; // this occurrence already claimed
        if (_wordMatches(r, rc, _norm[j], _codes[j])) {
          fresh[j] = true;
          break; // one spoken word -> one target word
        }
      }
    }

    // Monotonic: keep anything a previous (interim) result had already matched.
    for (var j = 0; j < _norm.length; j++) {
      if (fresh[j]) _matched[j] = true;
    }
    return _result();
  }

  MatchResult _result() {
    final tokens = <TokenResult>[];
    var matched = 0;
    for (var j = 0; j < _display.length; j++) {
      final state = _matched[j] ? WordState.matched : WordState.pending;
      tokens.add(TokenResult(_display[j], state));
      if (_norm[j].isNotEmpty && _matched[j]) matched++;
    }
    return MatchResult(tokens, matched, _totalCountable, passThreshold);
  }

  // --- the 3-tier predicate ----------------------------------------------

  bool _wordMatches(String a, Set<String>? ac, String b, Set<String> bc) {
    if (a == b) return true; // tier 1: exact
    if (a.length <= 2 || b.length <= 2) return false; // short words: exact only
    if (ac != null && ac.intersection(bc).isNotEmpty)
      return true; // tier 2: sound
    if (_dice(a, b) >= diceThreshold) return true; // tier 3: spelling
    return false;
  }

  double _dice(String a, String b) {
    if (a == b) return 1;
    if (a.length < 2 || b.length < 2) return 0;
    final pairs = <String, int>{};
    for (var i = 0; i < a.length - 1; i++) {
      final bg = a.substring(i, i + 2);
      pairs[bg] = (pairs[bg] ?? 0) + 1;
    }
    var inter = 0;
    final total = (a.length - 1) + (b.length - 1);
    for (var i = 0; i < b.length - 1; i++) {
      final bg = b.substring(i, i + 2);
      final n = pairs[bg] ?? 0;
      if (n > 0) {
        inter++;
        pairs[bg] = n - 1;
      }
    }
    return 2 * inter / total;
  }

  // --- text utils ---------------------------------------------------------

  List<String> _tokenize(String s) =>
      s.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

  /// lowercase, drop punctuation & apostrophes. "I've" -> "ive",
  /// "Jake's" -> "jakes". Keeps a 1:1 mapping with the display word.
  String _normalizeWord(String w) =>
      w.toLowerCase().replaceAll(RegExp(r"[^a-z0-9']"), '').replaceAll("'", '');

  // --- scoring helper -----------------------------------------------------

  /// Reading pace: matched word count over time since they started speaking.
  static double wordsPerMinute(int words, Duration elapsed) {
    final minutes = elapsed.inMilliseconds / 60000.0;
    return minutes <= 0 ? 0 : words / minutes;
  }

  // --- Double Metaphone (port of Lawrence Philips' algorithm) -------------

  /// Returns the distinct, non-empty phonetic codes (primary + alternate).
  static Set<String> _metaphoneCodes(String word) {
    final primary = StringBuffer();
    final secondary = StringBuffer();
    final st = word.toUpperCase() + '      '; // pad so look-ahead is safe
    final length = word.length;
    final last = length - 1;
    final isSlavoGermanic =
        st.contains('W') ||
        st.contains('K') ||
        st.contains('CZ') ||
        st.contains('WITZ');

    String pc(int i) {
      var j = i < 0 ? i + st.length : i;
      if (j < 0 || j >= st.length) return ' ';
      return st[j];
    }

    String ps(int a, int b) {
      final L = st.length;
      var aa = a < 0 ? a + L : a;
      var bb = b < 0 ? b + L : b;
      if (aa < 0) aa = 0;
      if (aa > L) aa = L;
      if (bb < 0) bb = 0;
      if (bb > L) bb = L;
      if (aa >= bb) return '';
      return st.substring(aa, bb);
    }

    bool vowel(String c) => c.length == 1 && 'AEIOUY'.contains(c);
    bool inL(String s, List<String> opts) => opts.contains(s);
    void add(String p, [String? s]) {
      primary.write(p);
      secondary.write(s ?? p);
    }

    var current = 0;
    if (inL(ps(0, 2), ['GN', 'KN', 'PN', 'WR', 'PS'])) current += 1;
    if (pc(0) == 'X') {
      add('S');
      current += 1;
    }

    while (current < length && (primary.length < 4 || secondary.length < 4)) {
      final c = pc(current);

      if (vowel(c)) {
        if (current == 0) add('A');
        current += 1;
        continue;
      }
      if (c == 'B') {
        add('P');
        current += pc(current + 1) == 'B' ? 2 : 1;
        continue;
      }
      if (c == 'Ç') {
        add('S');
        current += 1;
        continue;
      }
      if (c == 'C') {
        if (current > 1 &&
            !vowel(pc(current - 2)) &&
            ps(current - 1, current + 2) == 'ACH' &&
            pc(current + 2) != 'I' &&
            (pc(current + 2) != 'E' ||
                inL(ps(current - 2, current + 4), ['BACHER', 'MACHER']))) {
          add('K');
          current += 2;
          continue;
        }
        if (current == 0 && ps(0, 6) == 'CAESAR') {
          add('S');
          current += 2;
          continue;
        }
        if (ps(current, current + 4) == 'CHIA') {
          add('K');
          current += 2;
          continue;
        }
        if (ps(current, current + 2) == 'CH') {
          if (current > 0 && ps(current, current + 4) == 'CHAE') {
            add('K', 'X');
            current += 2;
            continue;
          }
          if (current == 0 &&
              (inL(ps(current + 1, current + 6), ['HARAC', 'HARIS']) ||
                  inL(ps(current + 1, current + 4), [
                    'HOR',
                    'HYM',
                    'HIA',
                    'HEM',
                  ])) &&
              ps(0, 5) != 'CHORE') {
            add('K');
            current += 2;
            continue;
          }
          if (inL(ps(0, 4), ['VAN ', 'VON ']) ||
              ps(0, 3) == 'SCH' ||
              inL(ps(current - 2, current + 4), [
                'ORCHES',
                'ARCHIT',
                'ORCHID',
              ]) ||
              inL(pc(current + 2), ['T', 'S']) ||
              ((inL(pc(current - 1), ['A', 'O', 'U', 'E']) || current == 0) &&
                  inL(pc(current + 2), [
                    'L',
                    'R',
                    'N',
                    'M',
                    'B',
                    'H',
                    'F',
                    'V',
                    'W',
                    ' ',
                  ]))) {
            add('K');
          } else {
            if (current > 0) {
              if (ps(0, 2) == 'MC') {
                add('K');
              } else {
                add('X', 'K');
              }
            } else {
              add('X');
            }
          }
          current += 2;
          continue;
        }
        if (ps(current, current + 2) == 'CZ' &&
            ps(current - 2, current + 2) != 'WICZ') {
          add('S', 'X');
          current += 2;
          continue;
        }
        if (ps(current + 1, current + 4) == 'CIA') {
          add('X');
          current += 3;
          continue;
        }
        if (ps(current, current + 2) == 'CC' &&
            !(current == 1 && pc(0) == 'M')) {
          if (inL(pc(current + 2), ['I', 'E', 'H']) &&
              ps(current + 2, current + 4) != 'HU') {
            if ((current == 1 && pc(current - 1) == 'A') ||
                inL(ps(current - 1, current + 4), ['UCCEE', 'UCCES'])) {
              add('KS');
            } else {
              add('X');
            }
            current += 3;
            continue;
          } else {
            add('K');
            current += 2;
            continue;
          }
        }
        if (inL(ps(current, current + 2), ['CK', 'CG', 'CQ'])) {
          add('K');
          current += 2;
          continue;
        }
        if (inL(ps(current, current + 2), ['CI', 'CE', 'CY'])) {
          if (inL(ps(current, current + 3), ['CIO', 'CIE', 'CIA'])) {
            add('S', 'X');
          } else {
            add('S');
          }
          current += 2;
          continue;
        }
        add('K');
        if (inL(ps(current + 1, current + 3), [' C', ' Q', ' G'])) {
          current += 3;
        } else if (inL(pc(current + 1), ['C', 'K', 'Q']) &&
            !inL(ps(current + 1, current + 3), ['CE', 'CI'])) {
          current += 2;
        } else {
          current += 1;
        }
        continue;
      }
      if (c == 'D') {
        if (ps(current, current + 2) == 'DG') {
          if (inL(pc(current + 2), ['I', 'E', 'Y'])) {
            add('J');
            current += 3;
            continue;
          } else {
            add('TK');
            current += 2;
            continue;
          }
        }
        if (inL(ps(current, current + 2), ['DT', 'DD'])) {
          add('T');
          current += 2;
          continue;
        }
        add('T');
        current += 1;
        continue;
      }
      if (c == 'F') {
        add('F');
        current += pc(current + 1) == 'F' ? 2 : 1;
        continue;
      }
      if (c == 'G') {
        if (pc(current + 1) == 'H') {
          if (current > 0 && !vowel(pc(current - 1))) {
            add('K');
            current += 2;
            continue;
          }
          if (current == 0) {
            if (pc(current + 2) == 'I') {
              add('J');
            } else {
              add('K');
            }
            current += 2;
            continue;
          }
          if ((current > 1 && inL(pc(current - 2), ['B', 'H', 'D'])) ||
              (current > 2 && inL(pc(current - 3), ['B', 'H', 'D'])) ||
              (current > 3 && inL(pc(current - 4), ['B', 'H']))) {
            current += 2;
            continue;
          } else {
            if (current > 2 &&
                pc(current - 1) == 'U' &&
                inL(pc(current - 3), ['C', 'G', 'L', 'R', 'T'])) {
              add('F');
            } else if (current > 0 && pc(current - 1) != 'I') {
              add('K');
            }
            current += 2;
            continue;
          }
        }
        if (pc(current + 1) == 'N') {
          if (current == 1 && vowel(pc(0)) && !isSlavoGermanic) {
            add('KN', 'N');
          } else if (ps(current + 2, current + 4) != 'EY' &&
              pc(current + 1) != 'Y' &&
              !isSlavoGermanic) {
            add('N', 'KN');
          } else {
            add('KN');
          }
          current += 2;
          continue;
        }
        if (ps(current + 1, current + 3) == 'LI' && !isSlavoGermanic) {
          add('KL', 'L');
          current += 2;
          continue;
        }
        if (current == 0 &&
            (pc(current + 1) == 'Y' ||
                inL(ps(current + 1, current + 3), [
                  'ES',
                  'EP',
                  'EB',
                  'EL',
                  'EY',
                  'IB',
                  'IL',
                  'IN',
                  'IE',
                  'EI',
                  'ER',
                ]))) {
          add('K', 'J');
          current += 2;
          continue;
        }
        if ((ps(current + 1, current + 3) == 'ER' || pc(current + 1) == 'Y') &&
            !inL(ps(0, 6), ['DANGER', 'RANGER', 'MANGER']) &&
            !inL(pc(current - 1), ['E', 'I']) &&
            !inL(ps(current - 1, current + 2), ['RGY', 'OGY'])) {
          add('K', 'J');
          current += 2;
          continue;
        }
        if (inL(pc(current + 1), ['E', 'I', 'Y']) ||
            inL(ps(current - 1, current + 3), ['AGGI', 'OGGI'])) {
          if (inL(ps(0, 4), ['VAN ', 'VON ']) ||
              ps(0, 3) == 'SCH' ||
              ps(current + 1, current + 3) == 'ET') {
            add('K');
          } else {
            add('J', 'K');
          }
          current += 2;
          continue;
        }
        add('K');
        current += pc(current + 1) == 'G' ? 2 : 1;
        continue;
      }
      if (c == 'H') {
        if ((current == 0 || vowel(pc(current - 1))) &&
            vowel(pc(current + 1))) {
          add('H');
          current += 2;
        } else {
          current += 1;
        }
        continue;
      }
      if (c == 'J') {
        if (ps(current, current + 4) == 'JOSE' || ps(0, 4) == 'SAN ') {
          if ((current == 0 && pc(current + 4) == ' ') || ps(0, 4) == 'SAN ') {
            add('H');
          } else {
            add('J', 'H');
          }
          current += 1;
          continue;
        }
        if (current == 0 && ps(current, current + 4) != 'JOSE') {
          add('J', 'A');
        } else if (vowel(pc(current - 1)) &&
            !isSlavoGermanic &&
            inL(pc(current + 1), ['A', 'O'])) {
          add('J', 'H');
        } else if (current == last) {
          add('J', '');
        } else if (!inL(pc(current - 1), ['S', 'K', 'L']) &&
            !inL(pc(current + 1), ['L', 'T', 'K', 'S', 'N', 'M', 'B', 'Z'])) {
          add('J');
        }
        current += pc(current + 1) == 'J' ? 2 : 1;
        continue;
      }
      if (c == 'K') {
        add('K');
        current += pc(current + 1) == 'K' ? 2 : 1;
        continue;
      }
      if (c == 'L') {
        if (pc(current + 1) == 'L') {
          if ((current == length - 3 &&
                  inL(ps(current - 1, current + 3), [
                    'ILLO',
                    'ILLA',
                    'ALLE',
                  ])) ||
              ((inL(ps(last - 1, last + 1), ['AS', 'OS']) ||
                      inL(pc(last), ['A', 'O'])) &&
                  ps(current - 1, current + 3) == 'ALLE')) {
            add('L', '');
            current += 2;
            continue;
          }
          add('L');
          current += 2;
          continue;
        }
        add('L');
        current += 1;
        continue;
      }
      if (c == 'M') {
        if ((ps(current - 1, current + 2) == 'UMB' &&
                (current + 1 == last ||
                    ps(current + 2, current + 4) == 'ER')) ||
            pc(current + 1) == 'M') {
          current += 2;
        } else {
          current += 1;
        }
        add('M');
        continue;
      }
      if (c == 'N') {
        add('N');
        current += pc(current + 1) == 'N' ? 2 : 1;
        continue;
      }
      if (c == 'Ñ') {
        add('N');
        current += 1;
        continue;
      }
      if (c == 'P') {
        if (pc(current + 1) == 'H') {
          add('F');
          current += 2;
          continue;
        }
        add('P');
        current += inL(pc(current + 1), ['P', 'B']) ? 2 : 1;
        continue;
      }
      if (c == 'Q') {
        add('K');
        current += pc(current + 1) == 'Q' ? 2 : 1;
        continue;
      }
      if (c == 'R') {
        if (current == last &&
            !isSlavoGermanic &&
            ps(current - 2, current) == 'IE' &&
            !inL(ps(current - 4, current - 2), ['ME', 'MA'])) {
          add('', 'R');
        } else {
          add('R');
        }
        current += pc(current + 1) == 'R' ? 2 : 1;
        continue;
      }
      if (c == 'S') {
        if (inL(ps(current - 1, current + 2), ['ISL', 'YSL'])) {
          current += 1;
          continue;
        }
        if (current == 0 && ps(0, 5) == 'SUGAR') {
          add('X', 'S');
          current += 1;
          continue;
        }
        if (ps(current, current + 2) == 'SH') {
          if (inL(ps(current + 1, current + 5), [
            'HEIM',
            'HOEK',
            'HOLM',
            'HOLZ',
          ])) {
            add('S');
          } else {
            add('X');
          }
          current += 2;
          continue;
        }
        if (inL(ps(current, current + 3), ['SIO', 'SIA']) ||
            ps(current, current + 4) == 'SIAN') {
          if (!isSlavoGermanic) {
            add('S', 'X');
          } else {
            add('S');
          }
          current += 3;
          continue;
        }
        if ((current == 0 && inL(pc(current + 1), ['M', 'N', 'L', 'W'])) ||
            pc(current + 1) == 'Z') {
          add('S', 'X');
          current += pc(current + 1) == 'Z' ? 2 : 1;
          continue;
        }
        if (ps(current, current + 2) == 'SC') {
          if (pc(current + 2) == 'H') {
            if (inL(ps(current + 3, current + 5), [
              'OO',
              'ER',
              'EN',
              'UY',
              'ED',
              'EM',
            ])) {
              if (inL(ps(current + 3, current + 5), ['ER', 'EN'])) {
                add('X', 'SK');
              } else {
                add('SK');
              }
              current += 3;
              continue;
            } else {
              if (current == 0 && !vowel(pc(3)) && pc(3) != 'W') {
                add('X', 'S');
              } else {
                add('X');
              }
              current += 3;
              continue;
            }
          }
          if (inL(pc(current + 2), ['I', 'E', 'Y'])) {
            add('S');
            current += 3;
            continue;
          }
          add('SK');
          current += 3;
          continue;
        }
        if (current == last && inL(ps(current - 2, current), ['AI', 'OI'])) {
          add('', 'S');
        } else {
          add('S');
        }
        current += inL(pc(current + 1), ['S', 'Z']) ? 2 : 1;
        continue;
      }
      if (c == 'T') {
        if (ps(current, current + 4) == 'TION') {
          add('X');
          current += 3;
          continue;
        }
        if (inL(ps(current, current + 3), ['TIA', 'TCH'])) {
          add('X');
          current += 3;
          continue;
        }
        if (ps(current, current + 2) == 'TH' ||
            ps(current, current + 3) == 'TTH') {
          if (inL(ps(current + 2, current + 4), ['OM', 'AM']) ||
              inL(ps(0, 4), ['VAN ', 'VON ']) ||
              ps(0, 3) == 'SCH') {
            add('T');
          } else {
            add('0', 'T');
          }
          current += 2;
          continue;
        }
        add('T');
        current += inL(pc(current + 1), ['T', 'D']) ? 2 : 1;
        continue;
      }
      if (c == 'V') {
        add('F');
        current += pc(current + 1) == 'V' ? 2 : 1;
        continue;
      }
      if (c == 'W') {
        if (ps(current, current + 2) == 'WR') {
          add('R');
          current += 2;
          continue;
        }
        if (current == 0 &&
            (vowel(pc(current + 1)) || ps(current, current + 2) == 'WH')) {
          if (vowel(pc(current + 1))) {
            add('A', 'F');
          } else {
            add('A');
          }
        }
        if ((current == last && vowel(pc(current - 1))) ||
            inL(ps(current - 1, current + 4), [
              'EWSKI',
              'EWSKY',
              'OWSKI',
              'OWSKY',
            ]) ||
            ps(0, 3) == 'SCH') {
          secondary.write('F');
          current += 1;
          continue;
        }
        if (inL(ps(current, current + 4), ['WICZ', 'WITZ'])) {
          add('TS', 'FX');
          current += 4;
          continue;
        }
        current += 1;
        continue;
      }
      if (c == 'X') {
        if (!(current == last &&
            (inL(ps(current - 3, current), ['IAU', 'EAU']) ||
                inL(ps(current - 2, current), ['AU', 'OU'])))) {
          add('KS');
        }
        current += inL(pc(current + 1), ['C', 'X']) ? 2 : 1;
        continue;
      }
      if (c == 'Z') {
        if (pc(current + 1) == 'H') {
          add('J');
        } else if (inL(ps(current + 1, current + 3), ['ZO', 'ZI', 'ZA']) ||
            (isSlavoGermanic && current > 0 && pc(current - 1) != 'T')) {
          add('S', 'TS');
        } else {
          add('S');
        }
        current += pc(current + 1) == 'Z' ? 2 : 1;
        continue;
      }
      current += 1;
    }

    String trim(String s) => s.length > 4 ? s.substring(0, 4) : s;
    final codes = <String>{
      trim(primary.toString()),
      trim(secondary.toString()),
    };
    codes.removeWhere((c) => c.isEmpty);
    return codes;
  }
}

// --- quick sanity check: `dart run sentence_matcher.dart` -----------------
void main() {
  final m = SentenceMatcher(
    "I can try rewriting it, but some help would be great if I get stuck",
  );

  void show(String label, MatchResult r) {
    final lit = [
      for (final t in r.tokens)
        if (t.state == WordState.matched) t.display,
    ];
    print(
      '$label  ${r.matchedCount}/${r.totalCount} '
      '(${(r.completion * 100).toStringAsFixed(0)}%) passed=${r.passed}',
    );
    print('   lit: ${lit.join(' ')}');
  }

  // Say just "I" once -> only the FIRST "I" lights up, second stays dark.
  show('after "I":        ', m.update("I"));

  // Read it all (note the second "I" in "if I get") -> both "I"s now match,
  // even with "rewriting" misheard as "rewritting".
  show(
    'after full read:  ',
    m.update(
      "I can try rewritting it but some help would be great if I get stuck",
    ),
  );
}
