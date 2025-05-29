import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_log.dart';
import '../dio/dio_client.dart';
import '../models/tag_model.dart';

part 'tag_state.dart';

String baseUrl = 'https://api-manga-user.vercel.app/mangadex/';

class TagCubit extends Cubit<TagState> with NetWorkMixin {
  TagCubit() : super(TagStateInitial());

  Future<void> getTag() async {
    try {
      if (state is TagLoading) return;

      emit(TagLoading());

      final response = await callApiGet(endPoint: '${baseUrl}manga/tag');

      if (response.statusCode == 200) {
        final data = response.data?['data'] as List<dynamic>? ?? [];

        List<Tag> listTag = data
            .map<Tag>((json) => Tag.fromJson(json as Map<String, dynamic>))
            .toList();

        if (listTag.isNotEmpty) {
          emit(
            TagLoaded(
              listTag.sorted(
                (a, b) => a.attributes.name.compareTo(b.attributes.name),
              ),
            ),
          );
        } else {
          emit(const TagError("Không có tag nào!"));
        }
      } else {
        emit(TagError("Lỗi API: ${response.statusCode}"));
      }
    } catch (e, stackTrace) {
      dlog("Error: $e\nStackTrace: $stackTrace");
      emit(TagError("Lỗi: ${e.toString()}")); // Gửi lỗi rõ ràng hơn
    }
  }
}
