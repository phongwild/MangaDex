import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_model.freezed.dart';
part 'chapter_model.g.dart';

@freezed
class ChapterWrapper with _$ChapterWrapper {
  const factory ChapterWrapper({
    required String id,
    required String type,
    required Chapter attributes,
  }) = _ChapterWrapper;

  factory ChapterWrapper.fromJson(Map<String, dynamic> json) =>
      _$ChapterWrapperFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    String? volume,
    String? chapter,
    String? title,
    required String translatedLanguage,
    String? externalUrl,
    required DateTime publishAt,
    required DateTime readableAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int pages,
    required int version,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
