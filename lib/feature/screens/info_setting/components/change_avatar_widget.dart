import 'dart:io';

import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../../core_ui/design_system/app_button.dart';

class ChangeAvatarWidget extends StatefulWidget {
  const ChangeAvatarWidget({super.key});

  @override
  State<ChangeAvatarWidget> createState() => _ChangeAvatarWidgetState();
}

class _ChangeAvatarWidgetState extends State<ChangeAvatarWidget> {
  final ValueNotifier<File?> _avatarImage = ValueNotifier<File?>(null);
  final IsLogin _isLogin = IsLogin.getInstance();
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _avatarImage.value = File(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Text('Đổi avatar', style: AppsTextStyle.text16Weight700),
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: ValueListenableBuilder<File?>(
                    valueListenable: _avatarImage,
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: value != null
                              ? Image.file(
                                  value,
                                  width: 95,
                                  height: 95,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 95,
                                  height: 95,
                                  color: AppColors.gray300,
                                  child: const Icon(
                                    IconlyLight.profile,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUploadAvatarSuccess) {
                _isLogin.updateAvatar(
                  state.avatar ?? 'https://i.ibb.co/bj1HX9mV/a51635750d36.gif',
                );
                showToast('Cập nhật avatar thành công >.< !!');
                return;
              }
              if (state is AuthUploadAvatarError) {
                showToast('Có lỗi xảy ra', isError: true);
              }
            },
            builder: (context, state) {
              return AppButton(
                onPressed: () {
                  if (_avatarImage.value == null) {
                    showToast('Hãy chọn ảnh trước khi lưu!', isError: true);
                    return;
                  }
                  context.read<AuthCubit>().uploadAvatar(_avatarImage.value!);
                },
                action: 'Lưu',
                borderRadius: 12,
                colorDisable: AppColors.blue,
                colorEnable: AppColors.blue,
                padding: const EdgeInsets.symmetric(vertical: 8),
                loading: state is AuthUploadAvatarLoading,
              );
            },
          )
        ],
      ),
    );
  }
}
