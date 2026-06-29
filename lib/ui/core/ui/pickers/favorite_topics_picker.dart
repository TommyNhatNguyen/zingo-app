import 'package:flutter/material.dart';
import 'package:zingo/core/constants/topics.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/card_select.dart';

class FavoriteTopicsPicker extends StatelessWidget {
  final List<String> value;
  final ValueChanged<List<String>> onChanged;
  final bool? allowClear;
  final String emptyLabel;
  final String sheetTitle;
  final String sheetSubtitle;

  const FavoriteTopicsPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.allowClear = true,
    this.emptyLabel = 'Pick favourite topics',
    this.sheetTitle = 'Favourite topics',
    this.sheetSubtitle =
        "Pick as many as you like; we'll personalise your dialogs.",
  });

  Future<void> _open(BuildContext context) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: AppColors.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TopicsSheet(
        initialValue: value,
        title: sheetTitle,
        subtitle: sheetSubtitle,
        allowClear: allowClear,
      ),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final count = value.length;
    final preview = _formatPreview(value);

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
                          ? emptyLabel
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

  static String? _formatPreview(List<String> codes) {
    if (codes.isEmpty) return null;

    final names = TopicCategory.all
        .where((category) => codes.contains(category.code))
        .map((category) => category.name)
        .toList(growable: false);
    if (names.isEmpty) return null;
    if (names.length <= 3) return names.join(' · ');

    return '${names.take(3).join(' · ')} +${names.length - 3} more';
  }
}

class _TopicsSheet extends StatefulWidget {
  final List<String> initialValue;
  final String title;
  final String subtitle;
  final bool? allowClear;

  const _TopicsSheet({
    required this.initialValue,
    required this.title,
    required this.subtitle,
    this.allowClear = true,
  });

  @override
  State<_TopicsSheet> createState() => _TopicsSheetState();
}

class _TopicsSheetState extends State<_TopicsSheet> {
  late Set<String> _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initialValue.toSet();
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

  void _clear() {
    setState(_draft.clear);
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
        spacing: 4,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.title, style: textTheme.headlineSmall),
              ),
              if (widget.allowClear == true && _draft.isNotEmpty)
                TextButton(onPressed: _clear, child: const Text('Clear')),
            ],
          ),
          Text(widget.subtitle, style: textTheme.bodySmall),
          const SizedBox(height: 8),
          Flexible(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.4,
              crossAxisCount: 2,
              children: [
                for (final category in TopicCategory.all)
                  CardSelect(
                    emoji: category.emoji,
                    label: category.name,
                    isSelected: _draft.contains(category.code),
                    onTap: () => _toggle(category.code),
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
              onPressed: () => Navigator.of(context).pop(_draft.toList()),
              child: Text(
                _draft.isEmpty ? 'Done' : 'Done · ${_draft.length} selected',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
