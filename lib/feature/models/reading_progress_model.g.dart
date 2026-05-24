// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    ReadingProgress(
      mangaId: json['mangaId'] as String?,
      chapterId: json['chapterId'] as String?,
      chapterTitle: json['chapterTitle'] as String?,
      chapterNumber: json['chapterNumber'] as String?,
      page: (json['page'] as num?)?.toInt(),
      completed: json['completed'] as bool?,
      updatedAt: json['updatedAt'] as String?,
      sId: json['_id'] as String?,
    );

Map<String, dynamic> _$ReadingProgressToJson(ReadingProgress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mangaId', instance.mangaId);
  writeNotNull('chapterId', instance.chapterId);
  writeNotNull('chapterTitle', instance.chapterTitle);
  writeNotNull('chapterNumber', instance.chapterNumber);
  writeNotNull('page', instance.page);
  writeNotNull('completed', instance.completed);
  writeNotNull('updatedAt', instance.updatedAt);
  writeNotNull('_id', instance.sId);
  return val;
}
