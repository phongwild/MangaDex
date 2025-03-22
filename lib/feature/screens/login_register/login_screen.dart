// ignore_for_file: camel_case_types

import 'package:app/common/define/key_assets.dart';
import 'package:app/core/app_log.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: Image.asset(
                KeyAssets.img1,
                width: 413,
                height: 417,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Log In',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) async {
                        if (state is AuthLoginSuccess) {
                          //Lưu thông đăng nhập để tự động đăng nhập sau khi thoát app
                          saveLoginInfo(
                              emailController.text.trim(), passController.text);
                          showToast('Đăng nhập thành công');
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            NettromdexRouter.bottomNav,
                            (router) => false,
                          );
                        } else if (state is AuthError) {
                          dlog('Error message: ${state.error}');
                          showToast('Sai tài khoản hoặc mật khẩu',
                              isError: true);
                        }
                      },
                      builder: (context, state) {
                        return Stack(
                          children: [
                            // Các trường nhập liệu và button
                            Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: Color(0xFF393939),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF755DC1),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF837E93),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF9F7BFF),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextField(
                                  controller: passController,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF393939),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF755DC1),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF837E93),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xFF9F7BFF),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: SizedBox(
                                    width: 329,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final email = emailController.text
                                            .trim()
                                            .toLowerCase();
                                        final pass = passController.text.trim();
                                        if (email.isEmpty || pass.isEmpty) {
                                          showToast('Hãy điền đầy đủ thông tin',
                                              isError: true);
                                          return;
                                        }
                                        context
                                            .read<AuthCubit>()
                                            .login(email, pass);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF9F7BFF),
                                      ),
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Hiển thị loading nếu AuthLoading
                            if (state is AuthLoading)
                              Center(child: LoadingShimmer().loadingCircle())
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          color: Color(0xFF837E93),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 2.5,
                      ),
                      InkWell(
                        onTap: () {
                          widget.controller.animateToPage(1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
