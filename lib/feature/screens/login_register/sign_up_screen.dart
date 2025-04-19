import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../core_ui/design_system/app_button.dart';
import '../../cubit/auth_cubit.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();

  bool validate(String username, String email, String pass, String repass) {
    if (username.isEmpty || email.isEmpty || pass.isEmpty || repass.isEmpty) {
      showToast('Hãy điền đầy đủ thông tin!', isError: true);
      return false;
    }
    if (pass.length < 8) {
      showToast('Mật khẩu phải có ít nhất 8 ký tự!!', isError: true);
      return false;
    }
    if (pass != repass) {
      showToast('Mật khẩu không khớp!!', isError: true);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (_) => AuthCubit(),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text('Đăng kí', style: AppsTextStyle.text24Weight700),
                        const SizedBox(height: 30),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthOtpSent) {
                              showToast(
                                  'OTP gửi thành công vui lòng kiểm tra email');
                              widget.controller.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            } else if (state is AuthError) {
                              showToast('Email đã tồn tại!!', isError: true);
                            }
                          },
                          builder: (context, state) {
                            return Column(
                              children: [
                                // Username Field
                                TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: AppsTextStyle.text14Weight500
                                        .copyWith(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray700),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray900),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Email Field
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: AppsTextStyle.text14Weight500
                                        .copyWith(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray700),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray900),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Password Field
                                TextField(
                                  controller: _passController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: AppsTextStyle.text14Weight500
                                        .copyWith(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray700),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray900),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Confirm Password Field
                                TextField(
                                  controller: _repassController,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    labelStyle: AppsTextStyle.text14Weight500
                                        .copyWith(color: AppColors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray700),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      borderSide: BorderSide(
                                          width: 1, color: AppColors.gray900),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Create Account Button
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: AppButton(
                                      onPressed: () async {
                                        final username =
                                            _usernameController.text.trim();
                                        final email = _emailController.text
                                            .trim()
                                            .toLowerCase();
                                        final pass =
                                            _passController.text.trim();
                                        final repass =
                                            _repassController.text.trim();
                                        if (validate(
                                            username, email, pass, repass)) {
                                          await context
                                              .read<AuthCubit>()
                                              .register(username, email, pass);
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          await pref.setString('email', email);
                                        }
                                      },
                                      borderRadius: 15,
                                      action: 'Đăng kí',
                                      colorDisable: AppColors.blue,
                                      colorEnable: AppColors.blue,
                                      overlayColor: false,
                                      loading: state is AuthLoading,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Log In Redirect Text
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Đã có tài khoản?',
                                      style: AppsTextStyle.text14Weight500
                                          .copyWith(color: AppColors.gray700),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () {
                                        widget.controller.animateToPage(0,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.ease);
                                      },
                                      child: Text(
                                        'Đăng nhập',
                                        style: AppsTextStyle.text14Weight600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
