// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      sId: json['_id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      password: json['password'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      followList: (json['follow_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => History.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.sId);
  writeNotNull('username', instance.username);
  writeNotNull('email', instance.email);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('password', instance.password);
  writeNotNull('createdAt', instance.createdAt);
  writeNotNull('updatedAt', instance.updatedAt);
  writeNotNull('follow_list', instance.followList);
  writeNotNull('history', instance.history);
  return val;
}

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      mangaId: json['mangaId'] as String?,
      sId: json['_id'] as String?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$HistoryToJson(History instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mangaId', instance.mangaId);
  writeNotNull('_id', instance.sId);
  writeNotNull('createdAt', instance.createdAt);
  return val;
}
