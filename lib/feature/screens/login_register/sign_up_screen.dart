import 'package:app/common/define/key_assets.dart';
import 'package:app/core/app_log.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => AuthCubit(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Image.asset(
                  KeyAssets.img2,
                  width: 428,
                  height: 427,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthOtpSent) {
                      showToast('OTP gửi thành công vui lòng kiểm tra email');
                      // Chuyển sang trang kế tiếp nếu đăng ký thành công
                      widget.controller.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else if (state is AuthError) {
                      dlog('Error message: ${state.error}');
                      showToast('Email đã tồn tại!!', isError: true);
                    }
                  },
                  builder: (context, state) {
                    return Stack(
                      children: [
                        Column(
                          textDirection: TextDirection.ltr,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign up',
                              style: TextStyle(
                                color: Color(0xFF755DC1),
                                fontSize: 27,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 56,
                              child: TextField(
                                controller: _usernameController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF393939),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  labelText: 'Username',
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
                            ),
                            const SizedBox(height: 17),
                            SizedBox(
                              height: 56,
                              child: TextField(
                                controller: _emailController,
                                textAlign: TextAlign.center,
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
                            ),
                            const SizedBox(height: 17),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 56,
                                  child: TextField(
                                    controller: _passController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF393939),
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Create Password',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF837E93),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      labelStyle: TextStyle(
                                        color: Color(0xFF755DC1),
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xFF837E93),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xFF9F7BFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 140,
                                  height: 56,
                                  child: TextField(
                                    controller: _repassController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF393939),
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      hintText: 'Confirm Password',
                                      hintStyle: TextStyle(
                                        color: Color(0xFF837E93),
                                        fontSize: 10,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      labelStyle: TextStyle(
                                        color: Color(0xFF755DC1),
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xFF837E93),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xFF9F7BFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: SizedBox(
                                width: 329,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final username =
                                        _usernameController.text.trim();
                                    final email = _emailController.text
                                        .trim()
                                        .toLowerCase();
                                    final pass = _passController.text.trim();
                                    final repass =
                                        _repassController.text.trim();
                                    if (validate(
                                        username, email, pass, repass)) {
                                      await context
                                          .read<AuthCubit>()
                                          .register(username, email, pass);
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      await pref.setString('email', email);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF9F7BFF),
                                  ),
                                  child: const Text(
                                    'Create account',
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
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Text(
                                  ' have an account?',
                                  textAlign: TextAlign.center,
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
                                    widget.controller.animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  },
                                  child: const Text(
                                    'Log In ',
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
                          ],
                        ),
                        if (state is AuthLoading)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: LoadingShimmer().loadingCircle(),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
