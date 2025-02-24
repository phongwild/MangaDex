import 'package:app/core/cache/shared_prefs.dart';

class TranslateLang {
  // Singleton instance
  static final TranslateLang _instance = TranslateLang._internal();

  // Private constructor
  TranslateLang._internal();

  // Factory constructor to return the same instance
  factory TranslateLang() => _instance;

  // Language value with default as 'vi'
  String _language = 'vi';

  // Getter for language
  String get language => _language;

  // Setter to change language ('vi' or 'en' only)
  set language(String lang) {
    if (lang == 'vi' || lang == 'en') {
      _language = lang;
      // _saveLanguage(lang); // Lưu ngôn ngữ vào SharedPreferences
    } else {
      throw ArgumentError('Invalid language. Only "vi" or "en" allowed.');
    }
  }

  // Initialize language from SharedPreferences
  // Future<void> init() async {
  //   final savedLang = SharedPref.getString('language');
  //   _language = savedLang ?? 'vi';
  // }

  // // Save language to SharedPreferences
  // Future<void> _saveLanguage(String lang) async {
  //   final prefs = await SharedPref.getInstance();
  //   await prefs.putString('language', lang);
  // }
}
