// ignore_for_file: unnecessary_this

class User {
  String? sId;
  String? username;
  String? email;
  String? avatar;
  String? password;
  String? createdAt;
  String? updatedAt;
  List<String>? followList;
  List<History>? history;

  User(
      {this.sId,
      this.username,
      this.email,
      this.avatar,
      this.password,
      this.createdAt,
      this.updatedAt,
      this.followList,
      this.history});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    avatar = json['avatar'];
    password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    followList = json['follow_list'].cast<String>();
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(new History.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['follow_list'] = this.followList;
    if (this.history != null) {
      data['history'] = this.history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class History {
  String? mangaId;
  String? sId;
  String? createdAt;

  History({this.mangaId, this.sId, this.createdAt});

  History.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'];
    sId = json['_id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mangaId'] = this.mangaId;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
