import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/theme/style.dart';
import '../../../../core/di/init_dependencies.dart';
import '../bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(const GetProfileEvent(userId: 1)),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Profile',
          style: interSemiBold.copyWith(fontSize: 18.sp, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xffE54B4B), size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xffE54B4B)));
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message, style: interRegular.copyWith(color: Colors.red)));
          }
          if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Gap(24.h),
                  // ── Profile Header ─────────────────────────────────────
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xffE54B4B), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
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
                                  user.firstName[0].toUpperCase(),
                                  style: interBold.copyWith(fontSize: 32.sp, color: const Color(0xffE54B4B)),
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
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(16.h),
                  Text(
                    user.fullName,
                    style: interBold.copyWith(fontSize: 22.sp, color: const Color(0xff222222)),
                  ),
                  Text(
                    '@${user.username}',
                    style: interMedium.copyWith(fontSize: 14.sp, color: const Color(0xff797979)),
                  ),
                  Gap(32.h),

                  // ── Info Cards ─────────────────────────────────────────
                  _buildSectionTitle('Personal Information'),
                  _buildInfoCard([
                    _buildInfoTile(Icons.email_outlined, 'Email', user.email),
                    _buildInfoTile(Icons.phone_outlined, 'Phone', user.phone),
                  ]),
                  Gap(24.h),
                  _buildSectionTitle('Address'),
                  _buildInfoCard([
                    _buildInfoTile(Icons.location_on_outlined, 'Street', user.street),
                    _buildInfoTile(Icons.store_outlined, 'City', '${user.city}, ${user.zipcode}'),
                  ]),
                  Gap(40.h),

                  // ── Logout ─────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xffE54B4B),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.logout_rounded),
                      label: Text('Log Out', style: interSemiBold.copyWith(fontSize: 16.sp)),
                    ),
                  ),
                  Gap(20.h),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: interBold.copyWith(fontSize: 16.sp, color: const Color(0xff222222)),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
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
                  style: interMedium.copyWith(fontSize: 12.sp, color: const Color(0xff979797)),
                ),
                Text(
                  value,
                  style: interSemiBold.copyWith(fontSize: 14.sp, color: const Color(0xff222222)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}