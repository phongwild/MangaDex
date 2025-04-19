// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterWrapper _$ChapterWrapperFromJson(Map<String, dynamic> json) =>
    ChapterWrapper(
      id: json['id'] as String,
      type: json['type'] as String,
      attributes: Chapter.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChapterWrapperToJson(ChapterWrapper instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes.toJson(),
    };

Chapter _$ChapterFromJson(Map<String, dynamic> json) => Chapter(
      volume: json['volume'] as String?,
      chapter: json['chapter'] as String?,
      title: json['title'] as String?,
      translatedLanguage: json['translatedLanguage'] as String,
      externalUrl: json['externalUrl'] as String?,
      publishAt: DateTime.parse(json['publishAt'] as String),
      readableAt: DateTime.parse(json['readableAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      pages: (json['pages'] as num).toInt(),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'volume': instance.volume,
      'chapter': instance.chapter,
      'title': instance.title,
      'translatedLanguage': instance.translatedLanguage,
      'externalUrl': instance.externalUrl,
      'publishAt': instance.publishAt.toIso8601String(),
      'readableAt': instance.readableAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'pages': instance.pages,
      'version': instance.version,
    };
