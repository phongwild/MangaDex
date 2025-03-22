import 'package:app/common/define/key_assets.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/auth_cubit.dart';
import 'widget/otp_form.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

// Hàm lấy email từ SharedPreferences
Future<String?> _getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

class _VerifyScreenState extends State<VerifyScreen> {
  String? varifyCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13, right: 15),
              child: Stack(
                children: [
                  Image.asset(
                    KeyAssets.img3,
                    width: 428,
                    height: 457,
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.animateToPage(1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: BlocProvider(
                create: (context) => AuthCubit(),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm the code\n',
                      style: TextStyle(
                        color: Color(0xFF755DC1),
                        fontSize: 25,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      child: BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthOtpSent) {
                            showToast('Đăng kí thành công');
                            widget.controller.animateToPage(0,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);
                          } else if (state is AuthError) {
                            print('Error message: ${state.error}');
                            showToast('Sai otp!!', isError: true);
                          }
                        },
                        builder: (context, state) {
                          return Stack(
                            children: [
                              // Các widget chính, gồm cả OtpForm và ElevatedButton
                              Column(
                                children: [
                                  Container(
                                    width: 329,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xFF9F7BFF)),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60),
                                      child: OtpForm(
                                        callBack: (code) {
                                          varifyCode = code;
                                          print(varifyCode);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 32,
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: SizedBox(
                                      width: 329,
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (varifyCode == null) {
                                            showToast('Hãy điền otp!!',
                                                isError: true);
                                            return;
                                          }
                                          String? email = await _getEmail();
                                          String otp = varifyCode!;
                                          // ignore: use_build_context_synchronously
                                          await context
                                              .read<AuthCubit>()
                                              .verifyOtp(email!, otp);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF9F7BFF),
                                        ),
                                        child: const Text(
                                          'confirm',
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

                              // Nếu trạng thái là AuthLoading, hiển thị loading overlay
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
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Resend  ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TimerCountdown(
                          spacerWidth: 0,
                          enableDescriptions: false,
                          colonsTextStyle: const TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          timeTextStyle: const TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          format: CountDownTimerFormat.minutesSeconds,
                          endTime: DateTime.now().add(
                            const Duration(
                              minutes: 2,
                              seconds: 0,
                            ),
                          ),
                          onEnd: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 37,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: InkWell(
                onTap: () {
                  widget.controller.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Text(
                  'A 6-digit verification code has been sent to info@aidendesign.com',
                  style: TextStyle(
                    color: Color(0xFF837E93),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
