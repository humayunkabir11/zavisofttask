import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:zavi_soft_task/features/login/presentation/bloc/auth/auth_bloc.dart';
import '../../../../core/config/theme/style.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../../login/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/profile_bloc.dart';

import '../widgets/profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProfileBloc>()..add(const GetProfileEvent(userId: 1)),
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,

          title: Text(
            'Profile',
            style: interSemiBold.copyWith(fontSize: 18.sp, color: Colors.black),
          ),
        ),
        body: const ProfileView(),
      ),
    );
  }
}

