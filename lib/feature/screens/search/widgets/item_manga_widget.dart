import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core_ui/widget/loading/loading.dart';
import '../../detail/detail_manga_page.dart';

class ItemMangaWidget extends StatefulWidget {
  const ItemMangaWidget({super.key, required this.mangaList});
  final List<Manga> mangaList;

  @override
  State<ItemMangaWidget> createState() => _ItemMangaWidgetState();
}

class _ItemMangaWidgetState extends State<ItemMangaWidget> {
  String timeAgo(String utcDateTime) {
    // 1️⃣ Parse chuỗi thời gian cập nhật từ UTC
    DateTime utcTime = DateTime.parse(utcDateTime);

    // 2️⃣ Chuyển sang múi giờ Việt Nam (GMT+7)
    DateTime updateTime = utcTime.toUtc().add(const Duration(hours: 7));

    // 3️⃣ Lấy thời gian hiện tại theo múi giờ VN
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

    // 4️⃣ Tính khoảng cách thời gian
    Duration difference = now.difference(updateTime);

    // 5️⃣ Hiển thị khoảng thời gian theo kiểu "X ngày Y giờ Z phút trước"
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa mới cập nhật';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.mangaList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final manga = widget.mangaList[index];
        final coverArtId = manga.relationships.firstWhere(
          (rel) => rel.type == 'cover_art',
        );
        final coverArt = coverArtId.attributes!.fileName;
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/detail-manga',
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 160,
            margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: (coverArt ?? '').isNotEmpty
                        ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverArt'
                        : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
                    fit: BoxFit.cover,
                    height: 160,
                    width: 110,
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manga.attributes.title.isNotEmpty
                              ? manga.attributes.title
                              : 'N/a',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppsTextStyle.text16Weight600
                              .copyWith(color: const Color(0xff374151)),
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
                          (manga.attributes.updatedAt ?? '').isNotEmpty
                              ? timeAgo(manga.attributes.updatedAt!)
                              : 'N/a',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppsTextStyle.text14Weight400
                              .copyWith(color: const Color(0xff868d98)),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: AppsTextStyle.text14Weight400
                              .copyWith(color: const Color(0xff868d98)),
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
