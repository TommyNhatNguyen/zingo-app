import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/english_level.dart' as level_const;
import 'package:zingo/constants/enums.dart' as app_enums;

/// Trigger row that shows the current CEFR level and opens a bottom-sheet
/// picker on tap.
///
/// Controlled widget: parent owns [value] and receives the new pick via
/// [onChanged]. Single-select; tap inside the sheet selects and closes.
class EnglishLevelPicker extends StatelessWidget {
  final app_enums.EnglishLevel? value;
  final ValueChanged<app_enums.EnglishLevel> onChanged;

  const EnglishLevelPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    final picked = await showModalBottomSheet<app_enums.EnglishLevel>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EnglishLevelSheet(initialValue: value),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final selected = value == null
        ? null
        : level_const.EnglishLevel.all.firstWhere(
            (e) => e.code == value,
            orElse: () => level_const.EnglishLevel.all.first,
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
              _CefrBadge(label: selected?.code.value.toUpperCase() ?? '—'),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected?.name ?? 'Choose your level',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: selected == null
                            ? AppColors.textSecondary
                            : null,
                      ),
                    ),
                    if (selected != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        selected.description,
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
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

class _CefrBadge extends StatelessWidget {
  final String label;

  const _CefrBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EnglishLevelSheet extends StatelessWidget {
  final app_enums.EnglishLevel? initialValue;

  const _EnglishLevelSheet({required this.initialValue});

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
              Text('Your English level', style: textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                "We'll match dialogs to your comfort zone.",
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: level_const.EnglishLevel.all.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final lvl = level_const.EnglishLevel.all[index];
                    final isSelected = initialValue == lvl.code;
                    return InkWell(
                      onTap: () => Navigator.of(context).pop(lvl.code),
                      borderRadius: BorderRadius.circular(12),
                      child: Card.outlined(
                        color: isSelected ? AppColors.primaryContainer : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.divider,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${lvl.code.value.toUpperCase()} · ${lvl.name}',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? AppColors.primary
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      lvl.description,
                                      style: textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
