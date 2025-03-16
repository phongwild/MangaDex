import 'package:app/feature/utils/translate_lang.dart';
import 'package:flutter/foundation.dart';
import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/app_connection_utils.dart';
import '../models/manga_model.dart';

part 'manga_state.dart';

String baseUrl = 'https://api.mangadex.org/';
final translateLang = TranslateLang();
final ConnectionUtils connectionUtils = ConnectionUtils();

class MangaCubit extends Cubit<MangaState> with NetWorkMixin {
  MangaCubit() : super(MangaStateInitial()) {
    connectionUtils.addListener(_onNetworkChanged);
  }
  bool _isWaitingForNetwork = false;
  Map<String, dynamic>? _lastFetchParams;
  bool isDisposed = false; // 🛡 Tránh gọi API khi Cubit bị dispose

  @override
  Future<void> close() {
    isDisposed = true; // Đánh dấu đã dispose
    connectionUtils.removeListener(_onNetworkChanged);
    return super.close();
  }

  void _onNetworkChanged(bool isConnected) {
    if (isConnected && _isWaitingForNetwork && _lastFetchParams != null) {
      _isWaitingForNetwork = false;
      _retryLastRequest();
    }
  }

  void _retryLastRequest() {
    if (isDisposed || _lastFetchParams == null) return;

    final method = _lastFetchParams!['method'];
    if (method == 'getManga') {
      getManga(
        isLatestUploadedChapter: _lastFetchParams!['isLatestUploadedChapter'],
        limit: _lastFetchParams!['limit'],
        offset: _lastFetchParams!['offset'],
      );
    } else if (method == 'searchManga') {
      searchManga(
        _lastFetchParams!['query'],
        tags: _lastFetchParams!['tags'],
        offset: _lastFetchParams!['offset'],
        limit: _lastFetchParams!['limit'],
        followedCount: _lastFetchParams!['followedCount'],
      );
    }
  }

  // Lấy danh sách manga (dùng Isolate để xử lý API call)
  void getManga({
    required bool isLatestUploadedChapter,
    required int limit,
    required int offset,
  }) async {
    if (state is MangaLoading || isDisposed) return;

    if (!connectionUtils.isActive) {
      _isWaitingForNetwork = true;
      _lastFetchParams = {
        'method': 'getManga',
        'isLatestUploadedChapter': isLatestUploadedChapter,
        'limit': limit,
        'offset': offset,
      };
      emit(const MangaError('Không có kết nối mạng!'));
      return;
    }

    emit(MangaLoading());

    final result = compute(_fetchManga, [
      isLatestUploadedChapter,
      translateLang.language,
      limit,
      offset,
    ]);
    if (isDisposed) return; //Kiểm tra trc khi emit
    result.then((result) {
      emit(MangaLoaded(
        result['mangas'],
        total: result['total'] as int? ?? 0,
      ));
    }).catchError((error) {
      if (isDisposed) return; //Kiểm tra trc khi emit
      dlog('Lỗi khi lấy Manga: $error');
      emit(MangaError(error.toString()));
    });
  }

  // Tìm kiếm manga (tối ưu hóa với Isolate)
  Future<void> searchManga(
    String query, {
    List<String>? tags,
    int? offset,
    int limit = 10,
    bool followedCount = false,
  }) async {
    if (state is MangaLoading || isDisposed) return;

    if (!connectionUtils.isActive) {
      _isWaitingForNetwork = true;
      _lastFetchParams = {
        'method': 'searchManga',
        'query': query,
        'tags': tags ?? [],
        'offset': offset ?? 0,
        'limit': limit,
        'followedCount': followedCount,
      };
      emit(const MangaError(
          "Không có kết nối mạng! Đợi kết nối lại để tải dữ liệu."));
      return;
    }

    emit(MangaLoading());

    try {
      Map<String, dynamic> result;

      if (limit > 5) {
        // 🔥 Chạy trên Isolate nếu limit lớn
        result = await compute(_fetchSearchManga, {
          'query': query,
          'tags': tags ?? [],
          'offset': offset ?? 0,
          'limit': limit,
          'translateLang': translateLang.language,
          'followedCount': followedCount,
        });
      } else {
        // 🚀 Gọi trực tiếp nếu limit nhỏ để giảm overhead
        result = await _fetchSearchManga({
          'query': query,
          'tags': tags ?? [],
          'offset': offset ?? 0,
          'limit': limit,
          'translateLang': translateLang.language,
          'followedCount': followedCount,
        });
      }

      emit(MangaLoaded(
        result['mangas'] as List<Manga>,
        total: result['total'] as int? ?? 0,
      ));
    } catch (error) {
      if (isDisposed) return;
      dlog('Lỗi khi tìm kiếm Manga: $error');
      emit(MangaError('Lỗi: $error'));
    }
  }

  // Future<void> searchManga(
  //   String query, {
  //   List<String>? tags,
  //   int? offset,
  //   int limit = 10,
  //   bool followedCount = false,
  // }) async {
  //   if (state is MangaLoading || isDisposed) return;

  //   if (!connectionUtils.isActive) {
  //     _isWaitingForNetwork = true;
  //     _lastFetchParams = {
  //       'method': 'searchManga',
  //       'query': query,
  //       'tags': tags ?? [],
  //       'offset': offset ?? 0,
  //       'limit': limit,
  //       'followedCount': followedCount,
  //     };
  //     emit(const MangaError(
  //         "Không có kết nối mạng! Đợi kết nối lại để tải dữ liệu."));
  //     return;
  //   }

  //   emit(MangaLoading());

  //   final result = compute(_fetchSearchManga, {
  //     'query': query,
  //     'tags': tags ?? [],
  //     'offset': offset ?? 0,
  //     'limit': limit,
  //     'translateLang': translateLang.language,
  //     'followedCount': followedCount,
  //   });
  //   if (isDisposed) return; //Kiểm tra trc khi emit
  //   result.then((result) {
  //     final newMangaList = result['mangas'] as List<Manga>;
  //     final total = result['total'] as int? ?? 0;

  //     // Giữ dữ liệu cũ nếu scroll hoặc tìm kiếm mới
  //     List<Manga> updatedList = [];
  //     if (state is MangaLoaded &&
  //         query.isEmpty &&
  //         (tags == null || tags.isEmpty)) {
  //       updatedList = [
  //         ...(state as MangaLoaded).mangas,
  //         ...newMangaList,
  //       ];
  //     } else {
  //       updatedList = newMangaList;
  //     }

  //     emit(MangaLoaded(updatedList, total: total));
  //   }).catchError((error) {
  //     if (isDisposed) return; //Kiểm tra trc khi emit
  //     dlog('Lỗi khi tìm kiếm Manga: $error');
  //     emit(MangaError('Lỗi: $error'));
  //   });
  // }
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
      // 'contentRating[]': 'pornographic'
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
    final limit = params['limit'] as int;
    final translateLang = params['translateLang'] as String?;
    final followedCount = params['followedCount'] as bool;

    final orderBy = followedCount ? 'followedCount' : 'latestUploadedChapter';

    final response = await DioClient.create().get(
      '${baseUrl}manga',
      queryParameters: {
        'includes[]': 'cover_art',
        'title': query,
        'order[$orderBy]': 'desc',
        'limit': limit,
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
