import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/screens/home/widget/item_list_manga_widget.dart';
import 'package:app/feature/screens/more/more_manga_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../router/nettromdex_router.dart';
import '../../../utils/time_utils.dart';
import '../../detail/detail_manga_page.dart';

class ListMangaByGenreWidget extends StatelessWidget {
  const ListMangaByGenreWidget({
    super.key,
    required this.title,
    required this.tag,
  });
  final String title;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppsTextStyle.text18Weight700
              .copyWith(color: const Color(0xff374151)),
        ),
        const SizedBox(height: 10),
        BlocProvider(
          create: (context) => MangaCubit()..searchManga('', tags: [tag]),
          child: SizedBox(
            height: 160,
            child: list(),
          ),
        ),
        more(context)
      ],
    );
  }

  Widget more(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, NettromdexRouter.moreManga,
            arguments: MoreMangaPage(tag: tag));
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          'Xem thêm',
          style: AppsTextStyle.text14Weight600
              .copyWith(color: const Color(0xff4b5563)),
        ),
      ),
    );
  }

  Widget list() {
    return BlocBuilder<MangaCubit, MangaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is MangaLoading) {
          return LoadingShimmer().loadingCircle();
        }
        if (state is MangaError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        }
        if (state is MangaLoaded) {
          final mangas = state.mangas;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: mangas.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final manga = mangas[index];
              final coverArtId = manga.relationships.firstWhere(
                (rel) => rel.type == 'cover_art',
              );
              final coverArt = coverArtId.attributes?.fileName ?? '';
              return ItemListMangaWidget(
                coverArt: coverArt.isNotEmpty
                    ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverArt'
                    : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
                chapters: manga.attributes.lastChapter ?? 'N/a',
                timeUpdate: (manga.attributes.updatedAt ?? '').isNotEmpty
                    ? timeAgo(manga.attributes.updatedAt!)
                    : 'N/a',
                title: manga.attributes.title.isNotEmpty
                    ? manga.attributes.title
                    : 'N/a',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NettromdexRouter.detailManga,
                    arguments: DetailMangaPage(
                      idManga: manga.id,
                      coverArt:
                          'https://uploads.mangadex.org/covers/${manga.id}/$coverArt',
                      lastUpdate: (manga.attributes.updatedAt ?? '').isNotEmpty
                          ? timeAgo(manga.attributes.updatedAt!)
                          : 'N/a',
                      title: manga.attributes.title.isNotEmpty
                          ? manga.attributes.title
                          : 'N/a',
                    ),
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
