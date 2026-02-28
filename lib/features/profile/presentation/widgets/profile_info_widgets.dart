import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/config/theme/style.dart';

class ProfileInfoSection extends StatelessWidget {
  final String title;
  final List<ProfileInfoTile> tiles;

  const ProfileInfoSection({
    super.key,
    required this.title,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
          child: Text(
            title,
            style: interBold.copyWith(
              fontSize: 16.sp,
              color: const Color(0xff222222),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: tiles),
        ),
      ],
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F9FA),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: const Color(0xff797979), size: 20),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: interMedium.copyWith(
                        fontSize: 12.sp,
                        color: const Color(0xff979797),
                      ),
                    ),
                    Text(
                      value,
                      style: interSemiBold.copyWith(
                        fontSize: 14.sp,
                        color: const Color(0xff222222),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 64.w,
            endIndent: 16.w,
            color: Colors.grey.withAlpha(30),
          ),
      ],
    );
  }
}
