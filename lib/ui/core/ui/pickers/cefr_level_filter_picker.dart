import 'package:flutter/material.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/pickers/filter_picker_chip.dart';

class CefrLevelFilterPicker extends StatelessWidget {
  final List<EnglishLevel> value;
  final ValueChanged<List<EnglishLevel>> onChanged;

  const CefrLevelFilterPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<List<EnglishLevel>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CefrLevelFilterSheet(initialValue: value),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return FilterPickerChip(
      label: 'Level',
      icon: Icons.school_outlined,
      selectedCount: value.length,
      onTap: () => _open(context),
    );
  }
}

class _CefrLevelFilterSheet extends StatefulWidget {
  final List<EnglishLevel> initialValue;

  const _CefrLevelFilterSheet({required this.initialValue});

  @override
  State<_CefrLevelFilterSheet> createState() => _CefrLevelFilterSheetState();
}

class _CefrLevelFilterSheetState extends State<_CefrLevelFilterSheet> {
  late Set<EnglishLevel> _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialValue.toSet();
  }

  void _toggle(EnglishLevel level) {
    setState(() {
      if (_draft.contains(level)) {
        _draft.remove(level);
      } else {
        _draft.add(level);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('CEFR level', style: textTheme.headlineSmall),
              ),
              if (_draft.isNotEmpty)
                TextButton(
                  onPressed: () => setState(_draft.clear),
                  child: const Text('Clear'),
                ),
            ],
          ),
          Text(
            'Show dialogs matched to selected levels.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: EnglishLevel.values.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final level = EnglishLevel.values[index];
                final isSelected = _draft.contains(level);
                return InkWell(
                  onTap: () => _toggle(level),
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
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              level.value,
                              style: textTheme.labelMedium?.copyWith(
                                color: isSelected
                                    ? AppColors.primaryDark
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  level.label,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? AppColors.primaryDark
                                        : null,
                                  ),
                                ),
                                Text(
                                  level.description,
                                  style: textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_draft.toList(growable: false)),
              child: Text(
                _draft.isEmpty
                    ? 'Show all levels'
                    : 'Apply · ${_draft.length} selected',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
