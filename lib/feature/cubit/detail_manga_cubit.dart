import 'dart:async';
import 'dart:isolate';

import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:app/feature/models/chapter_data_model.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:app/feature/utils/translate_lang.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_manga_state.dart';

const String urlManga = 'https://api.mangadex.org/manga';
const String urlReadChapter = 'https://api.mangadex.org/at-home/server';
final translateLang = TranslateLang();

class DetailMangaCubit extends Cubit<DetailMangaState> with NetWorkMixin {
  DetailMangaCubit() : super(DetailMangaStateInitial());
  Future<void> getDetailManga(
    String idManga,
    bool isFeed, {
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      emit(DetailMangaStateLoading());

      // Gọi API lấy chi tiết manga
      final response = await callApiGet(endPoint: '$urlManga/$idManga');
      if (response.data['data'] == null) {
        throw Exception('Không tìm thấy dữ liệu manga');
      }

      final manga = Manga.fromJson(response.data['data']);

      if (!isFeed) {
        emit(DetailMangaStateLoaded(manga, const [], 0, ''));
        return;
      }

      // Gọi API lấy danh sách chương và chương đầu tiên
      final chaptersResponse = await callApiGet(
        endPoint: '$urlManga/$idManga/feed',
        json: {
          'offset': offset,
          'translatedLanguage[]': translateLang.language,
          'limit': 15,
          'order[chapter]': 'desc',
        },
      );

      final firstChapterResponse = await callApiGet(
        endPoint: '$urlManga/$idManga/feed',
        json: {
          'translatedLanguage[]': translateLang.language,
          'limit': 1,
          'order[chapter]': 'asc',
        },
      );

      final List<dynamic>? chaptersData = chaptersResponse.data['data'];
      final List<dynamic>? firstChapterData = firstChapterResponse.data['data'];

      if (chaptersData == null || firstChapterData == null) {
        throw Exception('Không tìm thấy danh sách chương');
      }

      // Chuyển đổi dữ liệu
      final chapters = chaptersData.map((e) => Chapter.fromJson(e)).toList();
      final String firstChapter =
          firstChapterData.isNotEmpty ? firstChapterData.first['id'] : '';

      final int total = chaptersResponse.data['total'] ?? 0;

      emit(DetailMangaStateLoaded(manga, chapters, total, firstChapter));
    } catch (e) {
      dlog(e.toString());
      emit(DetailMangaStateError(e.toString()));
    }
  }

  Future<void> getAllChapter(String idManga) async {
    try {
      const int batchSize = 300;
      final int totalChapter = await _getTotalChapters(idManga);

      if (totalChapter == 0) {
        emit(const DetailMangaStateError('Không tìm thấy chương nào!'));
        return;
      }

      final int batchCount = (totalChapter / batchSize).ceil();

      // Tạo danh sách các Isolate chạy song song
      List<Future<List<Chapter>>> futures = [];
      for (int i = 0; i < batchCount; i++) {
        int offset = i * batchSize;
        futures.add(_fetchChaptersInIsolate(idManga, offset, batchSize));
      }

      // Chạy tất cả batch song song
      final results = await Future.wait(futures);

      // Gộp tất cả chương lại
      final List<Chapter> allChapters = results.expand((e) => e).toList();

      // Emit state với danh sách chương
      final currentState = state;
      if (currentState is DetailMangaStateLoaded) {
        emit(currentState.copyWith(chapters: allChapters));
      }
    } catch (e) {
      dlog('Lỗi khi tải chương: $e');
      emit(const DetailMangaStateError('Không thể tải danh sách chương!'));
    }
  }

  Future<void> getReadChapter(String idChapter) async {
    try {
      emit(DetailMangaStateLoading());
      final response = await callApiGet(endPoint: '$urlReadChapter/$idChapter');
      if (response.statusCode == 200) {
        final data = ChapterData.fromJson(response.data);
        emit(ChapterStateLoaded(data));
      } else {
        emit(DetailMangaStateError('Error: ${response.statusCode}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(DetailMangaStateError('Error: $e'));
    }
  }
}

Future<int> _getTotalChapters(String idManga) async {
  try {
    final response = await DioClient.create().get(
      '$urlManga/$idManga/feed',
      queryParameters: {'limit': 1},
    );

    if (response.statusCode == 200) {
      return response.data['total'] ?? 0;
    }
  } catch (e) {
    dlog('Lỗi khi lấy tổng số chương: $e');
  }
  return 0;
}

Future<List<Chapter>> _fetchChaptersInIsolate(
    String idManga, int offset, int limit) async {
  final ReceivePort receivePort = ReceivePort();
  final Completer<List<Chapter>> completer = Completer<List<Chapter>>();

  receivePort.listen((message) {
    if (message is List<Chapter>) {
      completer.complete(message);
    } else {
      dlog('Lỗi khi nhận dữ liệu từ Isolate');
      completer.complete([]);
    }
  });

  await Isolate.spawn(
      _fetchChaptersBatch, [receivePort.sendPort, idManga, offset, limit]);

  return completer.future;
}

Future<void> _fetchChaptersBatch(List<dynamic> args) async {
  SendPort sendPort = args[0];
  String idManga = args[1];
  int offset = args[2];
  int limit = args[3];

  try {
    dlog('Current language: ${translateLang.language}');

    final response = await DioClient.create().get(
      '$urlManga/$idManga/feed',
      queryParameters: {
        'offset': offset,
        'translatedLanguage[]': translateLang.language,
        'limit': limit,
        'order[chapter]': 'desc',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic>? chaptersData = response.data['data'];
      if (chaptersData != null) {
        final chapters = chaptersData.map((e) => Chapter.fromJson(e)).toList();
        sendPort.send(chapters);
        return;
      }
    }
    sendPort.send([]); // Trả về danh sách rỗng nếu có lỗi
  } catch (e) {
    dlog('Lỗi trong Isolate: $e');
    sendPort.send([]);
  }
}
