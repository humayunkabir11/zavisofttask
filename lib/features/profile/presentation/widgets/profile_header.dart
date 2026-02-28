import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/config/theme/style.dart';

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String fullName;
  final String username;

  const ProfileHeader({
    super.key,
    required this.firstName,
    required this.fullName,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffE54B4B),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    color: const Color(0xffFDEAEA),
                    child: Center(
                      child: Text(
                        firstName[0].toUpperCase(),
                        style: interBold.copyWith(
                          fontSize: 32.sp,
                          color: const Color(0xffE54B4B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xffE54B4B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(16.h),
        Text(
          fullName,
          style: interBold.copyWith(
            fontSize: 22.sp,
            color: const Color(0xff222222),
          ),
        ),
        Text(
          '@$username',
          style: interMedium.copyWith(
            fontSize: 14.sp,
            color: const Color(0xff797979),
          ),
        ),
      ],
    );
  }
}
