import 'package:flutter/foundation.dart';
import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/manga_model.dart';

part 'manga_state.dart';

String baseUrl = 'https://api.mangadex.org/';
const int batchSize = 5; // 🛠 Giới hạn số request đồng thời tránh overload

class MangaCubit extends Cubit<MangaState> with NetWorkMixin {
  MangaCubit() : super(MangaStateInitial());

  void getManga({
    required bool isLatestUploadedChapter,
    String? translateLang,
    required int limit,
    required int offset,
  }) async {
    if (state is MangaLoading) return; // 🔥 Tránh gọi nhiều lần khi đang tải

    emit(MangaLoading());

    compute(_fetchManga, [
      isLatestUploadedChapter,
      translateLang,
      limit,
      offset,
    ]).then((result) {
      emit(MangaLoaded(result));
    }).catchError((error) {
      dlog('Lỗi khi lấy Manga: $error');
      emit(MangaError(error.toString()));
    });
  }
}

// 🛠 Hàm chạy trên Isolate để lấy Manga kèm số Chapter (Tối ưu batch request)
Future<List<Manga>> _fetchManga(List<dynamic> param) async {
  try {
    bool isLatestUploadedChapter = param[0];
    String? translateLang = param[1];
    int limit = param[2];
    int offset = param[3];

    final orderBy =
        isLatestUploadedChapter ? 'latestUploadedChapter' : 'createdAt';
    final langParam = translateLang != null
        ? '&availableTranslatedLanguage[]=$translateLang'
        : '';
    final url =
        '${baseUrl}manga?includes[]=cover_art&order[$orderBy]=desc$langParam&limit=$limit&offset=$offset';

    final response = await DioClient.create().get(url);

    if (response.statusCode == 200) {
      final rawData = response.data?['data'] as List<dynamic>? ?? [];
      List<Manga> mangaList = rawData
          .map<Manga>((json) => Manga.fromJson(json as Map<String, dynamic>))
          .toList();

      // 🔥 Chỉ lấy số chapter cho 10 manga đầu tiên để tránh overload
      // await _fetchChapterCountInBatches(mangaList.take(10).toList());

      return mangaList;
    } else {
      dlog('API Error: ${response.statusCode} - ${response.statusMessage}');
      return [];
    }
  } catch (e, stackTrace) {
    dlog('Error: $e\n$stackTrace');
    return [];
  }
}

// 🛠 Chia batch để lấy số chapter (Mỗi batch 5 request, giới hạn tổng 10 manga)
Future<void> _fetchChapterCountInBatches(List<Manga> mangaList) async {
  final cache = <String, int>{}; // 🔥 Cache số chapter đã lấy trước đó

  for (int i = 0; i < mangaList.length; i += batchSize) {
    final batch = mangaList.sublist(
      i,
      i + batchSize > mangaList.length ? mangaList.length : i + batchSize,
    );

    // 🔥 Chỉ fetch chapter nếu chưa có trong cache
    await Future.wait(batch.map((manga) async {
      if (cache.containsKey(manga.id)) {
        manga.chapterCount = cache[manga.id]!;
      } else {
        final count = await _fetchChapterCount(manga.id);
        cache[manga.id] = count;
        manga.chapterCount = count;
      }
    }));
  }
}

// 🛠 Hàm lấy số chapter của Manga (có retry nếu lỗi)
Future<int> _fetchChapterCount(String mangaId, {int retry = 2}) async {
  try {
    final response = await DioClient.create().get(
      '${baseUrl}chapter?manga=$mangaId&limit=1',
    );

    if (response.statusCode == 200 && response.data != null) {
      return response.data['total'] ?? 0;
    } else {
      return 0;
    }
  } catch (e) {
    dlog('Lỗi lấy số chapter ($retry lần retry còn lại): $e');
    if (retry > 0) {
      await Future.delayed(const Duration(seconds: 2));
      return _fetchChapterCount(mangaId, retry: retry - 1);
    }
    return 0;
  }
}
