import 'package:freezed_annotation/freezed_annotation.dart';

import 'tag_model.dart';

part 'attributes_model.freezed.dart';
part 'attributes_model.g.dart';

@freezed
class Attributes with _$Attributes {
  const Attributes._(); // <-- cần thiết để dùng các getter custom bên dưới

  const factory Attributes({
    Map<String, dynamic>? title,
    List<Map<String, dynamic>>? altTitles,
    Map<String, dynamic>? description,
    required String originalLanguage,
    required String status,
    int? year,
    required String contentRating,
    required List<String> availableTranslatedLanguages,
    String? latestUploadedChapter,
    required List<Tag> tags,
    String? createdAt,
    String? updatedAt,
    String? lastVolume,
    String? lastChapter,
  }) = _Attributes;

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);

  static const preferredLanguages = ['vi', 'en', 'ja', 'ja-ro', 'ko'];

  /// Ưu tiên lấy title theo ngôn ngữ cài sẵn
  String getPreferredTitle() {
    if (title == null || title!.isEmpty) return 'No title';
    for (final lang in preferredLanguages) {
      if (title!.containsKey(lang)) return title![lang];
    }
    return title!.values.first ?? 'No title';
  }

  /// Lấy description ưu tiên theo ngôn ngữ
  String getPreferredDescription() {
    if (description == null || description!.isEmpty) return 'No description';
    for (final lang in preferredLanguages) {
      if (description!.containsKey(lang)) return description![lang];
    }
    return description!.values.first ?? 'No description';
  }

  /// Lấy alt title hợp lý nhất
  String getAltTitle() {
    if (altTitles == null || altTitles!.isEmpty) return 'No alt title';
    for (final lang in preferredLanguages) {
      for (final alt in altTitles!) {
        if (alt.containsKey(lang) && (alt[lang]?.isNotEmpty ?? false)) {
          return alt[lang]!;
        }
      }
    }
    for (final alt in altTitles!) {
      final value = alt.values.first;
      if (value.toString().isNotEmpty) return value.toString();
    }
    return 'No alt title';
  }
}
