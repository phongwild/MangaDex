import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/models/user.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../../core_ui/design_system/app_button.dart';
import '../../../utils/toast_app.dart';
import '../../../widgets/app_text_field.dart';

class ChangeUsernameWidget extends StatelessWidget {
  const ChangeUsernameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameCtrl = TextEditingController();
    final IsLogin _isLogin = IsLogin.getInstance();

    void updateUsername() {
      if (usernameCtrl.text.isEmpty) {
        showToast('Vui lòng nhập username', isError: true);
        return;
      }
      User user = User(
        username: usernameCtrl.text,
      );
      context.read<AuthCubit>().updateProfile(user);
    }

    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text('Đổi username', style: AppsTextStyle.text16Weight700),
          AppsTextField(
            label: 'Username',
            controller: usernameCtrl,
            keyboardType: TextInputType.text,
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUpdateProfileSuccess) {
                _isLogin.updateUsername(usernameCtrl.value.toString());
                usernameCtrl.value = TextEditingValue.empty;
                showToast('Cập nhật username thành công >.< !!');
                return;
              }
              if (state is AuthUpdateProfileError) {
                showToast('Có lỗi xảy ra', isError: true);
              }
            },
            builder: (context, state) {
              return AppButton(
                onPressed: () => updateUsername(),
                action: 'Lưu',
                borderRadius: 12,
                colorDisable: AppColors.blue,
                colorEnable: AppColors.blue,
                padding: const EdgeInsets.symmetric(vertical: 8),
                loading: state is AuthUpdateProfileLoading,
              );
            },
          )
        ],
      ),
    );
  }
}
