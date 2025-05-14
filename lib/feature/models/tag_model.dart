import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_model.freezed.dart';
part 'tag_model.g.dart';

@freezed
class Tag with _$Tag {
  const factory Tag({
    required String id,
    @JsonKey(name: 'attributes') required TagAttributes attributes,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}

@freezed
class TagAttributes with _$TagAttributes {
  const factory TagAttributes({
    @JsonKey(fromJson: getPreferredName) required String name,
    required String group,
  }) = _TagAttributes;

  factory TagAttributes.fromJson(Map<String, dynamic> json) =>
      _$TagAttributesFromJson(json);
}

String getPreferredName(Map<String, dynamic>? names) {
  const preferredLanguages = ['vi', 'en', 'ja', 'ja-ro', 'ko'];
  if (names == null) return 'No name';

  for (final lang in preferredLanguages) {
    if (names.containsKey(lang)) return names[lang];
  }
  return names.values.first ?? 'No name';
}
