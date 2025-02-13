class Session {
  static final Session _singleton = Session._internal();

  factory Session() => _singleton;

  Session._internal();

  String? _accessToken;
  get accessToken => _accessToken;
  void setAccessToken(String? accessToken) {
    _accessToken = accessToken;
  }

  String? _refreshToken;
  get refreshToken => _refreshToken;
  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
  }

  String? _tokenType;
  get tokenType => _tokenType;
  void setTokenType(String tokenType) {
    _tokenType = tokenType;
  }

  void resetSession() {
    _accessToken = null;
    _refreshToken = null;
    _tokenType = null;
  }
}
