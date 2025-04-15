// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class Tabbar_user_widget extends StatelessWidget {
  final TabController tabController;
  const Tabbar_user_widget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: const Color(0xff1d64f1),
      labelStyle: AppsTextStyle.text14Weight500,
      unselectedLabelColor: const Color(0xff374151),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 4, color: Color(0xff1d64f1)),
        insets: EdgeInsets.symmetric(horizontal: 16),
      ),
      tabs: const [
        Tab(text: 'Truyện đã lưu'),
        Tab(text: 'Lịch sử đọc'),
      ],
    );
  }
}
