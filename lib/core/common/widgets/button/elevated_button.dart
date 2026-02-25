import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/color/app_colors.dart';
import '../../../config/theme/style.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String titleText;
  final Color titleColor;
  final Color buttonColor;
  final Color? borderColor;
  final double titleSize;
  final bool enableShadow;
  final TextStyle? titleStyle;
  final FontWeight titleWeight;
  final double borderRadius;
  final double buttonHeight;
  final double? buttonWidth;
  final bool isLoading;
  final bool isEnable;
  final Widget? loadingWidget;
  final EdgeInsetsGeometry? margin;

  final Widget? iconLeft;
  final Widget? iconRight;

  const CustomElevatedButton({
    required this.onPressed,
    required this.titleText,
    this.titleColor = AppColors.whiteColor,
    this.buttonColor = AppColors.primaryColor,
    this.titleSize = 16,
    this.borderRadius = 0,
    this.titleWeight = FontWeight.w500,
    this.buttonHeight = 50,
    this.buttonWidth,
    this.borderColor,
    this.enableShadow = false,
    this.iconLeft,
    this.iconRight,
    this.isLoading = false,
    this.isEnable = true,
    super.key,
    this.margin,
    this.titleStyle,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isEnable || isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: buttonHeight.h,
        width: buttonWidth ?? MediaQuery.of(context).size.width,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isEnable ? buttonColor : AppColors.blue200,
          border: Border.all(color: borderColor ?? Colors.transparent),
          boxShadow: !enableShadow
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: Offset(-1, -1),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconLeft ?? SizedBox(),
              SizedBox(width: 12.w),
              isLoading
                  ? loadingWidget ??
                        SizedBox.square(
                          dimension: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                          ),
                        )
                  : Text(
                      titleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style:
                          titleStyle ??
                              interRegular.copyWith(
                            color: isEnable
                                ? titleColor
                                : AppColors.primarySlate300,
                            fontSize: titleSize,
                            fontWeight: titleWeight,
                          ),
                    ),
              SizedBox(width: 12.w),
              iconRight ?? SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
