import 'package:app/feature/utils/translate_lang.dart';
import 'package:flutter/foundation.dart';
import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/manga_model.dart';

part 'manga_state.dart';

String baseUrl = 'https://api.mangadex.org/';
final translateLang = TranslateLang();

class MangaCubit extends Cubit<MangaState> with NetWorkMixin {
  MangaCubit() : super(MangaStateInitial());

  // Lấy danh sách manga (dùng Isolate để xử lý API call)
  void getManga({
    required bool isLatestUploadedChapter,
    required int limit,
    required int offset,
  }) async {
    if (state is MangaLoading) return;

    emit(MangaLoading());

    compute(_fetchManga, [
      isLatestUploadedChapter,
      translateLang.language,
      limit,
      offset,
    ]).then((result) {
      emit(MangaLoaded(
        result['mangas'],
        total: result['total'] as int? ?? 0,
      ));
    }).catchError((error) {
      dlog('Lỗi khi lấy Manga: $error');
      emit(MangaError(error.toString()));
    });
  }

  // Tìm kiếm manga (tối ưu hóa với Isolate)
  Future<void> searchManga(
    String query, {
    List<String>? tags,
    int? offset,
  }) async {
    if (state is MangaLoading) return;
    emit(MangaLoading());

    compute(_fetchSearchManga, {
      'query': query,
      'tags': tags ?? [],
      'offset': offset ?? 0,
      'translateLang': translateLang.language,
    }).then((result) {
      final newMangaList = result['mangas'] as List<Manga>;
      final total = result['total'] as int? ?? 0;

      // Giữ dữ liệu cũ nếu scroll hoặc tìm kiếm mới
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
    }).catchError((error) {
      dlog('Lỗi khi tìm kiếm Manga: $error');
      emit(MangaError('Lỗi: $error'));
    });
  }
}

// Hàm xử lý API call cho Isolate (fetch manga)
Future<Map<String, dynamic>> _fetchManga(List<dynamic> param) async {
  try {
    final isLatestUploadedChapter = param[0] as bool;
    final translateLang = param[1] as String?;
    final limit = param[2] as int;
    final offset = param[3] as int;

    final orderBy =
        isLatestUploadedChapter ? 'latestUploadedChapter' : 'createdAt';

    final queryParams = {
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
      final mangaList =
          rawData.map<Manga>((json) => Manga.fromJson(json)).toList();
      final total = response.data?['total'] ?? 0;

      return {
        'mangas': mangaList,
        'total': total,
      };
    } else {
      dlog('API Error: ${response.statusCode}');
      return {'mangas': [], 'total': 0};
    }
  } catch (e, stackTrace) {
    dlog('Fetch Manga Error: $e\n$stackTrace');
    return {'mangas': [], 'total': 0};
  }
}

// Hàm xử lý tìm kiếm Manga cho Isolate
Future<Map<String, dynamic>> _fetchSearchManga(
    Map<String, dynamic> params) async {
  try {
    final query = params['query'] as String;
    final tags = params['tags'] as List<String>;
    final offset = params['offset'] as int;
    final translateLang = params['translateLang'] as String?;

    final response = await DioClient.create().get(
      '${baseUrl}manga',
      queryParameters: {
        'includes[]': 'cover_art',
        'title': query,
        'order[latestUploadedChapter]': 'desc',
        'limit': 10,
        'offset': offset,
        'availableTranslatedLanguage[]': translateLang,
        if (tags.isNotEmpty) 'includedTags[]': tags,
      },
    );

    if (response.statusCode == 200) {
      final rawData = response.data?['data'] as List<dynamic>;
      final mangaList =
          rawData.map<Manga>((json) => Manga.fromJson(json)).toList();
      final total = response.data?['total'] ?? 0;

      return {
        'mangas': mangaList,
        'total': total,
      };
    } else {
      dlog('API Error: ${response.statusCode}');
      return {'mangas': [], 'total': 0};
    }
  } catch (e, stackTrace) {
    dlog('Search Manga Error: $e\n$stackTrace');
    return {'mangas': [], 'total': 0};
  }
}
