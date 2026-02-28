import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/style.dart';
import '../../../login/presentation/bloc/auth/auth_bloc.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xffE54B4B),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onPressed: () {
          debugPrint('DEBUG: ProfilePage Logout button pressed');
          context.read<AuthBloc>().add(LogoutEvent());
          context.go('/login');
        },
        icon: const Icon(Icons.logout_rounded),
        label: Text(
          'Log Out',
          style: interSemiBold.copyWith(fontSize: 16.sp),
        ),
      ),
    );
  }
}
