// ignore_for_file: camel_case_types

import 'package:app/feature/screens/user/widgets/tabbar_view/follows_manga_view.dart';
import 'package:app/feature/screens/user/widgets/tabbar_view/history_manga_view.dart';
import 'package:flutter/material.dart';

class TabbarView_widget extends StatelessWidget {
  final TabController tabController;
  const TabbarView_widget({
    super.key,
    required this.tabController,
  });
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        FollowsMangaView(),
        HistoryMangaView(),
      ],
    );
  }
}
