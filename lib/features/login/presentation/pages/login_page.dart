import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/routes/route_path.dart';
import '../../../../core/config/theme/style.dart';
import '../../../../core/di/init_dependencies.dart';

import '../bloc/auth/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LoginView();
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController(text: 'mor_2314');
  final _passwordCtrl = TextEditingController(text: '83r5^_');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      LoginEvent(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.goNamed(RoutePath.mainPage, extra: state.user);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),

                /// ---------------------  Header -----------------------
                Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xffE54B4B), Color(0xffFF8C42)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Text(
                    'Welcome Back',
                    style: interBold.copyWith(
                      fontSize: 26.sp,
                      color: const Color(0xff222222),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Sign in to continue shopping',
                    style: interRegular.copyWith(
                      fontSize: 14.sp,
                      color: const Color(0xff797979),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                ///----------------------------------- Form ---------------------------
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(
                        label: 'Username',
                        controller: _usernameCtrl,
                        icon: Icons.person_outline_rounded,
                        validator: (v) =>
                            (v?.isEmpty ?? true) ? 'Enter username' : null,
                      ),
                      SizedBox(height: 16.h),
                      _buildField(
                        label: 'Password',
                        controller: _passwordCtrl,
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        validator: (v) =>
                            (v?.isEmpty ?? true) ? 'Enter password' : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                /// -------------------------------  Login Button --------------------------
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffE54B4B),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Login',
                                style: interSemiBold.copyWith(fontSize: 16.sp),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),

                /// -------------- Demo Credential ------------------------
                Center(
                  child: Text(
                    'Demo: mor_2314 / 83r5^_',
                    style: interRegular.copyWith(
                      fontSize: 12.sp,
                      color: const Color(0xff979797),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: interRegular.copyWith(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: interRegular.copyWith(
          fontSize: 13.sp,
          color: const Color(0xff979797),
        ),
        prefixIcon: Icon(icon, size: 20.sp, color: const Color(0xff979797)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xffE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xffE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xffE54B4B), width: 1.5),
        ),
      ),
    );
  }
}
