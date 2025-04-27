import 'package:json_annotation/json_annotation.dart';

import '../models/comment_model.dart';

class UserInfoConverter
    implements JsonConverter<UserInfo, Map<String, dynamic>?> {
  const UserInfoConverter();

  @override
  UserInfo fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserInfo(id: '', username: '', avatar: '');
    }
    return UserInfo(
      id: json['_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson(UserInfo userInfo) => {
        '_id': userInfo.id,
        'username': userInfo.username,
        'avatar': userInfo.avatar,
      };
}
