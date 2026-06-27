import 'package:flutter/material.dart';

class ResizeHeader extends SliverPersistentHeaderDelegate {
  const ResizeHeader({
    required this.maxHeight,
    required this.minHeight,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final Widget Function(BuildContext context, double t) builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final t = (shrinkOffset / (maxHeight - minHeight)).clamp(0.0, 1.0);
    return builder(context, t);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant ResizeHeader oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.builder != builder;
  }
}
