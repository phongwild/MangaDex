import 'package:app/core/app_log.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/home/widget/banner_widget.dart';
import 'package:app/feature/screens/home/widget/list_manga_by_genre_widget.dart';
import 'package:app/feature/utils/translate_lang.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../detail/detail_manga_page.dart';
import 'widget/list_manga_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MangaCubit(),
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
  final translateLang = TranslateLang();
  final _appLinks = AppLinks();
  @override
  void initState() {
    super.initState();
    // _handleInitialLink();
    // _listenToIncomingLinks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleInitialLink() async {
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _navigateFromLink(uri);
    }
  }

  void _listenToIncomingLinks() {
    _appLinks.uriLinkStream.listen((uri) {
      _navigateFromLink(uri);
    });
  }

  void _navigateFromLink(Uri uri) {
    if (uri.host == 'mangadex.org' && uri.pathSegments.contains('title')) {
      final mangaId = uri.pathSegments.last;
      dlog('(⁠≧⁠▽⁠≦⁠) Manga ID từ link là: $mangaId');

      // Quay lại trang Home trước khi điều hướng tới trang Detail
      Navigator.popUntil(context, (route) => route.isFirst);

      // Điều hướng đến trang đọc truyện
      Navigator.pushNamed(
        context,
        NettromdexRouter.detailManga,
        arguments: DetailMangaPage(
          idManga: mangaId,
          coverArt: '',
          lastUpdate: '',
          title: '',
        ),
      );
    }
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
          'MangaDex',
          style: AppsTextStyle.text18Weight700
              .copyWith(color: const Color(0xff374151)),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                NettromdexRouter.moreManga,
              );
            },
            child: const Icon(
              IconlyLight.moreSquare,
              color: Color(0xff374151),
            ),
          ),
          const SizedBox(width: 10),
          // GestureDetector(
          //   onTap: () {
          //     _showLanguageDialog(context, context.read<MangaCubit>());
          //   },
          //   child: const Icon(
          //     IconlyLight.setting,
          //     color: Color(0xff374151),
          //   ),
          // ),
          // const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Banners(),
                const SizedBox(height: 30),
                Text(
                  'Mới cập nhật',
                  style: AppsTextStyle.text18Weight700
                      .copyWith(color: const Color(0xff374151)),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 800,
                  child: MangaList(),
                ),
                const SizedBox(height: 10),
                more(),
                const SizedBox(height: 10),
                SizedBox(
                  height: 220,
                  child: ListMangaByGenreWidget(
                    title: 'Self-Published',
                    tag: '891cf039-b895-47f0-9229-bef4c96eccd4',
                    cubit: MangaCubit()
                      ..searchManga('',
                          tags: ['891cf039-b895-47f0-9229-bef4c96eccd4']),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListMangaByGenreWidget(
                    title: 'One shot',
                    tag: '0234a31e-a729-4e28-9d6a-3f87c4966b9e',
                    cubit: MangaCubit()
                      ..searchManga('',
                          tags: ['0234a31e-a729-4e28-9d6a-3f87c4966b9e']),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListMangaByGenreWidget(
                    title: 'Romcom',
                    tag: '423e2eae-a7a2-4a8b-ac03-a8351462d71d',
                    cubit: MangaCubit()
                      ..searchManga('',
                          tags: ['423e2eae-a7a2-4a8b-ac03-a8351462d71d']),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListMangaByGenreWidget(
                    title: 'Action',
                    tag: '391b0423-d847-456f-aff0-8b0cfc03066b',
                    cubit: MangaCubit()
                      ..searchManga('',
                          tags: ['391b0423-d847-456f-aff0-8b0cfc03066b']),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListMangaByGenreWidget(
                    title: 'Sci-Fi',
                    tag: '256c8bd9-4904-4360-bf4f-508a76d67183',
                    cubit: MangaCubit()
                      ..searchManga('',
                          tags: ['256c8bd9-4904-4360-bf4f-508a76d67183']),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListMangaByGenreWidget(
                    title: 'Harem',
                    tag: 'aafb99c1-7f60-43fa-b75f-fc9502ce29c7',
                    cubit: MangaCubit()
                      ..searchManga('',
                          tags: ['aafb99c1-7f60-43fa-b75f-fc9502ce29c7']),
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

  Widget more() {
    return GestureDetector(
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
    );
  }

  // Dialog chuyển đổi ngôn ngữ
  void _showLanguageDialog(BuildContext context, MangaCubit mangaCubit) {
    String selectedLang = translateLang.language;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'dialog',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chọn bản dịch',
                      style: AppsTextStyle.text18Weight700.copyWith(
                        color: const Color(0xff374151),
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),
                    RadioListTile(
                      title: Text(
                        'Vietnamese',
                        style: AppsTextStyle.text14Weight400,
                      ),
                      value: 'vi',
                      groupValue: selectedLang,
                      activeColor: const Color(0xff2563eb),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedLang = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text(
                        'English',
                        style: AppsTextStyle.text14Weight400,
                      ),
                      value: 'en',
                      groupValue: selectedLang,
                      activeColor: const Color(0xff2563eb),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedLang = value.toString();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xff4b5563),
                          ),
                          child: Text(
                            'Hủy',
                            style: AppsTextStyle.text14Weight600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            translateLang.language = selectedLang;
                            mangaCubit.getManga(
                              isLatestUploadedChapter: true,
                              limit: 25,
                              offset: 0,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2563eb),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Xác nhận',
                            style: AppsTextStyle.text14Weight600
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
