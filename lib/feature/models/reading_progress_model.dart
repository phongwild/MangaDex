import 'package:json_annotation/json_annotation.dart';

part 'reading_progress_model.g.dart';

@JsonSerializable(includeIfNull: false)
class ReadingProgress {
  final String? mangaId;
  final String? chapterId;
  final String? chapterTitle;
  final String? chapterNumber;
  final int? page;
  final bool? completed;
  final String? updatedAt;

  @JsonKey(name: '_id')
  final String? sId;

  const ReadingProgress({
    this.mangaId,
    this.chapterId,
    this.chapterTitle,
    this.chapterNumber,
    this.page,
    this.completed,
    this.updatedAt,
    this.sId,
  });

  factory ReadingProgress.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ReadingProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingProgressToJson(this);
}
