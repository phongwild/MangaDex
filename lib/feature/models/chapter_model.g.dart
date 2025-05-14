// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChapterWrapperImpl _$$ChapterWrapperImplFromJson(Map<String, dynamic> json) =>
    _$ChapterWrapperImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      attributes: Chapter.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChapterWrapperImplToJson(
        _$ChapterWrapperImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes,
    };

_$ChapterImpl _$$ChapterImplFromJson(Map<String, dynamic> json) =>
    _$ChapterImpl(
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

Map<String, dynamic> _$$ChapterImplToJson(_$ChapterImpl instance) =>
    <String, dynamic>{
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
