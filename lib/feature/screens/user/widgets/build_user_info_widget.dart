import 'package:app/common/define/key_assets.dart';
import 'package:app/core/app_log.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/screens/user/widgets/avatar_user_widget.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({super.key});

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  final IsLogin _isLogin = IsLogin.getInstance();

  @override
  Widget build(BuildContext context) {
    dlog('UserInfoWidget rebuild - isLoggedIn: ${_isLogin.isLoggedIn}');

    String userName = 'Chưa đăng nhập';
    String userEmail = 'Đăng nhập để xem thông tin';
    String? avatarUrl;

    if (_isLogin.isLoggedIn) {
      userName = _isLogin.username ?? 'Không có tên';
      userEmail = _isLogin.email ?? 'Không có email';
      avatarUrl = _isLogin.avatar;
    }

    var infoColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _isLogin.isLoggedIn
          ? [
              Text(
                userName,
                style: AppsTextStyle.text16Weight700.copyWith(
                  color: const Color(0xff374151),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userEmail,
                style: AppsTextStyle.text14Weight400.copyWith(
                  color: const Color(0xff374151),
                ),
              ),
            ]
          : [
              LoadingShimmer().line(width: 100, height: 20),
              const SizedBox(height: 5),
              LoadingShimmer().line(width: 150, height: 15),
            ],
    );

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
                child: infoColumn,
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
  }
}
