import 'package:flutter/material.dart';

class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.child,
    required this.background,
    required this.foreground,
    this.icon,
  });

  final Widget child;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          icon != null
              ? Icon(icon, size: 16, color: foreground)
              : const SizedBox.shrink(),
          child,
        ],
      ),
    );
  }
}
