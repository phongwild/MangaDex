import 'package:json_annotation/json_annotation.dart';

part 'relationship_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Relationship {
  final String? id;
  final String? type;
  final Attribute? attributes;

  Relationship({this.id, this.type, this.attributes});

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipToJson(this);
}

@JsonSerializable()
class Attribute {
  final String? description;
  final String? volume;
  final String? fileName;
  final String? locale;
  final String? createdAt;
  final String? updatedAt;
  final int? version;

  Attribute({
    this.description,
    this.volume,
    this.fileName,
    this.locale,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeToJson(this);
}
