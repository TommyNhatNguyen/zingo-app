import 'package:flutter/material.dart';
import 'package:zingo/core/constants/enums.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/pickers/filter_picker_chip.dart';

class DurationFilterPicker extends StatelessWidget {
  final List<DialogDuration> value;
  final ValueChanged<List<DialogDuration>> onChanged;

  const DurationFilterPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<List<DialogDuration>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DurationFilterSheet(initialValue: value),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return FilterPickerChip(
      label: 'Duration',
      icon: Icons.timer_outlined,
      selectedCount: value.length,
      onTap: () => _open(context),
    );
  }
}

class _DurationFilterSheet extends StatefulWidget {
  final List<DialogDuration> initialValue;

  const _DurationFilterSheet({required this.initialValue});

  @override
  State<_DurationFilterSheet> createState() => _DurationFilterSheetState();
}

class _DurationFilterSheetState extends State<_DurationFilterSheet> {
  late Set<DialogDuration> _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialValue.toSet();
  }

  void _toggle(DialogDuration duration) {
    setState(() {
      if (_draft.contains(duration)) {
        _draft.remove(duration);
      } else {
        _draft.add(duration);
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
                child: Text('Duration', style: textTheme.headlineSmall),
              ),
              if (_draft.isNotEmpty)
                TextButton(
                  onPressed: () => setState(_draft.clear),
                  child: const Text('Clear'),
                ),
            ],
          ),
          Text(
            'Pick how long you want each dialog to be.',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final duration in DialogDuration.values) ...[
            InkWell(
              onTap: () => _toggle(duration),
              borderRadius: BorderRadius.circular(12),
              child: Card.outlined(
                color: _draft.contains(duration)
                    ? AppColors.primaryContainer
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _draft.contains(duration)
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _draft.contains(duration)
                              ? AppColors.primary.withValues(alpha: 0.12)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          switch (duration) {
                            DialogDuration.short => Icons.bolt_outlined,
                            DialogDuration.mid => Icons.schedule_outlined,
                            DialogDuration.long => Icons.hourglass_top_outlined,
                          },
                          size: 20,
                          color: _draft.contains(duration)
                              ? AppColors.primaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              duration.label,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _draft.contains(duration)
                                    ? AppColors.primaryDark
                                    : null,
                              ),
                            ),
                            Text(
                              duration.description,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (_draft.contains(duration))
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(_draft.toList(growable: false)),
              child: Text(
                _draft.isEmpty
                    ? 'Show all durations'
                    : 'Apply · ${_draft.length} selected',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
