import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/image_app.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:flutter/material.dart';

import '../../../models/relationship_model.dart';
import '../../../utils/parse_cover_art.dart';
import '../../detail/detail_manga_page.dart';

class ListFollowHistory extends StatelessWidget {
  const ListFollowHistory({super.key, required this.mangaList, this.onRefresh});
  final List<Manga> mangaList;
  final Future<void> Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.blue,
      backgroundColor: AppColors.bgMain,
      onRefresh: onRefresh ?? () => Future.value(),
      child: ListView.separated(
        itemCount: mangaList.length > 15 ? 15 : mangaList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.only(bottom: 50),
        separatorBuilder: (context, index) => const SizedBox(height: 5),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final manga = mangaList[index];
          final coverArtId = manga.relationships.firstWhere(
            (rel) => rel.type == 'cover_art',
            orElse: () => const Relationship(type: '', attributes: null),
          );
          final coverArt = coverArtId.attributes?.fileName ?? '';

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                NettromdexRouter.detailManga,
                arguments: DetailMangaPage(
                  idManga: manga.id,
                  coverArt: parseCoverArt(manga.id, coverArt),
                  lastUpdate: manga.attributes.updatedAt != null
                      ? timeAgo(manga.attributes.updatedAt!)
                      : 'N/a',
                  title: manga.attributes.getPreferredTitle(),
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: 165,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ImageApp(
                        imageUrl: coverArt.isNotEmpty
                            ? parseCoverArt(manga.id, coverArt)
                            : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
                        height: 160,
                        width: 110,
                        fit: BoxFit.cover,
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
                  const SizedBox(width: 10),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            manga.attributes.getPreferredTitle(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppsTextStyle.text16Weight600.copyWith(
                              color: const Color(0xff374151),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            manga.attributes.getPreferredDescription(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppsTextStyle.text14Weight400.copyWith(
                              color: const Color(0xff374151),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'C. ${manga.attributes.lastChapter ?? 'N/a'}',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: AppsTextStyle.text14Weight600
                                .copyWith(color: const Color(0xff868d98)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            manga.attributes.updatedAt != null
                                ? timeAgo(manga.attributes.updatedAt!)
                                : 'N/a',
                            style: AppsTextStyle.text14Weight400.copyWith(
                              color: const Color(0xff868d98),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
