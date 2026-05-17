import 'package:app/core/app_log.dart';
import 'package:app/core/cache/shared_prefs.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/app_connection_utils.dart';
import '../utils/translate_lang.dart';

part 'user_state.dart';

const String baseUrl = 'https://api-manga-user.vercel.app';
const String mangaDexApi = 'https://api-manga-user.vercel.app/mangadex';
final translateLang = TranslateLang();
final ConnectionUtils connectionUtils = ConnectionUtils();

class UserCubit extends Cubit<UserState> with NetWorkMixin {
  UserCubit() : super(UserInitial());

  Future<bool> checkListFollowManga(String mangaId) async {
    try {
      final uid = await SharedPref.getString('uid');

      final response = await callApiGet(
          endPoint: '$baseUrl/follow/check/$uid?mangaId=$mangaId');

      if (response.statusCode == 200) {
        final data = response.data;
        final isFollowing = data['isFollowing'] ?? false;
        emit(CheckFollowManga(isFollowing));
        return isFollowing;
      } else {
        dlog('❌ API error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      dlog('Exception: $e');
      emit(UserError('Lỗi: $e'));
      return false;
    }
  }

  Future<void> listFollowManga({int offset = 0, int limit = 10}) async {
    // if (state is ListFollowMangaLoaded) return;
    try {
      emit(UserLoading());

      String uid = await SharedPref.getString('uid');
      final response = await callApiGet(
        endPoint: '$baseUrl/follow/$uid',
        json: {
          'offset': offset,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> listIdManga = response.data['data'];
        final total = response.data['total'];
        final currentPage = response.data['currentPage'];
        final totalPages = response.data['totalPages'];

        if (listIdManga.isEmpty) {
          emit(const ListFollowMangaLoaded([], 0, 0, 0));
          return;
        }

        // 🔥 Chạy xử lý trên Isolate
        List<Manga> listManga =
            await compute(fetchMangaList, listIdManga.toList());

        emit(ListFollowMangaLoaded(listManga, total, totalPages, currentPage));
      } else {
        emit(const UserError('Lỗi khi lấy danh sách manga'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(UserError('Lỗi: $e'));
    }
  }

  Future<void> followManga(String idManga) async {
    try {
      String uid = await SharedPref.getString('uid');
      final response = await callApiPost(
        '$baseUrl/follow/add/$uid',
        {'mangaId': idManga},
      );

      if (response.statusCode == 200) {
        final bool alreadyFollowed = response.data['alreadyFollowed'] ?? false;

        if (alreadyFollowed) {
          emit(AlreadyFollowedManga());
        } else {
          emit(FollowMangaSuccess());
        }
      } else {
        emit(UserError(
            'Lỗi: ${response.statusCode} - ${response.data['message'] ?? 'Không rõ lỗi'}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(UserError('Lỗi: $e'));
    }
  }

  Future<void> unFollowManga(String idManga) async {
    try {
      String uid = await SharedPref.getString('uid');
      final response = await callApiPost(
        '$baseUrl/follow/remove/$uid',
        {'mangaId': idManga},
      );
      if (response.statusCode == 200) {
        final bool alreadyRemoved = response.data['alreadyRemoved'] ?? false;
        if (alreadyRemoved) {
          emit(AlreadyRemovedManga());
        } else {
          emit(UnFollowMangaSuccess());
        }
      } else {
        emit(UserError(
            'Lỗi: ${response.statusCode} - ${response.data['message'] ?? 'Không rõ lỗi'}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(UserError('Lỗi: $e'));
    }
  }

  Future<void> addToHistory(String idManga) async {
    try {
      String uid = await SharedPref.getString('uid');
      final response = await callApiPost(
        '$baseUrl/history/add/$uid',
        {'mangaId': idManga},
      );
      if (response.statusCode == 200) {
        bool alreadyExists = response.data['alreadyExists'] ?? false;
        if (alreadyExists) {
          dlog('False: ${response.data['message']}');
        } else {
          dlog('Success: ${response.data['message']}');
        }
      }
    } catch (e) {
      dlog('Error: $e');
      emit(UserError('Lỗi: $e'));
    }
  }

  Future<void> listHistory({int offset = 0, int limit = 10}) async {
    // if (state is ListHistoryMangaLoaded) return;
    try {
      emit(UserLoading());
      String uid = await SharedPref.getString('uid');
      final historyResponse = await callApiGet(
        endPoint: '$baseUrl/history/$uid',
        json: {
          'offset': offset,
          'limit': limit,
        },
      );

      if (historyResponse.statusCode == 200) {
        List<dynamic> rawData = historyResponse.data['data'];
        List<String> listIdManga =
            rawData.map((e) => e['mangaId'].toString()).toList();

        if (listIdManga.isEmpty) {
          emit(const ListHistoryMangaLoaded([], 0, 0, 0));
          return;
        }

        // 🔥 Chạy xử lý trên Isolate
        List<Manga> listManga =
            await compute(fetchMangaList, listIdManga.toList());

        // Emit state sau khi fetch thành công
        emit(ListHistoryMangaLoaded(
          listManga,
          historyResponse.data['total'],
          historyResponse.data['totalPages'],
          historyResponse.data['currentPage'],
        ));
      } else {
        emit(UserError('Lỗi API: ${historyResponse.statusCode}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(UserError('Lỗi: $e'));
    }
  }

  //ClearHistory
  Future<void> clearHistory() async {
    try {
      emit(ClearHistoryLoading());
      String uid = await SharedPref.getString('uid');
      final response = await callApiDelete('$baseUrl/history/clear/$uid');
      if (response.statusCode == 200) {
        final removed = response.data['removed'];
        final remaining = response.data['remaining'];
        final message = response.data['message'];
        dlog('Removed: $removed \n Remaining: $remaining \n Message: $message');
        emit(ClearHistoryMangaSuccess(removed, remaining, message));
      } else {
        emit(UserError('Lỗi API: ${response.statusCode}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(UserError('Lỗi: $e'));
    }
  }
}

// ⚡️ Hàm chạy trên Isolate để tải danh sách Manga từ API
Future<List<Manga>> fetchMangaList(List<dynamic> listIdManga) async {
  List<Manga> listManga = [];

  for (String idManga in listIdManga) {
    final mangaResponse = await DioClient.create().get(
      '$mangaDexApi/manga/$idManga',
      queryParameters: {
        'includes[]': 'cover_art',
        'availableTranslatedLanguage[]': translateLang.language,
        'order[latestUploadedChapter]': 'desc'
      },
    );

    if (mangaResponse.statusCode == 200) {
      listManga.add(Manga.fromJson(mangaResponse.data['data']));
    }
  }

  return listManga;
}
