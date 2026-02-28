import 'package:flutter/material.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const StickyTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => 46.0;
  @override
  double get maxExtent => 46.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 46.0,
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(StickyTabBarDelegate old) => old.tabBar != tabBar;
}
