import 'package:json_annotation/json_annotation.dart';
import 'attributes_model.dart';
import 'relationship_model.dart';

part 'manga_model.g.dart'; // Thêm dòng này để build phần toJson

@JsonSerializable(explicitToJson: true)
class Manga {
  final String id;
  final String type;
  final Attributes attributes;
  final List<Relationship> relationships;
  late int? chapterCount;

  Manga({
    required this.id,
    required this.type,
    required this.attributes,
    required this.relationships,
    this.chapterCount,
  });

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);

  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
