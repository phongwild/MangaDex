import 'package:app/common/define/key_assets.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/screens/user/widgets/avatar_user_widget.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({super.key});

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  final IsLogin _isLogin = IsLogin.getInstance();

  @override
  Widget build(BuildContext context) {
    String userName = 'Chưa đăng nhập';
    String userEmail = 'Đăng nhập để xem thông tin';
    String? avatarUrl;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is AuthProfileLoaded,
      builder: (context, state) {
        if (state is AuthProfileLoaded) {
          userName = state.user.username ?? 'Không có tên';
          userEmail = state.user.email ?? 'Không có email';
          avatarUrl = state.user.avatar;
        }
        return SizedBox(
          height: 210,
          width: double.infinity,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    KeyAssets.imgBannerProfile,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 120, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: _isLogin.isLoggedIn
                          ? [
                              Text(
                                userName,
                                style: AppsTextStyle.text16Weight700.copyWith(
                                  color: const Color(0xff374151),
                                ),
                              ),
                              Text(
                                userEmail,
                                style: AppsTextStyle.text14Weight400.copyWith(
                                  color: const Color(0xff374151),
                                ),
                              ),
                            ]
                          : [
                              LoadingShimmer().line(width: 100, height: 20),
                              LoadingShimmer().line(width: 150, height: 15),
                            ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: AvatarUserWidget(imageUrl: avatarUrl),
              ),
            ],
          ),
        );
      },
    );
  }
}
