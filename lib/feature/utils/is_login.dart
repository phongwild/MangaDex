import 'package:app/core/app_log.dart';
import 'package:app/core/cache/shared_prefs.dart';

class IsLogin {
  static final IsLogin _isLogin = IsLogin._internal();

  IsLogin._internal();

  static IsLogin getInstance() {
    return _isLogin;
  }

  bool _isLoggedIn = false;
  String? _jwt;
  String? _username;
  String? _email;
  String? _avatar;

  bool get isLoggedIn => _isLoggedIn;
  String? get jwt => _jwt;
  String? get username => _username;
  String? get email => _email;
  String? get avatar => _avatar;

  // Đăng nhập và lưu thông tin user
  Future<void> login(
      String token, String username, String email, String avatar) async {
    _isLoggedIn = true;
    _jwt = token;
    _username = username;
    _email = email;
    _avatar = avatar;

    await SharedPref.putString('jwt', token);
    await SharedPref.putString('username', username);
    await SharedPref.putString('email', email);
    await SharedPref.putString('avatar', avatar);
  }

  // Đăng xuất và xóa toàn bộ thông tin
  Future<void> logout() async {
    _isLoggedIn = false;
    _jwt = null;
    _username = null;
    _email = null;
    _avatar = null;

    await SharedPref.clearAll();
  }

  // Load trạng thái đăng nhập từ SharedPreferences
  Future<void> loadSession() async {
    _jwt = await SharedPref.getString('jwt');
    _username = await SharedPref.getString('username');
    _email = await SharedPref.getString('email');
    _avatar = await SharedPref.getString('avatar');

    _isLoggedIn = _jwt != null && _jwt!.isNotEmpty;

    // In log để kiểm tra giá trị sau khi load
    dlog("JWT Loaded: $_jwt");
    dlog("User Loaded: $_username, $_email, $_avatar");
    dlog("isLoggedIn: $_isLoggedIn");
  }

  Future<String?> getJwt() async {
    return _jwt;
  }
}
