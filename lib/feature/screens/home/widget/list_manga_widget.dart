import 'package:app/core_ui/widget/loading/loading.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/screens/detail/detail_manga_page.dart';
import 'package:app/feature/screens/home/widget/item_list_manga_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dio/dio_client.dart';

class MangaList extends StatelessWidget with NetWorkMixin {
  const MangaList({super.key});

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
    return BlocBuilder<MangaCubit, MangaState>(
      builder: (context, state) {
        if (state is MangaLoading) {
          return const Expanded(
            child: Center(
              child: VPBankLoading(),
            ),
          );
        } else if (state is MangaError) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is MangaLoaded) {
          final mangas = state.mangas;
          // final total = state.total;
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: 2 / 3,
            ),
            itemCount: mangas.length,
            itemBuilder: (context, index) {
              final manga = mangas[index];
              final coverArtId = manga.relationships.firstWhere(
                (rel) => rel.type == 'cover_art',
              );
              final coverArt = coverArtId.attributes!.fileName;
              // dlog('https://uploads.mangadex.org/covers/${manga.id}/$coverArt');
              return ItemListMangaWidget(
                coverArt: (coverArt ?? '').isNotEmpty
                    ? 'https://uploads.mangadex.org/covers/${manga.id}/$coverArt'
                    : 'https://storage-ct.lrclib.net/file/cuutruyen/uploads/manga/1106/cover/processed-0a5b2ead13a8186f4ae75739fe8b5a47.jpg',
                chapters: manga.chapterCount.toString(),
                timeUpdate: (manga.attributes.updatedAt ?? '').isNotEmpty
                    ? timeAgo(manga.attributes.updatedAt!)
                    : 'N/a',
                title: manga.attributes.title.isNotEmpty
                    ? manga.attributes.title
                    : 'N/a',
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
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
