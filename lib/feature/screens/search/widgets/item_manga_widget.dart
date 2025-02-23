import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core_ui/widget/loading/loading.dart';
import '../../../models/relationship_model.dart';
import '../../detail/detail_manga_page.dart';

class ItemMangaWidget extends StatelessWidget {
  const ItemMangaWidget({super.key, required this.mangaList});
  final List<Manga> mangaList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mangaList.length > 15 ? 15 : mangaList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(), // 🔥 Thêm hiệu ứng cuộn mượt
      itemBuilder: (context, index) {
        final manga = mangaList[index];
        final coverArtId = manga.relationships.firstWhere(
          (rel) => rel.type == 'cover_art',
          orElse: () => Relationship(type: '', attributes: null),
        );
        final coverArt = coverArtId.attributes?.fileName ?? '';

        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail-manga',
              arguments: DetailMangaPage(
                idManga: manga.id,
                coverArt:
                    'https://uploads.mangadex.org/covers/${manga.id}/$coverArt',
                lastUpdate: manga.attributes.updatedAt != null
                    ? timeAgo(manga.attributes.updatedAt!)
                    : 'N/a',
                title: manga.attributes.title.isNotEmpty
                    ? manga.attributes.title
                    : 'N/a',
              ),
            );
          },
          child: Container(
            width: double
                .infinity, // 🔥 Tối ưu: dùng `double.infinity` thay vì `MediaQuery`
            height: 160,
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: coverArt.isNotEmpty
                        ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverArt'
                        : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
                    fit: BoxFit.cover,
                    height: 160,
                    width: 110,
                    fadeInDuration: const Duration(
                        milliseconds: 300), // 🔥 Tối ưu: Giảm giật khi load ảnh
                    placeholder: (context, url) =>
                        const Center(child: VPBankLoading()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manga.attributes.title.isNotEmpty
                              ? manga.attributes.title
                              : 'N/a',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppsTextStyle.text16Weight600.copyWith(
                            color: const Color(0xff374151),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          manga.attributes.description.isNotEmpty
                              ? manga.attributes.description
                              : 'N/a',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppsTextStyle.text14Weight400.copyWith(
                            color: const Color(0xff374151),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'C. null',
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
    );
  }
}
