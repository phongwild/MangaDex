import 'package:app/core/app_log.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/screens/home/widget/item_list_manga_widget.dart';
import 'package:app/feature/screens/more/more_manga_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../router/nettromdex_router.dart';
import '../../../utils/parse_cover_art.dart';
import '../../../utils/time_utils.dart';
import '../../detail/detail_manga_page.dart';

class ListMangaByGenreWidget extends StatelessWidget {
  final String title;
  final String tag;
  final MangaCubit cubit;

  const ListMangaByGenreWidget({
    super.key,
    required this.title,
    required this.tag,
    required this.cubit,
  });

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
        BlocProvider.value(
          value: cubit,
          child: SizedBox(
            height: 160,
            child: RepaintBoundary(child: _ListMangaList()),
          ),
        ),
        _moreButton(context)
      ],
    );
  }

  Widget _moreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          NettromdexRouter.moreManga,
          arguments: MoreMangaPage(tag: tag),
        );
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
}

class _ListMangaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangaCubit, MangaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is MangaLoading) {
          return Center(child: LoadingShimmer().loadingCircle());
        }
        if (state is MangaError) {
          dlog('Lỗi: ${state.message}');
          return Center(child: LoadingShimmer().loadingCircle());
        }
        if (state is MangaLoaded) {
          final mangas = state.mangas;
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: mangas.length,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              final coverArtId = manga.relationships.firstWhere(
                (rel) => rel.type == 'cover_art',
              );
              final coverArt = coverArtId.attributes?.fileName ?? '';
              return ItemListMangaWidget(
                coverArt: coverArt.isNotEmpty
                    ? parseCoverArt(manga.id, coverArt)
                    : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
                chapters: manga.attributes.lastChapter ?? 'N/a',
                timeUpdate: (manga.attributes.updatedAt ?? '').isNotEmpty
                    ? timeAgo(manga.attributes.updatedAt!)
                    : 'N/a',
                title: manga.attributes.getPreferredTitle(),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NettromdexRouter.detailManga,
                    arguments: DetailMangaPage(
                      idManga: manga.id,
                      coverArt: parseCoverArt(manga.id, coverArt),
                      lastUpdate: (manga.attributes.updatedAt ?? '').isNotEmpty
                          ? timeAgo(manga.attributes.updatedAt!)
                          : 'N/a',
                      title: manga.attributes.getPreferredTitle(),
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
