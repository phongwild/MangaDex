import 'tag_model.dart';

class Attributes {
  final String title;
  final List<String> altTitles;
  final String description;
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

  Attributes({
    required this.title,
    required this.altTitles,
    required this.description,
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

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      title: (json['title'] as Map<String, dynamic>?)?['en'] ?? "No title",
      altTitles: (json['altTitles'] as List<dynamic>?)
              ?.map((alt) => alt.values.first.toString())
              .toList() ??
          [],
      description: (json['description'] as Map<String, dynamic>?)?['vi'] ??
          (json['description'] as Map<String, dynamic>?)?['en'] ??
          (json['description'] as Map<String, dynamic>?)?['ja'] ??
          (json['description'] as Map<String, dynamic>?)?['ja-ro'] ??
          'No description',
      originalLanguage: json['originalLanguage'] as String? ?? "Unknown",
      status: json['status'] as String? ?? "Unknown",
      year: json['year'] as int?,
      contentRating: json['contentRating'] as String? ?? "Unknown",
      availableTranslatedLanguages:
          (json['availableTranslatedLanguages'] as List<dynamic>?)
                  ?.map((lang) => lang.toString())
                  .toList() ??
              [],
      latestUploadedChapter: json['latestUploadedChapter'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tagJson) => Tag.fromJson(tagJson))
              .toList() ??
          [],
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      lastVolume: json['lastVolume'] as String?,
      lastChapter: json['lastChapter'] as String?,
    );
  }
}
