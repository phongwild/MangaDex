import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../cubit/otp_cubit.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    super.key,
    required this.callBack,
  });
  final Function(String) callBack;

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<String> _otp = List.generate(6, (_) => "");

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpField(int index, OtpCubit otpCubit) {
    return SizedBox(
      height: 20, // Kích thước giữ nguyên
      width: 20,
      child: TextFormField(
        autofocus: index == 0, // Tự động focus ô đầu tiên
        controller: _controllers[index],
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly
        ], // Chỉ cho phép nhập số
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: AppsTextStyle.text13Weight500.copyWith(color: AppColors.gray700),
        decoration: const InputDecoration(
          counterText: "",
          contentPadding:
              EdgeInsets.symmetric(vertical: 12), // Loại bỏ padding mặc định
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus(); // Chuyển sang ô tiếp theo
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus(); // Quay về ô trước
          }
          otpCubit.updateOtp(index, value, _otp);
          widget.callBack(_otp.join());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpCubit(),
      child: BlocBuilder<OtpCubit, String>(
        builder: (context, state) {
          final otpCubit = context.read<OtpCubit>();
          return Form(
            child: RawKeyboardListener(
              autofocus: false,
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.backspace)) {
                  for (int i = 0; i < _controllers.length; i++) {
                    if (_controllers[i].text.isEmpty && i > 0) {
                      FocusScope.of(context).previousFocus(); // Xử lý backspace
                      break;
                    }
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    6, (index) => _buildOtpField(index, otpCubit)),
              ),
            ),
          );
        },
      ),
    );
  }
}
