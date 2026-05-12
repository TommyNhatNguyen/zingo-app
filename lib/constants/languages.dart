class Language {
  final String code;
  final String nativeName;
  final String flag;

  const Language({
    required this.code,
    required this.nativeName,
    required this.flag,
  });

  static const List<Language> all = [
    Language(code: 'vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳'),
    Language(code: 'spanish', nativeName: 'Español', flag: '🇪🇸'),
    Language(code: 'french', nativeName: 'Français', flag: '🇫🇷'),
    Language(code: 'german', nativeName: 'Deutsch', flag: '🇩🇪'),
    Language(code: 'japanese', nativeName: '日本語', flag: '🇯🇵'),
    Language(code: 'korean', nativeName: '한국어', flag: '🇰🇷'),
    Language(code: 'chinese', nativeName: '中文', flag: '🇨🇳'),
    Language(code: 'portuguese', nativeName: 'Português', flag: '🇧🇷'),
    Language(code: 'arabic', nativeName: 'العربية', flag: '🇸🇦'),
    Language(code: 'hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    Language(code: 'indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩'),
    Language(code: 'thai', nativeName: 'ภาษาไทย', flag: '🇹🇭'),
    Language(code: 'turkish', nativeName: 'Türkçe', flag: '🇹🇷'),
    Language(code: 'russian', nativeName: 'Русский', flag: '🇷🇺'),
    Language(code: 'italian', nativeName: 'Italiano', flag: '🇮🇹'),
    Language(code: 'polish', nativeName: 'Polski', flag: '🇵🇱'),
    Language(code: 'malay', nativeName: 'Bahasa Melayu', flag: '🇲🇾'),
    Language(code: 'bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
    Language(code: 'urdu', nativeName: 'اردو', flag: '🇵🇰'),
    Language(code: 'ukrainian', nativeName: 'Українська', flag: '🇺🇦'),
  ];
}
