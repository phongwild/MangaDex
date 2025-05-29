import 'dart:async';

import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:app/feature/utils/translate_lang.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/app_connection_utils.dart';
import '../models/manga_model.dart';

part 'manga_state.dart';

String baseUrl = 'https://api-manga-user.vercel.app/mangadex/';
final translateLang = TranslateLang();
final ConnectionUtils connectionUtils = ConnectionUtils();

class MangaCubit extends Cubit<MangaState> {
  MangaCubit() : super(const MangaInitial()) {
    connectionUtils.addListener(_onNetworkChanged);
  }

  bool _isWaitingForNetwork = false;
  Map<String, dynamic>? _lastFetchParams;
  bool isDisposed = false;
  Timer? _debounceTimer;

  @override
  Future<void> close() async {
    isDisposed = true;
    connectionUtils.removeListener(_onNetworkChanged);
    _debounceTimer?.cancel();
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
    _lastFetchParams = null; // Reset sau khi retry
  }

  Future<void> getManga({
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

    if (_lastFetchParams != null &&
        _lastFetchParams!['isLatestUploadedChapter'] ==
            isLatestUploadedChapter &&
        _lastFetchParams!['limit'] == limit &&
        _lastFetchParams!['offset'] == offset) {
      return;
    }

    emit(const MangaLoading());

    try {
      final result = await _fetchManga([
        isLatestUploadedChapter,
        translateLang.language,
        limit,
        offset,
      ]);

      emit(MangaLoaded(
        result['mangas'],
        total: result['total'] as int? ?? 0,
      ));
    } catch (error) {
      emit(MangaError(_formatError(error)));
    }
  }

  Future<void> searchManga(
    String query, {
    List<String>? tags,
    int? offset,
    int limit = 10,
    bool followedCount = false,
  }) async {
    if (state is MangaLoading || isDisposed) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
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
        emit(const MangaError('Không có kết nối mạng! Đợi kết nối lại.'));
        return;
      }

      if (_lastFetchParams != null &&
          _lastFetchParams!['query'] == query &&
          _lastFetchParams!['tags'] == tags &&
          _lastFetchParams!['offset'] == offset &&
          _lastFetchParams!['limit'] == limit &&
          _lastFetchParams!['followedCount'] == followedCount) {
        return;
      }

      emit(const MangaLoading());

      try {
        final result = await _fetchSearchManga({
          'query': query,
          'tags': tags ?? [],
          'offset': offset ?? 0,
          'limit': limit,
          'translateLang': translateLang.language,
          'followedCount': followedCount,
        });

        emit(MangaLoaded(
          result['mangas'] as List<Manga>,
          total: result['total'] as int? ?? 0,
        ));
      } catch (error) {
        emit(MangaError(_formatError(error)));
      }
    });
  }

  String _formatError(Object error) => 'Lỗi: ${error.toString()}';
}

Future<Map<String, dynamic>> _fetchManga(List<dynamic> param) async {
  try {
    final isLatestUploadedChapter = param[0] as bool;
    final translateLang = param[1] as String;
    final limit = param[2] as int;
    final offset = param[3] as int;

    final orderBy =
        isLatestUploadedChapter ? 'latestUploadedChapter' : 'createdAt';

    final queryParams = {
      'includes[]': ['cover_art'],
      'order[$orderBy]': 'desc',
      'limit': limit,
      'offset': offset,
      'availableTranslatedLanguage[]': translateLang,
    };

    final response = await DioClient.create().get(
      '${baseUrl}manga',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data?['data'] ?? [];
      final mangaList =
          rawData.map<Manga>((json) => Manga.fromJson(json)).toList();
      final total = response.data?['total'] ?? 0;
      return {'mangas': mangaList, 'total': total};
    } else {
      dlog('API Error: ${response.statusCode}, Data: ${response.data}');
      return {'mangas': [], 'total': 0};
    }
  } catch (e, stackTrace) {
    dlog('Fetch Manga Error: $e\n$stackTrace');
    return {'mangas': [], 'total': 0};
  }
}

Future<Map<String, dynamic>> _fetchSearchManga(
    Map<String, dynamic> params) async {
  try {
    final query = params['query'] as String;
    final tags = params['tags'] as List<String>;
    final offset = params['offset'] as int;
    final limit = params['limit'] as int;
    final translateLang = params['translateLang'] as String;
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

    if (response.statusCode == 200 && response.data != null) {
      final rawData = response.data?['data'] as List<dynamic>;
      final mangaList =
          rawData.map<Manga>((json) => Manga.fromJson(json)).toList();
      final total = response.data?['total'] ?? 0;
      return {'mangas': mangaList, 'total': total};
    } else {
      dlog('API Error: ${response.statusCode}, Data: ${response.data}');
      return {'mangas': [], 'total': 0};
    }
  } catch (e, stackTrace) {
    dlog('Search Manga Error: $e\n$stackTrace');
    return {'mangas': [], 'total': 0};
  }
}
