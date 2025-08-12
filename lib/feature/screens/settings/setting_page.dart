import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/settings/widgets/dialog_setting.dart';
import 'package:app/feature/utils/cached_manage_app.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:app/feature/widgets/button_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../core_ui/app_theme.dart/app_text_style.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BodyPage();
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage();

  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final IsLogin _isLogin = IsLogin.getInstance();
  void showDialogLogout() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogSetting(
          title: 'Bạn có muốn đăng xuất không?',
          confirmText: 'Yẹt sơ',
          cancelText: 'Nooo',
          onConfirm: () {
            context.read<AuthCubit>().logout();
            showToast('Đăng xuất thành công');
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cài đặt',
          style:
              AppsTextStyle.text18Weight700.copyWith(color: AppColors.gray700),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.gray700,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 10,
            children: [
              ButtonAppWidget(
                text: 'Thông tin cá nhân',
                color: const Color(0xff2563eb),
                textColor: Colors.white,
                onTap: () {
                  if (!_isLogin.isLoggedIn) {
                    showToast(
                      'Bạn cần phải đăng nhập để sử dụng chức năng này',
                      isError: true,
                    );
                    return;
                  }
                  Navigator.pushNamed(context, NettromdexRouter.infoSetting);
                },
                isBoxShadow: false,
                leadingIcon:
                    const Icon(IconlyLight.profile, color: Colors.white),
              ),
              ButtonAppWidget(
                text: 'Xoá bộ nhớ đệm',
                color: const Color(0xff2563eb),
                textColor: Colors.white,
                onTap: () async {
                  await clearAllCacheFolder();
                  showToast('Xoá thành công');
                },
                isBoxShadow: false,
                leadingIcon:
                    const Icon(IconlyLight.delete, color: Colors.white),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final loggedIn = state is AuthProfileLoaded;

                  return ButtonAppWidget(
                    text: loggedIn ? 'Đăng xuất' : 'Đăng nhập',
                    color: const Color(0xff2563eb),
                    textColor: Colors.white,
                    onTap: () {
                      if (loggedIn) {
                        showDialogLogout();
                      } else {
                        Navigator.pushNamed(
                            context, NettromdexRouter.mainLogin);
                      }
                    },
                    isBoxShadow: false,
                    leadingIcon: Icon(
                      loggedIn ? IconlyLight.logout : IconlyLight.login,
                      color: Colors.white,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
