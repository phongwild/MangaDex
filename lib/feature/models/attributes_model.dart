import 'package:json_annotation/json_annotation.dart';
import 'tag_model.dart';

part 'attributes_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Attributes {
  final Map<String, dynamic>? title;
  final List<Map<String, dynamic>>? altTitles;
  final Map<String, dynamic>? description;
  final String originalLanguage;
  final String status;
  final int? year;
  final String contentRating;
  final List<String> availableTranslatedLanguages;
  final String? latestUploadedChapter;
  final List<Tag> tags;
  final String? createdAt;
  final String? updatedAt;
  final String? lastVolume;
  final String? lastChapter;

  const Attributes({
    this.title,
    this.altTitles,
    this.description,
    required this.originalLanguage,
    required this.status,
    this.year,
    required this.contentRating,
    required this.availableTranslatedLanguages,
    this.latestUploadedChapter,
    required this.tags,
    this.createdAt,
    this.updatedAt,
    this.lastVolume,
    this.lastChapter,
  });

  static const preferredLanguages = ['vi', 'en', 'ja', 'ja-ro', 'en', 'ko'];

  String getPreferredTitle() {
    if (title == null || title!.isEmpty) return 'No title';

    for (final lang in preferredLanguages) {
      if (title!.containsKey(lang)) return title![lang];
    }

    return title!.values.first ?? 'No title';
  }

  String getPreferredDescription() {
    if (description == null || description!.isEmpty) return 'No description';

    for (final lang in preferredLanguages) {
      if (description!.containsKey(lang)) return description![lang];
    }

    return description!.values.first ?? 'No description';
  }

  String getAltTitle() {
    if (altTitles == null || altTitles!.isEmpty) return 'No alt title';

    for (final lang in preferredLanguages) {
      for (final alt in altTitles!) {
        if (alt.containsKey(lang) && (alt[lang]?.isNotEmpty ?? false)) {
          return alt[lang]!;
        }
      }
    }

    // Fallback: trả về cái đầu tiên có nội dung
    for (final alt in altTitles!) {
      final value = alt.values.first;
      if (value.toString().isNotEmpty) return value.toString();
    }

    return 'No alt title';
  }

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
