import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/custom_assets/assets.gen.dart';

class MainPage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final _navItems = [
    {"label": "Home", "icon": Assets.icons.icHome},
    {"label": "Message", "icon": Assets.icons.icMessage},
    {"label": "Order", "icon": Assets.icons.icOrder},
    {"label": "Profile", "icon": Assets.icons.icProfile},
  ];

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: CustomBottomNav(
        items: _navItems,
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
class CustomBottomNav extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.only(top: 16.h,bottom: 10.h,left: 22.w,right: 22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (index) {
          final isActive = index == currentIndex;

          return GestureDetector(
            onTap: () => onTap(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                items[index]['icon'].svg(
                  height: 28.sp,
                  width: 28.sp,

                ),
                SizedBox(height: 6.h),
                Text(
                  items[index]['label'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF1D1D1D) // yellow
                        : const Color(0xFF797979),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


class CustomBottomNavBar extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int currentIndex;
  final Function(int) onTap;
  final List<AnimationController> itemControllers;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.itemControllers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 100.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r)
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withValues(alpha: 0.08),
        //     blurRadius: 24.r,
        //     offset: Offset(0, 8.h),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          items.length,
          (index) => NavBarItem(
            item: items[index],
            isActive: index == currentIndex,
            onTap: () => onTap(index),
            animationController: itemControllers[index],
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isActive;
  final VoidCallback onTap;
  final AnimationController animationController;

  const NavBarItem({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.animationController,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Listen to external animation controller
    widget.animationController.addListener(_handleAnimationUpdate);
  }

  void _handleAnimationUpdate() {
    // When switching to this item, forward the scale animation
    if (widget.isActive &&
        widget.animationController.status == AnimationStatus.forward) {
      _scaleController.forward();
    }
  }

  @override
  void didUpdateWidget(NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _scaleController.forward();
      } else {
        _scaleController.reverse();
      }
    }
  }

  @override
  void dispose() {
    widget.animationController.removeListener(_handleAnimationUpdate);
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _scaleController.forward().then((_) {
          _scaleController.reverse();
        });
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([
          widget.animationController,
          _scaleAnimation,
        ]),
        builder: (context, child) {
          final labelProgress = widget.animationController.value;

          return ScaleTransition(
            scale: _scaleAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                padding: !widget.isActive
                    ? EdgeInsets.all(10)
                    : EdgeInsets.symmetric(
                        horizontal: 8 + (8.w * labelProgress),
                        vertical: 6,
                      ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: Color.lerp(
                    const Color(0xFFA7C5DA).withValues(alpha: 0.4),
                    const Color(0xFF3F80AE),
                    labelProgress,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      widget.item['icon'],
                      height: 24.sp,
                      width: 24.sp,
                      colorFilter: ColorFilter.mode(
                        Color.lerp(
                              const Color(0xFF3F80AE),
                              Colors.white,
                              labelProgress,
                            ) ??
                            Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    if (labelProgress > 0.3) ...[
                      SizedBox(width: 8.w),
                      Opacity(
                        opacity: (labelProgress - 0.3) / 0.7,
                        child: Text(
                          widget.item['label'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
