import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:app/feature/widgets/button_app_widget.dart';
import 'package:flutter/cupertino.dart';
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
            children: [
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              ButtonAppWidget(
                text: _isLogin.isLoggedIn ? 'Đăng xuất' : 'Đăng nhập',
                color: const Color(0xff2563eb),
                textColor: Colors.white,
                onTap: () {
                  _isLogin.isLoggedIn
                      ? context.read<AuthCubit>().logout()
                      : Navigator.pushNamed(
                          context, NettromdexRouter.mainLogin);
                },
                isBoxShadow: false,
                leadingIcon: BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLogoutSuccess) {
                      showToast('Đăng xuất thành công!!');
                    }
                  },
                  child: IconButton(
                    onPressed: () {},
                    icon: _isLogin.isLoggedIn
                        ? const Icon(
                            IconlyLight.logout,
                            color: Colors.white,
                          )
                        : const Icon(
                            IconlyLight.login,
                            color: Colors.white,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
