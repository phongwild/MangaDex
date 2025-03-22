import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/user/widgets/build_user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'widgets/tabbar_user_widget.dart';
import 'widgets/tabbar_view_widget.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

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

class __BodyPageState extends State<_BodyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'NettromDex',
          style: AppsTextStyle.text18Weight700
              .copyWith(color: const Color(0xff374151)),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, NettromdexRouter.setting);
            },
            child: const Icon(IconlyLight.moreSquare),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const UserInfoWidget(),
              Tabbar_user_widget(tabController: _tabController),
              const SizedBox(height: 10),
              TabbarView_widget(tabController: _tabController)
            ],
          ),
        ),
      ),
    );
  }
}
