import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class EmptySection extends StatelessWidget {
  const EmptySection({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  final Widget? subtitle;
  final Widget icon;
  final Widget title;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(16),
        dashPattern: [10, 5],
        strokeWidth: 2,
        color: borderColor,
      ),
      childOnTop: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 0,
                children: [title, subtitle ?? const SizedBox.shrink()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
