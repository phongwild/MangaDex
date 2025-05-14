import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_model.freezed.dart';
part 'relationship_model.g.dart';

@freezed
class Relationship with _$Relationship {
  const factory Relationship({
    String? id,
    String? type,
    Attribute? attributes,
  }) = _Relationship;

  factory Relationship.fromJson(Map<String, dynamic> json) =>
      _$RelationshipFromJson(json);
}

@freezed
class Attribute with _$Attribute {
  const factory Attribute({
    String? description,
    String? volume,
    String? fileName,
    String? locale,
    String? createdAt,
    String? updatedAt,
    int? version,
  }) = _Attribute;

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);
}
