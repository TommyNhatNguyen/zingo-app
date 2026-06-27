import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String id;
  final String code;
  final String nativeName;
  final String flag;

  const Language({
    required this.id,
    required this.code,
    required this.nativeName,
    required this.flag,
  });

  static const List<Language> all = [
    Language(
      id: 'vi',
      code: 'vietnamese',
      nativeName: 'Tiếng Việt',
      flag: '🇻🇳',
    ),
    // Language(id: 'en', code: 'english', nativeName: 'English', flag: '🇺🇸'),
    Language(id: 'es', code: 'spanish', nativeName: 'Español', flag: '🇪🇸'),
    Language(id: 'fr', code: 'french', nativeName: 'Français', flag: '🇫🇷'),
    Language(id: 'de', code: 'german', nativeName: 'Deutsch', flag: '🇩🇪'),
    Language(id: 'ja', code: 'japanese', nativeName: '日本語', flag: '🇯🇵'),
    Language(id: 'ko', code: 'korean', nativeName: '한국어', flag: '🇰🇷'),
    Language(id: 'zh', code: 'chinese', nativeName: '中文', flag: '🇨🇳'),
    Language(id: 'ar', code: 'arabic', nativeName: 'العربية', flag: '🇸🇦'),
    Language(id: 'hi', code: 'hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    Language(
      id: 'id',
      code: 'indonesian',
      nativeName: 'Bahasa Indonesia',
      flag: '🇮🇩',
    ),
    Language(id: 'th', code: 'thai', nativeName: 'ภาษาไทย', flag: '🇹🇭'),
    Language(id: 'tr', code: 'turkish', nativeName: 'Türkçe', flag: '🇹🇷'),
    Language(id: 'ru', code: 'russian', nativeName: 'Русский', flag: '🇷🇺'),
    Language(id: 'it', code: 'italian', nativeName: 'Italiano', flag: '🇮🇹'),
    Language(id: 'pl', code: 'polish', nativeName: 'Polski', flag: '🇵🇱'),
    Language(
      id: 'ms',
      code: 'malay',
      nativeName: 'Bahasa Melayu',
      flag: '🇲🇾',
    ),
    Language(id: 'bn', code: 'bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
    Language(id: 'ur', code: 'urdu', nativeName: 'اردو', flag: '🇵🇰'),
    Language(
      id: 'uk',
      code: 'ukrainian',
      nativeName: 'Українська',
      flag: '🇺🇦',
    ),
    Language(
      id: 'pt',
      code: 'portuguese',
      nativeName: 'Português (Brasil)',
      flag: '🇧🇷',
    ),
  ];

  static Language? fromId(String? id) {
    if (id == null || id.isEmpty) return null;
    final matches = all.where((language) => language.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  List<Object?> get props => [code, nativeName, flag];
}
