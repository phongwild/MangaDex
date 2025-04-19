import 'package:json_annotation/json_annotation.dart';
part 'chapter_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChapterWrapper {
  final String id;
  final String type;
  final Chapter attributes;

  ChapterWrapper({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory ChapterWrapper.fromJson(Map<String, dynamic> json) =>
      _$ChapterWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterWrapperToJson(this);
}

@JsonSerializable()
class Chapter {
  final String? volume;
  final String? chapter;
  final String? title;
  final String translatedLanguage;
  final String? externalUrl;
  final DateTime publishAt;
  final DateTime readableAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int pages;
  final int version;

  Chapter({
    this.volume,
    this.chapter,
    this.title,
    required this.translatedLanguage,
    this.externalUrl,
    required this.publishAt,
    required this.readableAt,
    required this.createdAt,
    required this.updatedAt,
    required this.pages,
    required this.version,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
