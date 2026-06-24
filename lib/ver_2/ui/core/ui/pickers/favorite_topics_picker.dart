import 'package:flutter/material.dart';
import 'package:zingo/config/app_colors.dart';
import 'package:zingo/constants/topics.dart';
import 'package:zingo/ver_2/ui/core/ui/card_select.dart';

/// Trigger row showing how many topics are picked. Opens a tall bottom-sheet
/// with a 2-col grid for multi-select and commits via a Done button.
///
/// Controlled widget: parent owns [value] (set of topic codes) and receives
/// the new full set via [onChanged]. We never mutate the incoming set.
class FavoriteTopicsPicker extends StatelessWidget {
  final Set<String> value;
  final ValueChanged<Set<String>> onChanged;

  const FavoriteTopicsPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TopicsSheet(initialValue: value),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final count = value.length;
    final preview = _previewNames(value);

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
                  color: AppColors.accentContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count == 0 ? '+' : '$count',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.accent,
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
                      count == 0
                          ? 'Pick favourite topics'
                          : '$count topic${count == 1 ? '' : 's'} selected',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: count == 0 ? AppColors.textSecondary : null,
                      ),
                    ),
                    if (preview != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        preview,
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

  String? _previewNames(Set<String> codes) {
    if (codes.isEmpty) return null;
    final names = TopicCategory.all
        .where((c) => codes.contains(c.code))
        .map((c) => c.name)
        .toList(growable: false);
    if (names.isEmpty) return null;
    if (names.length <= 3) return names.join(' · ');
    return '${names.take(3).join(' · ')} +${names.length - 3} more';
  }
}

class _TopicsSheet extends StatefulWidget {
  final Set<String> initialValue;

  const _TopicsSheet({required this.initialValue});

  @override
  State<_TopicsSheet> createState() => _TopicsSheetState();
}

class _TopicsSheetState extends State<_TopicsSheet> {
  late Set<String> _draft;

  @override
  void initState() {
    super.initState();
    _draft = Set<String>.from(widget.initialValue);
  }

  void _toggle(String code) {
    setState(() {
      if (_draft.contains(code)) {
        _draft.remove(code);
      } else {
        _draft.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Favourite topics',
                      style: textTheme.headlineSmall,
                    ),
                  ),
                  if (_draft.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(_draft.clear),
                      child: const Text('Clear'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Pick as many as you like; we'll personalise your dialogs.",
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Flexible(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.4,
                  crossAxisCount: 2,
                  children: [
                    for (final cat in TopicCategory.all)
                      CardSelect(
                        emoji: cat.emoji,
                        label: cat.name,
                        isSelected: _draft.contains(cat.code),
                        onTap: () => _toggle(cat.code),
                        labelStyle: textTheme.bodySmall,
                        labelMaxLines: 2,
                        checkIconSize: 16,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_draft),
                  child: Text(
                    _draft.isEmpty
                        ? 'Done'
                        : 'Done · ${_draft.length} selected',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
