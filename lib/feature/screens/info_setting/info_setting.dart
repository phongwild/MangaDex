import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/feature/screens/info_setting/components/change_avatar_widget.dart';
import 'package:app/feature/screens/info_setting/components/change_username_widget.dart';
import 'package:app/feature/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

import '../../../core_ui/app_theme.dart/app_text_style.dart';
import 'components/change_pass_widget.dart';

class InfoSetting extends StatelessWidget {
  const InfoSetting({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Thông tin cá nhân',
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
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                ChangeAvatarWidget(),
                ChangeUsernameWidget(),
                ChangePassWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
