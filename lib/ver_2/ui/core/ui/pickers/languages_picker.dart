import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/languages.dart';
import 'package:zingo/ver_2/ui/core/ui/card_select.dart';

class LanguagesPicker extends StatelessWidget {
  final Language? value;
  final ValueChanged<Language?> onSelect;
  final String emptyLabel;
  final String sheetTitle;
  final String? sheetSubtitle;
  final Widget Function({
    required Future<void> Function() openModalBottomSheet,
  })?
  trigger;

  const LanguagesPicker({
    super.key,
    this.value,
    required this.onSelect,
    this.emptyLabel = 'Pick a language',
    this.sheetTitle = 'Choose a language',
    this.sheetSubtitle,
    this.trigger,
  });

  Future<void> _openModalBottomSheet(BuildContext context) async {
    final maxHeight = MediaQuery.of(context).size.height * 0.75;
    final result = await showModalBottomSheet<Language?>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: AppColors.surface,
      constraints: BoxConstraints(maxHeight: maxHeight),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LanguagesSheet(
        value: value,
        title: sheetTitle,
        subtitle: sheetSubtitle,
      ),
    );
    if (result != null) onSelect(result);
  }

  @override
  Widget build(BuildContext context) {
    if (trigger != null) {
      return trigger!(
        openModalBottomSheet: () async => await _openModalBottomSheet(context),
      );
    }

    return InkWell(
      onTap: () => _openModalBottomSheet(context),
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
                  value?.flag ?? '🌐',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value?.nativeName ?? emptyLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: value == null ? AppColors.textSecondary : null,
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

class _LanguagesSheet extends StatelessWidget {
  final Language? value;
  final String title;
  final String? subtitle;

  const _LanguagesSheet({
    required this.value,
    required this.title,
    this.subtitle,
  });

  void _onSelect(BuildContext context, Language language) {
    context.pop(value == language ? null : language);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
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
                    isSelected: value == lang,
                    onTap: () => _onSelect(context, lang),
                    labelStyle: Theme.of(context).textTheme.bodySmall,
                    labelMaxLines: 2,
                    checkIconSize: 16,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
