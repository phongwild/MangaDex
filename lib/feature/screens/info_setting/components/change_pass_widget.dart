import 'package:app/core_ui/design_system/app_button.dart';
import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../widgets/app_text_field.dart';

class ChangePassWidget extends StatelessWidget {
  const ChangePassWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final TextEditingController oldPasswordCtrl = TextEditingController();
    final TextEditingController newPasswordCtrl = TextEditingController();
    final TextEditingController confirmPasswordCtrl = TextEditingController();
    void changePass() {
      if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
        showToast('Mật khẩu không khớp!!!', isError: true);
        return;
      }
      if (oldPasswordCtrl.text.isEmpty ||
          newPasswordCtrl.text.isEmpty ||
          confirmPasswordCtrl.text.isEmpty) {
        showToast('Không được để trống thông tin!!', isError: true);
        return;
      }
      if (newPasswordCtrl.text.length < 6 ||
          confirmPasswordCtrl.text.length < 6) {
        showToast('Mật khẩu phải có ít nhất 6 ký tự!!', isError: true);
        return;
      }
      context
          .read<AuthCubit>()
          .changePass(oldPasswordCtrl.text, newPasswordCtrl.text);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text('Đổi mật khẩu', style: AppsTextStyle.text16Weight700),
          AppsTextField(
            label: 'Mật khẩu cũ',
            controller: oldPasswordCtrl,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          AppsTextField(
            label: 'Mật khẩu mới',
            controller: newPasswordCtrl,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          AppsTextField(
            label: 'Xác nhận mật khẩu mới',
            controller: confirmPasswordCtrl,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthChangePassSuccess) {
                oldPasswordCtrl.value = TextEditingValue.empty;
                newPasswordCtrl.value = TextEditingValue.empty;
                confirmPasswordCtrl.value = TextEditingValue.empty;
                showToast('Câp nhật mật khẩu thành công');
                return;
              }
            },
            builder: (context, state) {
              return AppButton(
                onPressed: () {
                  changePass();
                },
                action: 'Lưu',
                borderRadius: 12,
                colorDisable: AppColors.blue,
                colorEnable: AppColors.blue,
                padding: const EdgeInsets.symmetric(vertical: 8),
                loading: state is AuthChangePassLoading,
              );
            },
          )
        ],
      ),
    );
  }
}
