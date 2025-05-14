import 'package:freezed_annotation/freezed_annotation.dart';

import 'attributes_model.dart';
import 'relationship_model.dart';

part 'manga_model.freezed.dart';
part 'manga_model.g.dart';

@freezed
class Manga with _$Manga {
  const factory Manga({
    required String id,
    required String type,
    required Attributes attributes,
    required List<Relationship> relationships,
    int? chapterCount,
  }) = _Manga;

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);
}
