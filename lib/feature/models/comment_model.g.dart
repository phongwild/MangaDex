// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MangaComments _$MangaCommentsFromJson(Map<String, dynamic> json) =>
    MangaComments(
      mangaId: json['mangaId'] as String,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MangaCommentsToJson(MangaComments instance) =>
    <String, dynamic>{
      'mangaId': instance.mangaId,
      'comments': instance.comments.map((e) => e.toJson()).toList(),
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      userId: const UserInfoConverter()
          .fromJson(json['userId'] as Map<String, dynamic>?),
      content: json['content'] as String,
      sId: json['_id'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Reply.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'userId': const UserInfoConverter().toJson(instance.userId),
      'content': instance.content,
      '_id': instance.sId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'replies': instance.replies.map((e) => e.toJson()).toList(),
    };

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
      userId: const UserInfoConverter()
          .fromJson(json['userId'] as Map<String, dynamic>?),
      content: json['content'] as String,
      sId: json['_id'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'userId': const UserInfoConverter().toJson(instance.userId),
      'content': instance.content,
      '_id': instance.sId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? 'N/a',
      avatar:
          json['avatar'] as String? ?? 'https://mangadex.org/img/avatar.png',
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
    };
