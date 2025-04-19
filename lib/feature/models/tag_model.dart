import 'package:json_annotation/json_annotation.dart';

part 'tag_model.g.dart';

@JsonSerializable()
class Tag {
  final String id;
  @JsonKey(name: 'attributes')
  final TagAttributes attributes;

  Tag({
    required this.id,
    required this.attributes,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

@JsonSerializable()
class TagAttributes {
  @JsonKey(fromJson: _getPreferredName)
  final String name;
  final String group;

  TagAttributes({
    required this.name,
    required this.group,
  });

  factory TagAttributes.fromJson(Map<String, dynamic> json) =>
      _$TagAttributesFromJson(json);
  Map<String, dynamic> toJson() => _$TagAttributesToJson(this);

  /// Ưu tiên lấy name theo các ngôn ngữ phổ biến
  static String _getPreferredName(Map<String, dynamic>? names) {
    const preferredLanguages = ['vi', 'en', 'ja', 'ja-ro', 'ko'];
    if (names == null) return 'No name';

    for (final lang in preferredLanguages) {
      if (names.containsKey(lang)) return names[lang];
    }
    return names.values.first ?? 'No name';
  }
}
