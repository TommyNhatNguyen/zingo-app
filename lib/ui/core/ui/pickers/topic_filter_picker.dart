import 'package:flutter/material.dart';
import 'package:zingo/core/constants/topics.dart';
import 'package:zingo/ui/core/themes/app_colors.dart';
import 'package:zingo/ui/core/ui/card_select.dart';
import 'package:zingo/ui/core/ui/pickers/filter_picker_chip.dart';

class TopicFilterPicker extends StatelessWidget {
  final List<String> value;
  final ValueChanged<List<String>> onChanged;

  const TopicFilterPicker({
    super.key,
    required this.value,
    required this.onChanged,
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
      builder: (_) => _TopicFilterSheet(initialValue: value),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    return FilterPickerChip(
      label: 'Topics',
      icon: Icons.folder_open_outlined,
      selectedCount: value.length,
      onTap: () => _open(context),
    );
  }
}

class _TopicFilterSheet extends StatefulWidget {
  final List<String> initialValue;

  const _TopicFilterSheet({required this.initialValue});

  @override
  State<_TopicFilterSheet> createState() => _TopicFilterSheetState();
}

class _TopicFilterSheetState extends State<_TopicFilterSheet> {
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
                child: Text('Topics', style: textTheme.headlineSmall),
              ),
              if (_draft.isNotEmpty)
                TextButton(
                  onPressed: () => setState(_draft.clear),
                  child: const Text('Clear'),
                ),
            ],
          ),
          Text(
            'Filter dialogs by topic category.',
            style: textTheme.bodySmall,
          ),
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
              onPressed: () =>
                  Navigator.of(context).pop(_draft.toList(growable: false)),
              child: Text(
                _draft.isEmpty
                    ? 'Show all topics'
                    : 'Apply · ${_draft.length} selected',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
