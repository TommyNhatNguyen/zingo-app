import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  static final TranslationService instance = TranslationService._();
  TranslationService._();

  final _modelManager = OnDeviceTranslatorModelManager();
  final Map<TranslateLanguage, OnDeviceTranslator> _translators = {};
  final Map<String, String> _cache = {};

  TranslateLanguage? _languageFromCode(String code) {
    try {
      return TranslateLanguage.values.firstWhere((l) => l.bcpCode == code);
    } catch (_) {
      return null;
    }
  }

  Future<String?> translate(String text, String targetLanguageCode) async {
    if (text.isEmpty) return null;

    final target = _languageFromCode(targetLanguageCode);
    if (target == null || target == TranslateLanguage.english) return null;

    final cacheKey = '$targetLanguageCode|$text';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey];

    try {
      final isDownloaded = await _modelManager.isModelDownloaded(
        target.bcpCode,
      );
      if (!isDownloaded) await _modelManager.downloadModel(target.bcpCode);

      _translators[target] ??= OnDeviceTranslator(
        sourceLanguage: TranslateLanguage.english,
        targetLanguage: target,
      );

      final result = await _translators[target]!.translateText(text);
      _cache[cacheKey] = result;
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<void> close() async {
    for (final translator in _translators.values) {
      await translator.close();
    }
    _translators.clear();
  }
}
