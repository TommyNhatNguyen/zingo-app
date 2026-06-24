import 'package:flutter/material.dart';
import 'package:zingo/constants/languages.dart';
import 'package:zingo/ver_2/ui/onboarding/widgets/profile_page.dart';
import 'package:zingo/ver_2/ui/core/ui/card_select.dart';

class NativeLanguagePage extends StatefulWidget {
  const NativeLanguagePage({
    super.key,
    this.selectedLanguage,
    required this.onSelect,
  });

  final Language? selectedLanguage;
  final ValueChanged<Language> onSelect;

  @override
  _NativeLanguagePageState createState() => _NativeLanguagePageState();
}

class _NativeLanguagePageState extends State<NativeLanguagePage> {
  void _onSelect(Language language) {
    setState(() {
      widget.onSelect(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePage(
      emoji: "🌍",
      title: "What's your native language?",
      description: "We'll tailor tips and translations for you.",
      child: Expanded(
        child: GridView.count(
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 2,
          crossAxisCount: 2,
          children: Language.all
              .map(
                (lang) => CardSelect(
                  emoji: lang.flag,
                  label: lang.nativeName,
                  isSelected: widget.selectedLanguage?.code == lang.code,
                  onTap: () => _onSelect(lang),
                  emojiStyle: Theme.of(context).textTheme.displayMedium,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
