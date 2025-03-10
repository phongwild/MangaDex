import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:app/feature/utils/image_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../detail/detail_manga_page.dart';

class Banners extends StatefulWidget {
  const Banners({
    super.key,
  });

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  final ValueNotifier<int> activeIndexNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MangaCubit()..searchManga('', followedCount: true, limit: 5),
      child: BlocBuilder<MangaCubit, MangaState>(
        buildWhen: (previous, current) => current is MangaLoaded,
        builder: (context, state) {
          if (state is MangaLoaded) {
            final mangas = state.mangas.take(5).toList();
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: banner(mangas),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<int>(
                  valueListenable: activeIndexNotifier,
                  builder: (BuildContext context, int value, Widget? child) {
                    return dotIndicator(
                      value,
                      mangas,
                    );
                  },
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget banner(List<Manga> mangas) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: mangas.length,
      onPageChanged: (value) {
        activeIndexNotifier.value = value;
      },
      itemBuilder: (BuildContext context, int index) {
        final manga = mangas[index];
        final coverArtId = manga.relationships.firstWhere(
          (rel) => rel.type == 'cover_art',
        );
        final coverArt = coverArtId.attributes!.fileName;
        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double scale = 1.0;
            if (_pageController.position.haveDimensions) {
              double pageOffset = _pageController.page ?? 0;
              double currentPage = index - pageOffset;
              scale = (1 - (currentPage.abs() * 0.2)).clamp(0.8, 1.0);
            }

            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: bannerItem(
            (coverArt ?? '').isNotEmpty
                ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverArt'
                : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
            manga.attributes.title.isNotEmpty ? manga.attributes.title : 'N/a',
            manga.attributes.description.isNotEmpty
                ? manga.attributes.description
                : 'N/a',
            manga.id,
          ),
        );
      },
    );
  }

  Widget bannerItem(
      String imageUrl, String title, String desc, String idManga) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageApp(
              imageUrl: imageUrl,
              width: 200,
              height: 200,
              errorWidget: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail-manga',
                  arguments: DetailMangaPage(
                    idManga: idManga,
                    coverArt: imageUrl,
                    lastUpdate: '',
                    title: title,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppsTextStyle.text16Weight600
                        .copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    desc,
                    style: AppsTextStyle.text14Weight500
                        .copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget dotIndicator(int activeIndex, List<Manga> mangas) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: mangas.asMap().entries.map(
          (i) {
            final index = i.key;
            final isActive = index == activeIndex;
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? const Color(0xff1f2937)
                    : const Color(0xff9ba1aa),
              ),
            );
          },
        ).toList());
  }
}
