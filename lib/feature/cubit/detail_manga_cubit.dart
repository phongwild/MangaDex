import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:app/feature/models/chapter_data_model.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_manga_state.dart';

class DetailMangaCubit extends Cubit<DetailMangaState> with NetWorkMixin {
  DetailMangaCubit() : super(DetailMangaStateInitial());

  static const String urlManga = 'https://api.mangadex.org/manga';
  static const String urlReadChapter =
      'https://api.mangadex.org/at-home/server';

  Future<void> getDetailManga(
    String idManga,
    bool isFeed, {
    int limit = 10,
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

      if (isFeed) {
        // Nếu isFeed == true, gọi thêm API lấy danh sách chương
        final chaptersResponse = await callApiGet(
          endPoint: '$urlManga/$idManga/feed',
          json: {
            'offset': offset,
            'translatedLanguage[]': ['vi'],
            'limit': 15,
            'order[chapter]': 'desc',
          },
        );
        if (chaptersResponse.data['data'] == null) {
          throw Exception('Không tìm thấy danh sách chương');
        }

        final chapters = (chaptersResponse.data['data'] as List)
            .map((e) => Chapter.fromJson(e))
            .toList();

        final total = chaptersResponse.data['total'];

        emit(DetailMangaStateLoaded(manga, chapters, total));
      } else {
        emit(DetailMangaStateLoaded(manga, const [], 0));
      }
    } catch (e) {
      dlog(e.toString());
      emit(DetailMangaStateError(e.toString()));
    }
  }

  Future<void> getReadChapter(String idChapter) async {
    try {
      emit(DetailMangaStateLoading());
      final response = await callApiGet(endPoint: '$urlReadChapter/$idChapter');
      // dlog(response.data);
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
