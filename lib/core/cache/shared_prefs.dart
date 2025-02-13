
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static Future<SharedPreferences> get _instance async =>
      _preferences ?? await SharedPreferences.getInstance();

  static SharedPref? _instanceSharedPref;
  static SharedPreferences? _preferences;

  static Future<SharedPref> getInstance() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _instanceSharedPref ??= SharedPref();
  }

  Future<bool> putBool(String key, bool value) =>
      _preferences!.setBool(key, value);

  Future<bool> putDouble(String key, double value) =>
      _preferences!.setDouble(key, value);

  double? getDouble(String key) => _preferences!.getDouble(key);

  Future<bool> putInt(String key, int value) =>
      _preferences!.setInt(key, value);

  Future<bool> putString(String key, String value) =>
      _preferences!.setString(key, value);

  Future<bool> putStringList(String key, List<String> value) =>
      _preferences!.setStringList(key, value);

  bool isKeyExists(String key) => _preferences!.containsKey(key);

  Future<bool> clearKey(String key) => _preferences!.remove(key);

  Future<bool> clearAll() => _preferences!.clear();

  static String getString(String key, [String? defValue]) {
    return _preferences!.getString(key) ?? defValue ?? "";
  }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    var prefs = await _instance;
    return prefs.setInt(key, value);
  }

  static int? getInt(String key, {int? defValue}) {
    return _preferences!.getInt(key) ?? defValue;
  }

  static Future<bool> setBool(String key, bool value) async {
    var prefs = await _instance;
    return prefs.setBool(key, value);
  }

  static bool getBool(String key, {bool? defValue}) {
    return _preferences!.getBool(key) ?? defValue ?? false;
  }

  static Future<List<String>?> getStringList(String key) async {
    var prefs = await _instance;
    return prefs.getStringList(key);
  }

  static Future setStringList(String key, List<String> value) async {
    var prefs = await _instance;
    return prefs.setStringList(key, value);
  }
}
