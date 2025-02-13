class SignInModel {
  String? accessToken;
  String? refreshToken;
  int? expiresIn;
  String? tokenType;
  String? scope;
  bool? isFirstLogin;

  SignInModel(
      {this.accessToken,
      this.refreshToken,
      this.expiresIn,
      this.tokenType,
      this.scope,
      this.isFirstLogin});

  SignInModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
    isFirstLogin = json['is_first_login'];
  }

}
