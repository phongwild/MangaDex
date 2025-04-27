import 'package:app/feature/utils/user_info_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MangaComments {
  final String mangaId;
  final List<Comment> comments;

  MangaComments({
    required this.mangaId,
    required this.comments,
  });

  factory MangaComments.fromJson(Map<String, dynamic> json) =>
      _$MangaCommentsFromJson(json);
  Map<String, dynamic> toJson() => _$MangaCommentsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Comment {
  @UserInfoConverter()
  final UserInfo userId;
  final String content;

  @JsonKey(name: '_id')
  final String sId;
  final DateTime? createdAt;

  @JsonKey(defaultValue: [])
  final List<Reply> replies;

  Comment({
    required this.userId,
    required this.content,
    required this.sId,
    this.createdAt,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

@JsonSerializable()
class Reply {
  @UserInfoConverter()
  final UserInfo userId;
  final String content;
  @JsonKey(name: '_id')
  final String sId;
  final DateTime? createdAt;

  Reply({
    required this.userId,
    required this.content,
    required this.sId,
    this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}

@JsonSerializable()
class UserInfo {
  @JsonKey(name: '_id', defaultValue: '')
  final String id;

  @JsonKey(defaultValue: 'N/a')
  final String username;

  @JsonKey(defaultValue: 'https://mangadex.org/img/avatar.png')
  final String avatar;

  UserInfo({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
