import 'package:app/feature/bottom_navigaton/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:app/global/router/router.dart';

import '../screens/detail/detail_manga_page.dart';
import '../screens/more/more_manga_page.dart';
import '../screens/reading/read_chapter_page.dart';

class NettromdexRouter extends RouterModule {
  static const bottomNav = '/bottom-nav';
  static const detailManga = '/detail-manga';
  static const readChapter = '/read-chapter';
  static const moreManga = '/more-manga';

  @override
  Map<String, PageRoute> getRoutes(RouteSettings settings) {
    return {
      NettromdexRouter.bottomNav: MaterialPageRoute(
        builder: (_) => const BottomNav(),
        settings: settings,
      ),
      NettromdexRouter.detailManga: MaterialPageRoute(
        builder: (context) {
          final args = settings.arguments as DetailMangaPage;
          return DetailMangaPage(
            idManga: args.idManga,
            coverArt: args.coverArt,
            lastUpdate: args.lastUpdate,
            title: args.title,
          );
        },
        settings: settings,
      ),
      NettromdexRouter.readChapter: MaterialPageRoute(
        builder: (context) {
          final args = settings.arguments as ReadChapterPage;
          return ReadChapterPage(
            idChapter: args.idChapter,
            idManga: args.idManga,
            listChapters: args.listChapters,
          );
        },
        settings: settings,
      ),
      NettromdexRouter.moreManga: MaterialPageRoute(
        builder: (context) {
          final args = settings.arguments;
          if (args is MoreMangaPage) {
            return MoreMangaPage(tag: args.tag);
          } else {
            return const MoreMangaPage(); // Không có tag thì dùng mặc định
          }
        },
        settings: settings,
      ),
    };
  }
}
