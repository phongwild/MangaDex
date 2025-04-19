// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as String,
      attributes:
          TagAttributes.fromJson(json['attributes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'attributes': instance.attributes,
    };

TagAttributes _$TagAttributesFromJson(Map<String, dynamic> json) =>
    TagAttributes(
      name: TagAttributes._getPreferredName(
          json['name'] as Map<String, dynamic>?),
      group: json['group'] as String,
    );

Map<String, dynamic> _$TagAttributesToJson(TagAttributes instance) =>
    <String, dynamic>{
      'name': instance.name,
      'group': instance.group,
    };
