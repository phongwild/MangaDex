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
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              const SliverToBoxAdapter(child: Banners()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
              SliverToBoxAdapter(
                child: Text(
                  'Mới cập nhật',
                  style: AppsTextStyle.text18Weight700
                      .copyWith(color: const Color(0xff374151)),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 800,
                  child: RepaintBoundary(child: MangaList()),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(child: more(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              ..._buildGenreSections(),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'MangaDex',
        style: AppsTextStyle.text18Weight700
            .copyWith(color: const Color(0xff374151)),
      ),
      actions: [
        IconButton(
          icon: const Icon(IconlyLight.moreSquare, color: Color(0xff374151)),
          onPressed: () =>
              Navigator.pushNamed(context, NettromdexRouter.moreManga),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  List<Widget> _buildGenreSections() {
    final genres = <Map<String, String>>[
      {
        'title': 'Self-Published',
        'tag': '891cf039-b895-47f0-9229-bef4c96eccd4'
      },
      {'title': 'One shot', 'tag': '0234a31e-a729-4e28-9d6a-3f87c4966b9e'},
      {'title': 'Romcom', 'tag': '423e2eae-a7a2-4a8b-ac03-a8351462d71d'},
      {'title': 'Action', 'tag': '391b0423-d847-456f-aff0-8b0cfc03066b'},
      {'title': 'Sci-Fi', 'tag': '256c8bd9-4904-4360-bf4f-508a76d67183'},
      {'title': 'Harem', 'tag': 'aafb99c1-7f60-43fa-b75f-fc9502ce29c7'},
    ];

    return genres.map((genre) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 220,
          child: RepaintBoundary(
            child: ListMangaByGenreWidget(
              title: genre['title']!,
              tag: genre['tag']!,
              cubit: MangaCubit()..searchManga('', tags: [genre['tag']!]),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget more(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, NettromdexRouter.moreManga),
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
}
