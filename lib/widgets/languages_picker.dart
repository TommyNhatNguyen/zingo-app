import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/languages.dart';
import 'package:zingo/widgets/card_select.dart';

/// Trigger row showing the currently selected language. Opens a bottom-sheet
/// grid on tap.
///
/// Controlled widget: parent owns [value] (language code) and receives the
/// new pick via [onChanged]. The sheet returns `null` if the user taps the
/// already-selected language, which signals "clear selection".
class LanguagesPicker extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String emptyLabel;
  final String sheetTitle;
  final String? sheetSubtitle;

  const LanguagesPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.emptyLabel = 'Pick a language',
    this.sheetTitle = 'Choose a language',
    this.sheetSubtitle,
  });

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<_LanguageResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LanguagesSheet(
        initialValue: value,
        title: sheetTitle,
        subtitle: sheetSubtitle,
      ),
    );
    if (result != null) onChanged(result.code);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = value == null
        ? null
        : Language.all.firstWhere(
            (l) => l.code == value,
            orElse: () => Language.all.first,
          );

    return InkWell(
      onTap: () => _open(context),
      borderRadius: BorderRadius.circular(12),
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.divider),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selected?.flag ?? '🌐',
                  style: textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selected?.nativeName ?? emptyLabel,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: selected == null ? AppColors.textSecondary : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wraps the picked code so we can distinguish "popped without selecting"
/// (no value, `Navigator.pop()` with no args returns null) from "user tapped
/// the already-selected card to clear" (returns `_LanguageResult(null)`).
class _LanguageResult {
  final String? code;

  const _LanguageResult(this.code);
}

class _LanguagesSheet extends StatelessWidget {
  final String? initialValue;
  final String title;
  final String? subtitle;

  const _LanguagesSheet({
    required this.initialValue,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.headlineSmall),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: textTheme.bodySmall),
              ],
              const SizedBox(height: 12),
              Flexible(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.4,
                  crossAxisCount: 2,
                  children: [
                    for (final lang in Language.all)
                      CardSelect(
                        emoji: lang.flag,
                        label: lang.nativeName,
                        isSelected: initialValue == lang.code,
                        onTap: () => Navigator.of(context).pop(
                          _LanguageResult(
                            initialValue == lang.code ? null : lang.code,
                          ),
                        ),
                        labelStyle: textTheme.bodySmall,
                        labelMaxLines: 2,
                        checkIconSize: 16,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
