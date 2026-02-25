import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/color/app_colors.dart';
import '../../../config/theme/style.dart';
import '../../../custom_assets/assets.gen.dart';
import '../image/cache_image.dart';

class CommonAppbar extends StatelessWidget {
  final Widget? trailing;
  final VoidCallback? onTrailingTap;
  const CommonAppbar({super.key, this.trailing, this.onTrailingTap});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // ✅ Android → white icons
        statusBarBrightness: Brightness.dark, // ✅ iOS → white icons
      ),
      child: Container(
        height: 132,
        decoration: const BoxDecoration(
          color: AppColors.blue600,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: Assets.images.imgStar.svg()),
            SafeArea(
              child: ListTile(
                leading: CacheImage(
                  imageUrl:
                      "https://i.pinimg.com/736x/ed/30/f0/ed30f063ed234d63f7922efe64dbf9c2.jpg",
                  height: 44,
                  width: 44,
                  borderRadius: 100,
                ),
                title: Text(
                  "Liam Johnson",
                  style: interRegular.copyWith(
                    fontSize: 16,
                    letterSpacing: 0,
                    color: Color(0xFFF1F1F1),
                  ),
                ),
                subtitle: Text(
                  "Teacher",
                  style: interRegular.copyWith(
                    fontSize: 12,
                    letterSpacing: 0,
                    color: Color(0xFFDBDBDB),
                  ),
                ),
                trailing: GestureDetector(
                  onTap: onTrailingTap,
                  child: Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        strokeAlign: BorderSide.strokeAlignInside,
                        width: 1,
                        color: Colors.white,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment(-4, 0),
                        end: Alignment(0, 0.5),
                        colors: [
                          Colors.white.withValues(alpha: 0.5),
                          Colors.white.withValues(alpha: 0.2),
                        ],
                      ),
                    ),
                    child: trailing,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
