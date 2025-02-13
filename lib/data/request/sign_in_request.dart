class SignInRequest {
  String? username;
  String? password;

  SignInRequest({
    this.username,
    this.password,
  });

  SignInRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}
