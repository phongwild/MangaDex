import 'attributes_model.dart';
import 'relationship_model.dart';

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

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] as String,
      type: json['type'] as String,
      attributes: Attributes.fromJson(json['attributes']),
      relationships: (json['relationships'] as List<dynamic>?)
              ?.map((relJson) => Relationship.fromJson(relJson))
              .toList() ??
          [],
        
    );
  }
}
