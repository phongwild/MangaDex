// import 'tag_model.dart';

// class Attributes {
//   final String title;
//   final List<String> altTitles;
//   final String description;
//   final String originalLanguage;
//   final String status;
//   final int? year;
//   final String contentRating;
//   final List<String> availableTranslatedLanguages;
//   final String? latestUploadedChapter;
//   final List<Tag> tags;
//   final String? createdAt;
//   final String? updatedAt;
//   final String? lastVolume;
//   final String? lastChapter;

//   const Attributes({
//     required this.title,
//     required this.altTitles,
//     required this.description,
//     required this.originalLanguage,
//     required this.status,
//     this.year,
//     required this.contentRating,
//     required this.availableTranslatedLanguages,
//     this.latestUploadedChapter,
//     required this.tags,
//     this.createdAt,
//     this.updatedAt,
//     this.lastVolume,
//     this.lastChapter,
//   });

//   static const preferredLanguages = ['vi', 'en', 'ja', 'ja-ro', 'en', 'ko'];

//   static String getPreferredTitle(Map<String, dynamic>? titles) {
//     if (titles == null || titles.isEmpty) return 'No title';

//     for (final lang in preferredLanguages) {
//       if (titles.containsKey(lang)) return titles[lang];
//     }

//     return titles.values.first ?? 'No title';
//   }

//   factory Attributes.fromJson(Map<String, dynamic> json) {
//     return Attributes(
//       title: getPreferredTitle(json['title'] as Map<String, dynamic>?),
//       altTitles: (json['altTitles'] as List<dynamic>?)
//               ?.map((alt) => alt.values.first.toString())
//               .toList() ??
//           [],
//       description: (json['description'] as Map<String, dynamic>?)?['vi'] ??
//           (json['description'] as Map<String, dynamic>?)?['en'] ??
//           (json['description'] as Map<String, dynamic>?)?['ja'] ??
//           (json['description'] as Map<String, dynamic>?)?['ja-ro'] ??
//           'No description',
//       originalLanguage: json['originalLanguage'] as String? ?? "Unknown",
//       status: json['status'] as String? ?? "Unknown",
//       year: json['year'] as int?,
//       contentRating: json['contentRating'] as String? ?? "Unknown",
//       availableTranslatedLanguages:
//           (json['availableTranslatedLanguages'] as List<dynamic>?)
//                   ?.map((lang) => lang.toString())
//                   .toList() ??
//               [],
//       latestUploadedChapter: json['latestUploadedChapter'] as String?,
//       tags: (json['tags'] as List<dynamic>?)
//               ?.map((tagJson) => Tag.fromJson(tagJson))
//               .toList() ??
//           [],
//       createdAt: json['createdAt'] as String?,
//       updatedAt: json['updatedAt'] as String?,
//       lastVolume: json['lastVolume'] as String?,
//       lastChapter: json['lastChapter'] as String?,
//     );
//   }
// }
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

  List<String> getAltTitles() {
    if (altTitles == null) return [];

    return altTitles!
        .map((alt) => alt.values.first.toString())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      _$AttributesFromJson(json);
  Map<String, dynamic> toJson() => _$AttributesToJson(this);
}
