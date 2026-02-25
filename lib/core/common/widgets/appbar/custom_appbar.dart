import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../config/color/app_colors.dart';
import '../../../config/theme/style.dart';
import '../../../custom_assets/assets.gen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? leadingColor;
  final Color? backButtonColor;
  final Color? titleColor;
  final Widget? back;
  final List<Widget>? actions;
  final double height;
  final double? prefSize;
  final double? leadingWidth;
  final PreferredSizeWidget? bottom;
  final IconThemeData? iconTheme;
  final bool notification;
  final void Function()? onNotification;

  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.centerTitle = false,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.actions,
    this.leadingColor,
    this.backButtonColor = const Color(0xFF444444),
    this.back,
    this.height = 70,
    this.prefSize,
    this.leadingWidth,
    this.bottom,
    this.iconTheme,
    this.titleColor,
    this.notification = true,
    this.onNotification,
  });

  @override
  Widget build(BuildContext context) {
    /// This part is copied from AppBar class
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? leadingIcon = leading;

    if (leadingIcon == null && automaticallyImplyLeading) {
      if (hasDrawer) {
        leadingIcon = IconButton(
          icon: Icon(Icons.menu, color: leadingColor),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      } else {
        if (canPop) {
          leadingIcon =
              GestureDetector(
                onTap: (){
                  context.pop();
                },
                child: Padding(
                  padding: EdgeInsetsGeometry.all(12),
                  child: Container(
                    height: 30,
                    width: 30,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xffFFBB38),
                      shape: BoxShape.circle,
                    ),
                    child: Assets.icons.icArrowBack.svg(),
                  ),
                ),
              );
        }
      }
    }

    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        leading: leadingIcon,

        iconTheme: iconTheme,
        toolbarHeight: height.h,
        title: title,
        bottom: bottom,
        titleTextStyle: interRegular.copyWith(
          fontSize: 16,
          color: titleColor ?? AppColors.blackColor,
          letterSpacing: 0.2,
        ),
        centerTitle: centerTitle,
        titleSpacing: leadingIcon != null ? 0 : 20,
        backgroundColor: backgroundColor,
        actions: actions,
        leadingWidth: leadingWidth,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: null, // Let content go under status bar
          statusBarIconBrightness: Brightness.dark, // or Brightness.light
        ),
        scrolledUnderElevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(prefSize ?? height);
}
