import 'package:app/core/app_log.dart';
import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/design_system/app_button.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cache/secures_storage.dart';
import '../../cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: _body(
        controller: controller,
      ),
    );
  }
}

// ignore: camel_case_types
class _body extends StatefulWidget {
  const _body({required this.controller});
  final PageController controller;
  @override
  State<_body> createState() => _bodyState();
}

class _bodyState extends State<_body> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
    saveLogin();
  }

  void saveLogin() async {
    String? isLoggedIn = await readSecureData('isLoggedIn');
    if (isLoggedIn == 'true') {
      String? email = await readSecureData('email');
      String? password = await readSecureData('password');
      dlog('email: $email, password: $password, isLoggedIn: $isLoggedIn');
      context.read<AuthCubit>().login(email!, password!);
    }
  }

  Future<void> saveLoginInfo(String email, String password) async {
    await writeSecureData('email', emailController.text.trim());
    await writeSecureData('password', passController.text);
    await writeSecureData('isLoggedIn', 'true');
    dlog('✅ Đã lưu thông tin đăng nhập!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.bgMain,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('Đăng nhập', style: AppsTextStyle.text24Weight700),
              const SizedBox(height: 40),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppsTextStyle.text14Weight400,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: AppsTextStyle.text14Weight500
                      .copyWith(color: AppColors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: AppColors.gray700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: AppColors.gray900),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textAlign: TextAlign.start,
                style: AppsTextStyle.text14Weight400,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: AppsTextStyle.text14Weight500
                      .copyWith(color: AppColors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: AppColors.gray700),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1, color: AppColors.gray900),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthError) {
                        showToast(
                          'Sai tài khoản hoặc mật khẩu :((',
                          isError: true,
                        );
                        return;
                      }
                      if (state is AuthLoginSuccess) {
                        saveLoginInfo(
                            emailController.text.trim(), passController.text);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          NettromdexRouter.bottomNav,
                          (router) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      return AppButton(
                        onPressed: () {
                          final email =
                              emailController.text.trim().toLowerCase();
                          final pass = passController.text.trim();
                          if (email.isEmpty || pass.isEmpty) {
                            showToast('Hãy điền đầy đủ thông tin',
                                isError: true);
                            return;
                          }
                          context.read<AuthCubit>().login(email, pass);
                        },
                        borderRadius: 15,
                        action: 'Đăng nhập',
                        colorDisable: AppColors.blue,
                        colorEnable: AppColors.blue,
                        overlayColor: false,
                        loading: state is AuthLoading,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chưa có tài khoản?',
                    style: AppsTextStyle.text14Weight500
                        .copyWith(color: AppColors.gray700),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      widget.controller.animateToPage(1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Text(
                      'Đăng kí',
                      style: AppsTextStyle.text14Weight600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Quên mật khẩu?',
                style: AppsTextStyle.text14Weight500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
