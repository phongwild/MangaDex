import 'package:app/feature/bottom_navigaton/bottom_nav.dart';
import 'package:app/feature/screens/login_register/main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/global/router/router.dart';

import '../screens/detail/detail_manga_page.dart';
import '../screens/more/more_manga_page.dart';
import '../screens/reading/read_chapter_page.dart';
import '../screens/settings/setting_page.dart';
import '../utils/web/web_view_screen.dart';

class NettromdexRouter extends RouterModule {
  static const mainLogin = '/main-login';
  static const bottomNav = '/bottom-nav';
  static const detailManga = '/detail-manga';
  static const readChapter = '/read-chapter';
  static const moreManga = '/more-manga';
  static const setting = '/setting';
  static const webView = '/web-view';
  @override
  Map<String, PageRoute> getRoutes(RouteSettings settings) {
    return {
      NettromdexRouter.mainLogin: CupertinoPageRoute(
        builder: (_) => const MainView(),
        settings: settings,
      ),
      NettromdexRouter.bottomNav: CupertinoPageRoute(
        builder: (_) => const BottomNav(),
        settings: settings,
      ),
      NettromdexRouter.detailManga: CupertinoPageRoute(
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
      NettromdexRouter.readChapter: CupertinoPageRoute(
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
      NettromdexRouter.moreManga: CupertinoPageRoute(
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
      NettromdexRouter.setting: CupertinoPageRoute(
        builder: (context) => const SettingPage(),
        settings: settings,
      ),
      NettromdexRouter.webView: CupertinoPageRoute(
        builder: (context) {
          final args = settings.arguments as String;
          return WebViewScreen(initialUrl: args);
        },
      )
    };
  }
}
