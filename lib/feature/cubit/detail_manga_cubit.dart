import 'dart:async';

import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:app/feature/models/chapter_data_model.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:app/feature/utils/translate_lang.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_manga_state.dart';

const String urlManga = 'https://api-manga-user.vercel.app/mangadex/manga';
const String urlReadChapter =
    'https://api-manga-user.vercel.app/mangadex/at-home/server';

class DetailMangaCubit extends Cubit<DetailMangaState> with NetWorkMixin {
  DetailMangaCubit() : super(DetailMangaStateInitial());

  final List<ChapterWrapper> _chapters = [];

  int _offset = 0;

  final int _limit = 20;

  bool _isLoadingMore = false;

  bool _hasMore = true;

  Future<void> getDetailManga(
    String idManga,
    bool isFeed, {
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      emit(DetailMangaStateLoading());

      final response = await callApiGet(
        endPoint: '$urlManga/$idManga',
      );

      if (response.data['data'] == null) {
        throw Exception('Không tìm thấy dữ liệu manga');
      }

      final manga = Manga.fromJson(
        response.data['data'],
      );

      if (!isFeed) {
        emit(
          DetailMangaStateLoaded(
            manga,
            const [],
            0,
            '',
          ),
        );

        return;
      }

      _offset = 0;
      _chapters.clear();
      _hasMore = true;

      final chaptersResponse = await DioClient.create().get(
        '$urlManga/$idManga/feed',
        queryParameters: {
          'offset': _offset,
          'translatedLanguage[]': TranslateLang().language,
          'limit': _limit,
          'order[chapter]': 'desc',
        },
      );

      final firstChapterResponse = await DioClient.create().get(
        '$urlManga/$idManga/feed',
        queryParameters: {
          'translatedLanguage[]': TranslateLang().language,
          'limit': 1,
          'order[chapter]': 'asc',
        },
      );

      final List<dynamic> chaptersData = chaptersResponse.data['data'] ?? [];

      final List<dynamic> firstChapterData =
          firstChapterResponse.data['data'] ?? [];

      final chapters = chaptersData
          .map(
            (e) => ChapterWrapper.fromJson(e),
          )
          .toList();

      _chapters.addAll(chapters);

      _offset += chapters.length;

      final total = chaptersResponse.data['total'] ?? 0;

      final String firstChapter =
          firstChapterData.isNotEmpty ? firstChapterData.first['id'] : '';

      emit(
        DetailMangaStateLoaded(
          manga,
          List.from(_chapters),
          total,
          firstChapter,
        ),
      );
    } catch (e) {
      dlog(e.toString());

      emit(
        DetailMangaStateError(
          e.toString(),
        ),
      );
    }
  }

  Future<void> loadMoreChapters(
    String idManga,
  ) async {
    try {
      if (_isLoadingMore || !_hasMore) {
        return;
      }

      final currentState = state;

      if (currentState is! DetailMangaStateLoaded) {
        return;
      }

      _isLoadingMore = true;

      final response = await DioClient.create().get(
        '$urlManga/$idManga/feed',
        queryParameters: {
          'offset': _offset,
          'translatedLanguage[]': TranslateLang().language,
          'limit': _limit,
          'order[chapter]': 'desc',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];

        final newChapters = data
            .map(
              (e) => ChapterWrapper.fromJson(e),
            )
            .toList();

        if (newChapters.isEmpty) {
          _hasMore = false;
        } else {
          _chapters.addAll(newChapters);

          _offset += newChapters.length;

          emit(
            currentState.copyWith(
              chapters: List.from(_chapters),
            ),
          );
        }
      }

      _isLoadingMore = false;
    } catch (e) {
      _isLoadingMore = false;

      dlog('Load more error: $e');
    }
  }

  Future<void> preloadMoreIfNeeded(
    String mangaId,
    String currentChapterId,
  ) async {
    final currentIndex = _chapters.indexWhere(
      (e) => e.id == currentChapterId,
    );

    if (currentIndex == -1) {
      return;
    }

    if (currentIndex >= _chapters.length - 5) {
      await loadMoreChapters(mangaId);
    }
  }

  ChapterWrapper? getNextChapter(
    String currentChapterId,
  ) {
    final currentIndex = _chapters.indexWhere(
      (e) => e.id == currentChapterId,
    );

    if (currentIndex == -1) {
      return null;
    }

    if (currentIndex + 1 >= _chapters.length) {
      return null;
    }

    return _chapters[currentIndex + 1];
  }

  ChapterWrapper? getPreviousChapter(
    String currentChapterId,
  ) {
    final currentIndex = _chapters.indexWhere(
      (e) => e.id == currentChapterId,
    );

    if (currentIndex <= 0) {
      return null;
    }

    return _chapters[currentIndex - 1];
  }

  Future<void> getReadChapter(
    String idChapter,
  ) async {
    try {
      emit(DetailMangaStateLoading());

      final response = await callApiGet(
        endPoint: '$urlReadChapter/$idChapter',
      );

      if (response.statusCode == 200) {
        final data = ChapterData.fromJson(
          response.data,
        );

        emit(
          ChapterStateLoaded(data),
        );
      } else {
        emit(
          DetailMangaStateError(
            'Error: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      dlog('Error: $e');

      emit(
        DetailMangaStateError(
          'Error: $e',
        ),
      );
    }
  }

  Future<void> getAllChapter(String idManga) async {
    try {
      const int batchSize = 100;

      final currentState = state;

      if (currentState is! DetailMangaStateLoaded) return;

      final totalChapter = currentState.total;

      List<ChapterWrapper> allChapters = [];

      for (int offset = currentState.chapters.length;
          offset < totalChapter;
          offset += batchSize) {
        final response = await callApiGet(
          endPoint: '$urlManga/$idManga/feed',
          json: {
            'offset': offset,
            'translatedLanguage[]': TranslateLang().language,
            'limit': batchSize,
            'order[chapter]': 'desc',
          },
        );

        final List<dynamic>? chaptersData = response.data['data'];

        if (chaptersData != null) {
          allChapters.addAll(
            chaptersData.map(
              (e) => ChapterWrapper.fromJson(e),
            ),
          );
        }
      }

      emit(
        currentState.copyWith(
          chapters: [
            ...currentState.chapters,
            ...allChapters,
          ],
        ),
      );
    } catch (e) {
      dlog('Lỗi khi tải full chapters: $e');
    }
  }
}
