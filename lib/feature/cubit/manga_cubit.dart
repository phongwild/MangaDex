import 'package:flutter/foundation.dart';
import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/manga_model.dart';

part 'manga_state.dart';

String baseUrl = 'https://api.mangadex.org/';
const int batchSize = 5;

class MangaCubit extends Cubit<MangaState> with NetWorkMixin {
  MangaCubit() : super(MangaStateInitial());

  void getManga({
    required bool isLatestUploadedChapter,
    String? translateLang,
    required int limit,
    required int offset,
  }) async {
    if (state is MangaLoading) return;

    emit(MangaLoading());

    compute(_fetchManga, [
      isLatestUploadedChapter,
      translateLang,
      limit,
      offset,
    ]).then((result) {
      emit(MangaLoaded(
        result['mangas'],
        total: result['total'] as int?,
      ));
    }).catchError((error) {
      dlog('Lỗi khi lấy Manga: $error');
      emit(MangaError(error.toString()));
    });
  }

  Future<void> searchManga(String query,
      {List<String>? tags, int? offset}) async {
    try {
      if (state is MangaLoading) return;
      emit(MangaLoading());

      final response = await callApiGet(
        endPoint: '${baseUrl}manga',
        json: {
          'includes[]': 'cover_art',
          'title': query,
          'order[latestUploadedChapter]': 'desc',
          'limit': 10,
          'offset': offset ?? 0,
          'availableTranslatedLanguage[]': 'vi',
          if (tags != null && tags.isNotEmpty) 'includedTags[]': tags,
        },
      );

      if (response.statusCode == 200) {
        final rawData = response.data?['data'];

        if (rawData is List && rawData.isNotEmpty) {
          List<Manga> newMangaList = rawData
              .map<Manga>(
                  (json) => Manga.fromJson(json as Map<String, dynamic>))
              .toList();
          final total = response.data?['total'] as int? ?? 0;

          // Giữ dữ liệu cũ nếu có, chỉ reset khi search mới
          List<Manga> updatedList = [];
          if (state is MangaLoaded &&
              query.isEmpty &&
              (tags == null || tags.isEmpty)) {
            updatedList = [
              ...(state as MangaLoaded).mangas,
              ...newMangaList,
            ];
          } else {
            updatedList = newMangaList;
          }

          emit(MangaLoaded(updatedList, total: total));
        } else {
          dlog('Không tìm thấy manga phù hợp.');
          emit(const MangaError('Không tìm thấy manga phù hợp.'));
        }
      } else {
        dlog('API trả về lỗi: ${response.statusCode} - ${response.data}');
        emit(MangaError('Lỗi API: ${response.statusCode}'));
      }
    } catch (e, stackTrace) {
      dlog('Lỗi tìm kiếm manga: $e\nStackTrace: $stackTrace');
      emit(
          const MangaError('Đã xảy ra lỗi khi tải dữ liệu. Vui lòng thử lại!'));
    }
  }
}

Future<Map<String, dynamic>> _fetchManga(List<dynamic> param) async {
  try {
    bool isLatestUploadedChapter = param[0];
    String? translateLang = param[1];
    int limit = param[2];
    int offset = param[3];

    final orderBy =
        isLatestUploadedChapter ? 'latestUploadedChapter' : 'createdAt';

    // Tạo query parameters dưới dạng JSON
    final Map<String, dynamic> queryParams = {
      'includes[]': ['cover_art'],
      'order[$orderBy]': 'desc',
      'limit': limit,
      'offset': offset,
    };

    if (translateLang != null) {
      queryParams['availableTranslatedLanguage[]'] = translateLang;
    }

    final response = await DioClient.create().get(
      '${baseUrl}manga',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final rawData = response.data?['data'];
      List<Manga> mangaList = rawData
          .map<Manga>((json) => Manga.fromJson(json as Map<String, dynamic>))
          .toList();
      final total = response.data?['total'] as int? ?? 0;

      return {
        'mangas': mangaList,
        'total': total,
      };
    } else {
      dlog('API Error: ${response.statusCode} - ${response.statusMessage}');
      return {'mangas': [], 'total': 0};
    }
  } catch (e, stackTrace) {
    dlog('Error: $e\n$stackTrace');
    return {'mangas': [], 'total': 0};
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
