import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // ------------------- PUT -------------------
  static Future<bool> putString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> putBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> putInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  static Future<bool> putDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(key, value);
  }

  static Future<bool> putStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  // ------------------- GET -------------------
  static Future<String> getString(String key, {String defValue = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defValue;
  }

  static Future<bool> getBool(String key, {bool defValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defValue;
  }

  static Future<int> getInt(String key, {int defValue = 0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? defValue;
  }

  static Future<double> getDouble(String key, {double defValue = 0.0}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? defValue;
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // ------------------- OTHER -------------------
  static Future<bool> isKeyExists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  static Future<bool> clearKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    bool success = await prefs.clear();
    _preferences = await SharedPreferences.getInstance(); // Reset lại
    return success;
  }
}
