import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/home/widget/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'widget/list_manga_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MangaCubit()
        ..getManga(
          isLatestUploadedChapter: true,
          limit: 25,
          offset: 0,
          translateLang: 'vi',
        ),
      child: const _BodyPage(),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage();

  @override
  State<_BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<_BodyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NetTromDex',
                      style: AppsTextStyle.text18Weight700
                          .copyWith(color: const Color(0xff374151)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          NettromdexRouter.moreManga,
                        );
                      },
                      child: const Icon(IconlyLight.moreSquare),
                    )
                  ],
                ),
                const Banners(),
                const SizedBox(height: 30),
                Text(
                  'Mới cập nhật',
                  style: AppsTextStyle.text18Weight700
                      .copyWith(color: const Color(0xff374151)),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 5 * 160,
                  child: MangaList(),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NettromdexRouter.moreManga);
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Xem danh sách truyện',
                      style: AppsTextStyle.text14Weight600
                          .copyWith(color: const Color(0xff4b5563)),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
