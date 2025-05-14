// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttributesImpl _$$AttributesImplFromJson(Map<String, dynamic> json) =>
    _$AttributesImpl(
      title: json['title'] as Map<String, dynamic>?,
      altTitles: (json['altTitles'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      description: json['description'] as Map<String, dynamic>?,
      originalLanguage: json['originalLanguage'] as String,
      status: json['status'] as String,
      year: (json['year'] as num?)?.toInt(),
      contentRating: json['contentRating'] as String,
      availableTranslatedLanguages:
          (json['availableTranslatedLanguages'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      latestUploadedChapter: json['latestUploadedChapter'] as String?,
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      lastVolume: json['lastVolume'] as String?,
      lastChapter: json['lastChapter'] as String?,
    );

Map<String, dynamic> _$$AttributesImplToJson(_$AttributesImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'altTitles': instance.altTitles,
      'description': instance.description,
      'originalLanguage': instance.originalLanguage,
      'status': instance.status,
      'year': instance.year,
      'contentRating': instance.contentRating,
      'availableTranslatedLanguages': instance.availableTranslatedLanguages,
      'latestUploadedChapter': instance.latestUploadedChapter,
      'tags': instance.tags,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'lastVolume': instance.lastVolume,
      'lastChapter': instance.lastChapter,
    };
