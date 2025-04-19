import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../core_ui/design_system/app_button.dart';
import '../../cubit/auth_cubit.dart';
import 'widget/otp_form.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String? varifyCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            widget.controller.animateToPage(1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          child: const Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        backgroundColor: AppColors.bgMain,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: BlocProvider(
            create: (_) => AuthCubit(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text('Xác thực mã OTP', style: AppsTextStyle.text24Weight700),
                const SizedBox(height: 12),

                Text(
                    'Vui lòng nhập mã gồm 6 chữ số đã được gửi đến email của bạn.',
                    style: AppsTextStyle.text14Weight400
                        .copyWith(color: AppColors.gray700)),
                const SizedBox(height: 32),

                // Phần nhập mã và xác nhận
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthOtpSent) {
                      showToast('Đăng kí thành công');
                      widget.controller.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    } else if (state is AuthError) {
                      showToast('Sai otp!!', isError: true);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.gray700,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: OtpForm(
                              callBack: (code) {
                                varifyCode = code;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: AppButton(
                              onPressed: () async {
                                if (varifyCode == null || varifyCode!.isEmpty) {
                                  showToast('Hãy điền otp!!', isError: true);
                                  return;
                                }
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final email = prefs.getString('email');
                                if (email != null) {
                                  await context
                                      .read<AuthCubit>()
                                      .verifyOtp(email, varifyCode!);
                                }
                              },
                              borderRadius: 15,
                              action: 'Xác nhận',
                              colorDisable: AppColors.blue,
                              colorEnable: AppColors.blue,
                              overlayColor: false,
                              loading: state is AuthLoading,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Timer resend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gửi lại mã sau: ',
                      style: AppsTextStyle.text13Weight500
                          .copyWith(color: AppColors.gray700),
                    ),
                    TimerCountdown(
                      enableDescriptions: false,
                      timeTextStyle: AppsTextStyle.text13Weight500
                          .copyWith(color: AppColors.gray700),
                      colonsTextStyle: AppsTextStyle.text13Weight500
                          .copyWith(color: AppColors.gray700),
                      format: CountDownTimerFormat.minutesSeconds,
                      endTime: DateTime.now().add(const Duration(minutes: 2)),
                      onEnd: () {
                        //
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
