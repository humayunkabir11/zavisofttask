import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../bloc/profile_bloc.dart';
import 'profile_header.dart';
import 'profile_info_widgets.dart';
import 'profile_logout_button.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffE54B4B)),
          );
        }
        if (state is ProfileError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is ProfileLoaded) {
          final user = state.user;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Gap(24.h),

                /// ------------------ profile header -------------------------
                ProfileHeader(
                  firstName: user.firstName,
                  fullName: user.fullName,
                  username: user.username,
                ),
                Gap(32.h),

                // ----------------------- user info --------------------------
                ProfileInfoSection(
                  title: 'Personal Information',
                  tiles: [
                    ProfileInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user.email,
                    ),
                    ProfileInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: user.phone,
                      showDivider: false,
                    ),
                  ],
                ),
                Gap(24.h),
                ProfileInfoSection(
                  title: 'Address',
                  tiles: [
                    ProfileInfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Street',
                      value: user.street,
                    ),
                    ProfileInfoTile(
                      icon: Icons.store_outlined,
                      label: 'City',
                      value: '${user.city}, ${user.zipcode}',
                      showDivider: false,
                    ),
                  ],
                ),
                Gap(40.h),
                ///-------------------------- logout button -------------------------
                const ProfileLogoutButton(),
                Gap(20.h),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
