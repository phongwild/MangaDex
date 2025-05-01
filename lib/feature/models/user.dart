import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class User {
  @JsonKey(name: '_id')
  final String? sId;

  final String? username;
  final String? email;
  final String? avatar;
  final String? password;
  final String? createdAt;
  final String? updatedAt;

  @JsonKey(name: 'follow_list')
  final List<String>? followList;

  final List<History>? history;

  const User({
    this.sId,
    this.username,
    this.email,
    this.avatar,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.followList,
    this.history,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(includeIfNull: false)
class History {
  final String? mangaId;

  @JsonKey(name: '_id')
  final String? sId;

  final String? createdAt;

  const History({
    this.mangaId,
    this.sId,
    this.createdAt,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}
