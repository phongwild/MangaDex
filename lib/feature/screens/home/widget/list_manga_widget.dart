// ignore_for_file: library_private_types_in_public_api

import 'package:app/core/app_log.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/detail/detail_manga_page.dart';
import 'package:app/feature/screens/home/widget/item_list_manga_widget.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/parse_cover_art.dart';

class MangaList extends StatefulWidget {
  const MangaList({super.key});

  @override
  State<MangaList> createState() => _MangaListState();
}

class _MangaListState extends State<MangaList> {
  static const int _limit = 20; // Giảm từ 25 xuống 20 để tối ưu performance
  
  @override
  void initState() {
    super.initState();
    // Sử dụng microtask để không block UI
    Future.microtask(() {
      context.read<MangaCubit>().getManga(
        isLatestUploadedChapter: true,
        limit: _limit,
        offset: 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MangaCubit, MangaState>(
      buildWhen: (previous, current) => 
        previous != current && 
        (current is MangaLoaded || current is MangaLoading || current is MangaError),
      builder: (context, state) {
        if (state is MangaLoading) {
          return const Center(child: LoadingShimmer().loadingCircle());
        }
        if (state is MangaError) {
          dlog('Lỗi: ${state.message}');
          return const Center(child: LoadingShimmer().loadingCircle());
        }
        if (state is MangaLoaded) {
          final mangas = state.mangas;
          final displayCount = mangas.length > _limit ? _limit : mangas.length;
          
          return SizedBox(
            height: 800,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              // Tối ưu hóa: Giảm cacheExtent và addAutomaticKeepAlives
              cacheExtent: 300,
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
                childAspectRatio: 2 / 3,
              ),
              itemCount: displayCount,
              itemBuilder: (context, index) {
                final manga = mangas[index];
                final coverArtId = manga.relationships.firstWhere(
                  (rel) => rel.type == 'cover_art',
                );
                final coverArt = coverArtId.attributes?.fileName ?? '';
                
                return ItemListMangaWidget(
                  key: ValueKey(manga.id), // Thêm key để tối ưu hóa rebuild
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
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
