import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/cubit/auth_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/user/widgets/build_user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'widgets/tabbar_user_widget.dart';
import 'widgets/tabbar_view_widget.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key, required this.isNavVisible});
  final ValueNotifier<bool> isNavVisible;
  @override
  Widget build(BuildContext context) {
    return _BodyPage(isNavVisible);
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage(this.isNavVisible);
  final ValueNotifier<bool> isNavVisible;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getProfile();
    });
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
            child: const Icon(IconlyLight.setting),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const UserInfoWidget(),
                        Tabbar_user_widget(tabController: _tabController),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child:
                              TabbarView_widget(tabController: _tabController),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 100,
                right: 50,
                left: 50,
                child: ValueListenableBuilder(
                  valueListenable: widget.isNavVisible,
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () => widget.isNavVisible.value = false,
                      child: Visibility(
                        visible: widget.isNavVisible.value,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Nhấn để tạm ẩn thanh điều hướng.\nKéo sang phải để hiện lại!!',
                            textAlign: TextAlign.center,
                            style: AppsTextStyle.text14Weight400.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
