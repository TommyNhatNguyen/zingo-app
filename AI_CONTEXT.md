# Zingo (Lingo Snack) — Flutter App: AI Implementation Context

> **Purpose:** This document is the single source of truth for any AI session continuing work on the Flutter front-end.  
> It is synthesized from the full product specification, backend architecture, sprint plan, STT spec, UML diagrams, and the current codebase state as of 2026-05-15.

---

## 1. What This App Is

**Lingo Snack (codename: zingo)** — a Flutter mobile app (iOS + Android) for English speaking practice.

Core loop:
1. Learner picks a dialog (short AI-scripted conversation)
2. App plays AI character lines via pre-generated TTS audio
3. Learner records their response; on-device STT transcribes it in real time
4. Transcript sent to backend; scoring pipeline (embed → pgvector similarity → GPT-4o-mini) returns per-turn scores for Grammar, Naturalness, Completeness
5. Session ends with a holistic score + AI-generated paragraph feedback
6. Gamification: streak, XP, badges reward daily practice

**Out of scope (v1):** reading/writing, languages other than English, offline mode, live human conversations.

---

## 2. Implementation Status (as of 2026-05-15)

### Done

| Screen / Feature | File | Notes |
|-----------------|------|-------|
| Splash screen | `lib/screens/splash/splash_screen.dart` | Handles initial auth routing |
| Login screen | `lib/screens/auth/login_screen.dart` | Email+password + Google OAuth |
| Register screen | `lib/screens/auth/register_screen.dart` | Creates Firebase + backend user |
| Onboarding screen | `lib/screens/onboarding/onboarding_screen.dart` | 6-step PageView (name, native lang, topics, daily goal, reminder time, CEFR level) |
| User profile/settings | `lib/screens/users/user_profile_screen.dart` | Full settings edit + logout |
| AuthBloc | `lib/blocs/auth/` | Email login, Google login, Firebase auth state stream, logout |
| UserProfileCreateBloc | `lib/blocs/user-profile/` | Onboarding form submission |
| UserSettingsBloc | `lib/blocs/user-settings/` | Load + save profile settings + topics + CEFR |
| UsersBloc | `lib/blocs/users/` | Register user on backend |
| Models | `lib/models/users.dart`, `lib/models/user_profile.dart` | Users, UserProfile |
| Services | `lib/services/` | AuthService, UserService, UserProfileService, UserTopicPreferencesService |
| Design system | `lib/config/` | AppColors, AppTextStyles, AppTheme, Dio, Firebase config |
| Constants | `lib/constants/` | EnglishLevel, Languages, Topics, PracticeGoal, NotificationTime |
| Shared widgets | `lib/widgets/` | CardSelect, EnglishLevelPicker, LanguagesPicker, FavoriteTopicsPicker, TimePicker |
| Routing | `lib/routes/init.dart` | GoRouter with auth guard |

### Home Screen Status
`lib/screens/home/home_screen.dart` is a **placeholder** — currently just navigation buttons for development. It needs full implementation (see Section 10).

### Learn Screen
`lib/screens/learn/learn_screen.dart` exists but is **not yet registered in the router** and needs implementation.

### Not Yet Built
- Dialog list/browse screen
- Dialog detail screen  
- Practice session screen (the core feature)
- Per-turn score card widget
- Holistic session summary screen
- Replay session mode
- Progress dashboard (streak chart, radar chart, weak spots)
- Dialog history screen
- `TurnRecorder` class (dual-track STT + audio recording)
- DialogBloc + DialogService
- SessionBloc + SessionService
- ProgressBloc + ProgressService
- Bottom navigation bar (home, learn/browse, progress, profile)

---

## 3. Flutter Architecture Rules

**State management:** BLoC (`flutter_bloc`). Every feature gets its own bloc subdirectory in `lib/blocs/`. Screens consume blocs via `BlocProvider` / `BlocBuilder` / `BlocConsumer`. Blocs are never created inside screens — they are provided via GoRoute's `pageBuilder`.

**Routing:** GoRouter (`lib/routes/init.dart`). Navigation uses `context.go()` / `context.push()`. Auth guard in `redirect` callback reads `AuthBloc.state.user`. New routes must be added to `buildRoutes()`.

**Networking:** Dio singleton at `lib/config/dio_http.dart`. The `_FirebaseAuthInterceptor` automatically attaches Firebase JWT to every request. API calls go through service classes only — never call `dio` directly from BLoCs or screens.

**Serialization:** `json_serializable` + `json_annotation`. All DTOs in `lib/dtos/` carry `@JsonSerializable()`. After editing any DTO, run:
```bash
dart run build_runner build --delete-conflicting-outputs --force-jit
```

**API response shape:** All backend responses are wrapped in `ApiResponse` (`lib/interfaces/api_response.dart`):
```dart
{ "success": true/false, "data": {...}, "error": "..." }
```

---

## 4. Directory Intent

```
lib/
├── config/         Design system (colors, text styles, theme, dio, firebase). No logic.
├── constants/      App-wide enums and data lists (languages, topics, levels, etc.)
├── interfaces/     Abstract service contracts + ApiResponse wrapper
├── services/       Concrete implementations (Dio calls, Firebase, etc.)
├── blocs/          BLoC classes — one subdirectory per feature
├── models/         Domain models (pure Dart, @JsonSerializable)
├── dtos/           API request/response objects (@JsonSerializable)
├── widgets/        Shared/reusable widgets only — no screen-specific widgets here
├── screens/        One subdirectory per feature; each screen owns its local widgets
└── routes/         GoRouter init.dart only
```

---

## 5. Design System

### Colors (`lib/config/app_colors.dart`)

```dart
// Brand
AppColors.primary         // #0891B2 ocean teal — primary actions, links
AppColors.primaryLight    // #22B9D4
AppColors.primaryDark     // #0E7490
AppColors.primaryContainer // #E0F7FB — selected state backgrounds

AppColors.accent          // #FF7043 deep orange — CTAs, streak flame, "start now"
AppColors.accentLight     // #FF9068
AppColors.accentContainer // #FFF0EB

AppColors.highlight       // #FFB800 warm gold — XP, rewards, celebration
AppColors.highlightContainer // #FFF8E0

// Backgrounds
AppColors.background      // #F5FCFD barely-cyan tint — scaffold background
AppColors.surface         // #FFFFFF
AppColors.surfaceVariant  // #EBF8FA — input fill, chip background

// Text
AppColors.textPrimary     // #0C2D36 deep ocean
AppColors.textSecondary   // #4F7D88
AppColors.textDisabled    // #A8C9D0
AppColors.textOnPrimary   // #FFFFFF
AppColors.textOnAccent    // #FFFFFF
AppColors.textOnHighlight // #0C2D36

// Score bars (traffic light)
AppColors.scoreHigh       // #22C55E green  — 80–100
AppColors.scoreMid        // #F59E0B amber  — 50–79
AppColors.scoreLow        // #EF4444 red    — 0–49

// Gamification
AppColors.streak          // #FF7043 orange flame
AppColors.xp              // #FFB800 gold
AppColors.badge           // #22C55E green

// Utility
AppColors.divider         // #DFF2F5
AppColors.border          // #C8E8ED
AppColors.shadow          // primary at 10% opacity
```

**Score bar color helper:**
```dart
Color scoreColor(num score) {
  if (score >= 80) return AppColors.scoreHigh;
  if (score >= 50) return AppColors.scoreMid;
  return AppColors.scoreLow;
}
```

### Typography (`lib/config/app_text_styles.dart`)
Font: **Plus Jakarta Sans** (via `google_fonts`). Always use `Theme.of(context).textTheme.*` for standard M3 roles. Use `AppTextStyles.*` only for specialised styles:

| Style | Usage | Size/Weight |
|-------|-------|-------------|
| `AppTextStyles.scoreNumber` | Per-turn score (78/100) | 28px w800 |
| `AppTextStyles.dialogLine` | Dialog line text | 17px w400 h1.7 |
| `AppTextStyles.streakCounter` | Streak count badge | 15px w800 accent |
| `AppTextStyles.xpCounter` | XP count badge | 15px w800 gold |
| `AppTextStyles.feedbackQuote` | Score feedback tips | 14px w500 italic secondary |
| `AppTextStyles.callToAction` | Motivational labels | 15px w700 primary |

### Theme
`AppTheme.light` is passed to `MaterialApp.router`. Do not create a second `ThemeData`. The theme sets:
- All button styles (ElevatedButton: full-width 56h, radius 18; OutlinedButton: same; TextButton: primary color)
- Card: `elevation: 0`, border `AppColors.divider`, radius 20
- Input: filled, surfaceVariant, radius 12, focused border primary
- Chip: radius 10, selectedColor primaryContainer
- ProgressIndicator: primary, height 10, radius 10
- BottomNavigationBar: surface, selectedItemColor primary
- SnackBar: floating, radius 16, textPrimary background

---

## 6. Routing (Current State)

```
/splash      → SplashScreen               (no auth required)
/login       → LoginScreen                (no auth required)
/register    → RegisterScreen             (UsersBloc provided)
/onboarding  → OnboardingScreen           (UserProfileCreateBloc provided)
/home        → HomeScreen                 (requires auth)
/profile     → UserProfileScreen          (UserSettingsBloc provided; auto-loads settings)
```

**Auth guard logic in GoRouter redirect:**
- `user != null && /splash` → redirect to `/home`
- `user == null && not (splash/login/register)` → redirect to `/login`

**Adding new routes:** Add to `buildRoutes()` in `lib/routes/init.dart`. Provide BLoCs in the `pageBuilder` using `BlocProvider`.

---

## 7. Existing Models & DTOs

### `Users` (`lib/models/users.dart`)
Backend user record (maps to `users` DB table):
```dart
String id           // Firebase UID (also backend primary key)
String user_uid     // Firebase UID (redundant — backend uses id)
String email
String username
String cefr_level   // "A1" | "A2" | "B1" | "B2" | "C1" | "C2"
String level        // "beginner" | "intermediate" | "expert"
int xp
int streak
DateTime? last_practice_at
DateTime created_at
```

### `UserProfile` (`lib/models/user_profile.dart`)
Maps to `user_settings` table:
```dart
String user_id
String? display_name
String? mother_language
String? display_language
int? practice_goal_per_day
String? notification_time   // "HH:MM" format
```

### DTOs in `lib/dtos/`
| DTO | Purpose |
|-----|---------|
| `LoginDto` | `{ email, password }` |
| `RegisterDto` | `{ email, password }` |
| `UsersCreateDto` | `{ email, password, username }` → `POST /v1/register` |
| `UsersUpdateDto` | `{ cefr_level?, level? }` → `PUT /v1/users/:id` |
| `UserProfileCreateDto` | Full onboarding payload — see fields below |
| `UserProfileUpdateDto` | `{ display_name?, mother_language?, display_language?, practice_goal_per_day?, notification_time? }` |
| `UserTopicsSetDto` | `{ user_id, topic_codes: [] }` |

`UserProfileCreateDto` fields:
```dart
String user_id, String cefr_level (EnglishLevel enum value), String display_name,
String mother_language, String display_language, int practice_goal_per_day,
String? notification_time, List<String> favorite_topics
```

---

## 8. BLoC Patterns

All BLoCs follow the same pattern:

```
lib/blocs/<feature>/
  <feature>_bloc.dart   // extends Bloc<Event, State>
  <feature>_event.dart  // sealed class or abstract class
  <feature>_state.dart  // immutable with copyWith
```

**State shape convention:**
```dart
class XxxState {
  final RequestStatus loadStatus;   // or requestStatus
  final RequestStatus saveStatus;   // if separate load/save
  final SomeModel? data;
  final String? error;
  // ... other state fields
  
  const XxxState({...});
  XxxState copyWith({...}) {...}
  static XxxState initial() => const XxxState(loadStatus: RequestStatus.initial);
}
```

`RequestStatus` enum: `initial | loading | success | error` (in `lib/constants/enums.dart`)

**BLoC wiring in routes:**
```dart
GoRoute(
  path: '/some-route',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: BlocProvider(
      create: (_) => SomeBloc()..add(SomeInitEvent()),
      child: const SomeScreen(),
    ),
  ),
),
```

---

## 9. Services & API Calls

**Base URL:** `http://localhost:3000` (dev). Load from `.env` via `flutter_dotenv` for production.

**Auth:** `_FirebaseAuthInterceptor` in `lib/config/dio_http.dart` auto-attaches `Authorization: Bearer <firebase_token>` to every request. All protected endpoints need a valid Firebase JWT.

### Existing Services

| Service | File | Endpoints |
|---------|------|-----------|
| `AuthService` | `lib/services/auth_service.dart` | Firebase-only (email/Google sign-in) |
| `UserService` | `lib/services/user_service.dart` | `POST /v1/register`, `GET /v1/users/uid/:uid`, `PUT /v1/users/:id` |
| `UserProfileService` | `lib/services/user_profile_service.dart` | Create/update `user_settings` |
| `UserTopicPreferencesService` | `lib/services/user_topic_preferences_service.dart` | Set favorite topics |

### Backend API Contract (Full)

All routes require Firebase JWT except register.

```
# Users
POST   /v1/register                    → create user (email/username/password)
POST   /v1/users/me                    → upsert user on every login
GET    /v1/users/me                    → current user profile
PATCH  /v1/users/me                    → update level
GET    /v1/users/uid/:uid              → get user by Firebase UID
GET    /v1/users/me/settings           → get profile settings
PUT    /v1/users/me/settings           → create/replace settings
PATCH  /v1/users/me/settings           → partial update settings

# Dialogs
GET    /v1/dialogs                     → paginated list; filters: level, topic_id, duration, language, variation_type
GET    /v1/dialogs/favorite-topic      → dialogs matching authed user's favorite topic
GET    /v1/dialogs/:id                 → full dialog detail with ordered turns

# Sessions
POST   /v1/sessions                    → { dialog_id } → create session, returns { session_id, turns[] }
POST   /v1/sessions/:id/turns          → { turn_id, audio_transcript, attempt_number, response_audio_url?, response_time_ms? }
POST   /v1/sessions/:id/complete       → generates holistic score + feedback
GET    /v1/sessions/:id                → session + all final turns with scores
PATCH  /v1/sessions/:id               → { status: 'abandoned' }
GET    /v1/sessions                    → list user's past sessions

# Progress
GET    /v1/users/me/stats              → streak, xp, session count, avg dimension scores
GET    /v1/users/me/history            → practiced dialogs with last_score + best_score + attempts

# Admin (require admin role)
POST   /v1/admin/generate              → fire-and-forget dialog generation
GET    /v1/admin/dialogs               → all dialogs (any status)
GET    /v1/admin/dialogs/:id           → dialog detail
PATCH  /v1/admin/dialogs/:id/status   → { status: 'active' | 'inactive' }
```

---

## 10. Home Screen — What to Build

The current `lib/screens/home/home_screen.dart` is a placeholder. The real home screen should:

1. **App bar:** App logo/name + streak badge (flame + count) + XP badge (star + count)
2. **Favorite topic section** — horizontal scroll of `DialogCard` widgets for the user's chosen topic
3. **Continue practicing section** — last dialog with incomplete/replay state
4. **Recommended dialogs section** — 3 dialogs targeting weak spot (Phase 2)
5. **Browse all CTA** — links to the full dialog list screen

Navigation structure should be a `BottomNavigationBar` with tabs:
- Home (house icon) → `HomeScreen`
- Learn (book icon) → Dialog browse/list screen
- Progress (chart icon) → Progress dashboard
- Profile (person icon) → `UserProfileScreen`

---

## 11. Dialog Models to Create

Create these in `lib/models/`:

```dart
// lib/models/dialog.dart
@JsonSerializable()
class Dialog {
  final String id;
  final String title;
  final String? description;
  final String topicName;       // JOIN from topics table
  final String level;           // "beginner" | "intermediate" | "expert"
  final String duration;        // "short" | "mid" | "long"
  final String language;
  final String? variationType;
  final String? variationValue;
  final int turnCount;
  final double? lastScore;      // from user_dialog_progress
  final double? bestScore;
}

// lib/models/dialog_turn.dart
@JsonSerializable()
class DialogTurn {
  final String id;
  final String dialogId;
  final int turnOrder;
  final String speaker;         // "ai" | "user"
  final String lineText;
  final String? ttsAudioUrl;    // only for AI turns
  final String? contextNote;
  // NOTE: expected_answer and expected_embedding are NEVER sent to client
}

// lib/models/practice_session.dart
@JsonSerializable()
class PracticeSession {
  final String id;
  final String dialogId;
  final String userId;
  final double? holisticScore;
  final String? holisticFeedback;
  final String status;          // "in_progress" | "completed" | "abandoned"
  final List<DialogTurn> turns; // full dialog turns returned on session create
}

// lib/models/session_turn_result.dart
@JsonSerializable()
class SessionTurnResult {
  final double grammarScore;
  final double naturalnessScore;
  final double completenessScore;
  final double similarityScore;
  final double compositeScore;
  final FeedbackJson feedbackJson;
  final bool isBest;
}

@JsonSerializable()
class FeedbackJson {
  final String grammar;
  final String naturalness;
  final String completeness;
}
```

---

## 12. Practice Session — Core Feature

This is the most important feature. Architecture:

### State Machine
```
IDLE → INITIALIZING → AI_SPEAKING ↔ (replay)
AI_SPEAKING → USER_TURN → RECORDING → PROCESSING → SCORE_SHOWN
SCORE_SHOWN → USER_TURN (re-record) or AI_SPEAKING (continue) or HOLISTIC_SCORING (last turn)
HOLISTIC_SCORING → COMPLETED
COMPLETED → REPLAY or IDLE
```

### SessionBloc
```
lib/blocs/session/
  session_bloc.dart
  session_event.dart
  session_state.dart
```

Events:
- `SessionStarted(dialogId)` → calls `POST /v1/sessions`, loads turns
- `SessionAITurnPlayed(turnIndex)` → advances to user turn
- `SessionRecordingStarted()` → starts TurnRecorder
- `SessionRecordingStopped()` → stops recording, sends transcript to API
- `SessionTurnScored(result)` → shows score card
- `SessionTurnRerecorded()` → goes back to recording state for same turn
- `SessionTurnAdvanced()` → moves to next turn
- `SessionCompleted()` → calls `POST /v1/sessions/:id/complete`
- `SessionAbandoned()` → calls `PATCH /v1/sessions/:id { status: 'abandoned' }`

State fields:
```dart
PracticeSession? session
List<DialogTurn> turns
int currentTurnIndex
SessionPhase phase           // enum matching the state machine above
SessionTurnResult? lastScore  // score for current turn
int currentAttemptNumber
double? holisticScore
String? holisticFeedback
bool isLoadingScore
String? error
```

### SessionService (`lib/services/session_service.dart`)
```dart
Future<PracticeSession> createSession(String dialogId)
Future<SessionTurnResult> scoreTurn(String sessionId, ScoreTurnDto payload)
Future<HolisticResult> completeSession(String sessionId)
Future<void> abandonSession(String sessionId)
```

### TurnRecorder (`lib/services/turn_recorder.dart`)
Dual-track recording — runs STT and audio recording in parallel:

```dart
import 'package:speech_to_text/speech_to_text.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class TurnResult {
  final String transcript;
  final String localAudioPath;
  final bool isEmpty;
}

class TurnRecorder {
  final SpeechToText _stt = SpeechToText();
  final AudioRecorder _recorder = AudioRecorder();
  String _transcript = '';
  String? _localAudioPath;

  Future<void> initialize() async {
    await _stt.initialize();
  }

  Future<void> startTurn() async {
    final dir = await getApplicationDocumentsDirectory();
    _localAudioPath = '${dir.path}/turn_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _transcript = '';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: _localAudioPath!,
    );

    await _stt.listen(
      onResult: (result) { _transcript = result.recognizedWords; },
      pauseFor: const Duration(seconds: 8),   // CRITICAL for Android
      listenFor: const Duration(seconds: 45), // safety cap
      localeId: 'en_US',
      partialResults: true,
    );
  }

  Stream<String> get transcriptStream => /* stream of partial results */;

  Future<TurnResult> stopTurn() async {
    _stt.stop();
    await _recorder.stop();
    if (_transcript.trim().isEmpty) {
      return TurnResult(transcript: '', localAudioPath: _localAudioPath!, isEmpty: true);
    }
    return TurnResult(transcript: _transcript, localAudioPath: _localAudioPath!, isEmpty: false);
  }
}
```

**Required pubspec.yaml additions:**
```yaml
speech_to_text: ^7.0.0
record: ^5.0.0
path_provider: ^2.0.0
permission_handler: ^11.0.0
just_audio: ^0.9.0    # for TTS audio playback from Firebase Storage
```

**iOS Info.plist:**
```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>Lingo Snack uses speech recognition to evaluate your English responses.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Lingo Snack needs your microphone to record your spoken responses.</string>
```

**Android AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

**Important platform notes:**
- Android STT stops after ~3s silence — always set `pauseFor: Duration(seconds: 8)`
- iOS STT is fully on-device, Android routes through Google (needs internet)
- If `_transcript.isEmpty` after stop → show "We couldn't hear you. Try again." — do NOT send empty transcript to backend

---

## 13. Per-Turn Score Card Widget

Create as a shared widget at `lib/widgets/score_card.dart`.

Design spec:
- Shows 3 score bars: Grammar, Naturalness, Completeness
- Each bar: dimension label + numeric score (0–100) + colored progress bar
- Color: `AppColors.scoreHigh` (≥80), `AppColors.scoreMid` (50–79), `AppColors.scoreLow` (<50)
- One-sentence feedback below each bar (italic, `AppTextStyles.feedbackQuote`)
- Bottom: "Continue →" + "Re-record" buttons
- Optional "Hear Model Answer" button (Phase 2)
- "New best! ✓" badge when re-record beats previous score

Score bar colors per SRS (FR-SCR-08):
- 0–50: red (`AppColors.scoreLow`)
- 51–74: orange (`AppColors.scoreMid`)
- 75–89: blue (use `AppColors.primaryLight`)
- 90–100: green (`AppColors.scoreHigh`)

---

## 14. Dialog Card Widget

Create at `lib/widgets/dialog_card.dart`. Used in browse list and home screen.

Shows:
- Dialog title (h3)
- Topic name (labelSmall, secondary)
- Level badge (chip: Beginner/Intermediate/Expert)
- Duration badge (chip: Short/Mid/Long)
- Turn count
- If previously practiced: last score and best score as colored percentage badges
- Tapping navigates to dialog detail screen

---

## 15. Gamification Display

**Streak badge:** flame icon (`Icons.local_fire_department_rounded`) + count, using `AppColors.streak`, `AppTextStyles.streakCounter`

**XP badge:** star icon (`Icons.star_rounded`) + count, using `AppColors.xp`, `AppTextStyles.xpCounter`

**Score bars:** `LinearProgressIndicator` styled via `progressIndicatorTheme` (already configured), with dynamic color override per score value.

---

## 16. Constants Available

```dart
// lib/constants/enums.dart
enum RequestStatus { initial, loading, success, error }
enum EnglishLevel { A1, A2, B1, B2, C1, C2 }
// .value = "A1" etc, .label = "Beginner" etc, .description = "..."

// lib/constants/languages.dart
class Language { String code, String name, String nativeName, String flag }
Language.all  // full list

// lib/constants/topics.dart
class TopicCategory { String code, String name, String emoji }
TopicCategory.all  // all topics

// lib/constants/practice_goal.dart
class PracticeGoal { int value, String label, String description, String emoji }
PracticeGoal.all

// lib/constants/notification_time.dart
class NotificationTime { String label, String emoji, TimeOfDay value }
NotificationTime.all

// lib/constants/english_level.dart
class EnglishLevel { EnglishLevel code, String name, String description }
EnglishLevel.all
```

---

## 17. Data Flow: Scoring Pipeline (Flutter Side)

```
1. User taps record → SessionBloc emits RECORDING state
2. TurnRecorder.startTurn() → both STT and audio recording begin
3. Live transcript shows in UI via stream (grey italic text)
4. User taps stop → TurnRecorder.stopTurn() → returns TurnResult
5. If transcript.isEmpty → show "couldn't hear you" → stay in RECORDING state
6. Else → SessionBloc dispatches SessionRecordingStopped
7. BLoC calls SessionService.scoreTurn(sessionId, { turn_id, audio_transcript, attempt_number })
8. Show loading state (spinner over score card area)
9. Response arrives (~1.5s) → SessionTurnResult
10. BLoC emits SCORE_SHOWN state with result
11. Score card appears with Grammar/Naturalness/Completeness bars + feedback
12. Audio file saved locally at localAudioPath for replay (never uploaded)
```

---

## 18. Scoring System Reference

**Composite score:** `(grammar + naturalness + completeness + similarity×100) / 4`

**Dimensions:**
| Dimension | What it measures |
|-----------|-----------------|
| Grammar (0–100) | Grammatical correctness |
| Naturalness (0–100) | How native-like/fluent |
| Completeness (0–100) | Whether required meaning was communicated |
| Similarity (0–1 → ×100) | Cosine similarity to expected answer embedding |

**XP formula:** `avg_turn_score × difficulty_multiplier`  
Multipliers: Beginner ×1, Intermediate ×1.5, Expert ×2

---

## 19. Dialog Detail Screen

Route: `/dialogs/:id`

Shows:
- Title, topic, level, duration, turn count
- Description (scenario context paragraph)
- Last score + best score (if previously practiced)
- "Start Practice" button → creates session → navigates to session screen

---

## 20. Progress Dashboard (Phase 2)

Screen: `/progress`

Contains:
- Line chart: holistic score over last 30 sessions
- Radar chart: avg Grammar / Naturalness / Completeness
- Streak display + milestone celebrations at 3/7/14/30 days
- Total sessions count
- Weak spot label + 3 targeted recommended dialogs
- XP progress bar toward next level

Data source: `GET /v1/users/me/stats`

---

## 21. Key Conventions

- **Never hardcode colors, font sizes, or font weights.** Always use `AppColors.*` or `Theme.of(context).textTheme.*`
- **Never call `dio` directly from BLoCs or screens.** Only through service classes.
- **BLoC events are dispatched from screens.** BLoCs call services. Services call APIs.
- **All new DTOs** go in `lib/dtos/<feature>/` and must be run through `build_runner` after editing.
- **Loading states** must be shown for all operations exceeding 500ms (NFR-USE-02).
- **Empty states** must be handled gracefully — no naked null crashes.
- **Score card** must appear within 5 seconds of stopping recording (NFR-USE-01).
- **Audio files** stay on device — never upload user recordings to any server.
- **expected_answer** and **expected_embedding** are never sent from backend to client.

---

## 22. Next Features to Implement (Priority Order)

### Sprint Now: Core Dialog + Session Loop
1. **Dialog models + DTOs** — `Dialog`, `DialogTurn` models + `CreateSessionDto`, `ScoreTurnDto`, `HolisticResultDto`
2. **DialogService** — `listDialogs(filters)`, `getDialog(id)`
3. **DialogBloc** — load list with filters, load detail
4. **Dialog list screen** (`/learn`) — with filter chips (level/topic/duration) + `DialogCard` widgets + infinite scroll
5. **Dialog detail screen** (`/dialogs/:id`) — show description, last/best score, "Start Practice" CTA
6. **TurnRecorder service** — dual-track STT + audio (see Section 12)
7. **SessionBloc** — full state machine (see Section 12)
8. **SessionService** — API calls for session lifecycle
9. **Practice session screen** (`/session/:id`) — AI turn player + recording UI + score card
10. **Holistic score screen** — session summary with paragraph feedback + XP/streak update
11. **Home screen** — real implementation with favorite topic section + bottom nav

### Phase 2 (after core loop works)
- Replay mode (play local audio + show score overlays)
- Re-record from replay
- Hear model answer
- Dialog history screen (`/history`)
- Progress dashboard (`/progress`)
- XP + badges

---

## 23. Backend is on Node.js (Fastify + Drizzle + PostgreSQL + pgvector)

The Flutter app only communicates with the backend via REST. The backend handles:
- Firebase JWT verification (every route)
- Embedding user transcripts (text-embedding-3-small)
- pgvector cosine similarity
- GPT-4o-mini scoring
- Holistic session feedback generation
- Streak and XP updates
- TTS audio (pre-generated, stored in Firebase Storage)

The Flutter app handles:
- On-device STT (`speech_to_text` package)
- Local audio recording for replay (`record` package)
- TTS playback from Firebase Storage URLs
- Firestore real-time session state sync (optional, Phase 2)

---

*Last updated: 2026-05-15. Reflects codebase state after auth, onboarding, and profile settings screens are complete. Next: dialog browse + session core loop.*
