import 'package:app/core/app_log.dart';
import 'package:app/core/cache/shared_prefs.dart';
import 'package:flutter/foundation.dart';

class TranslateLang extends ChangeNotifier {
  TranslateLang._internal();

  static final TranslateLang _instance = TranslateLang._internal();

  factory TranslateLang() => _instance;

  static const String _languageKey = 'language';

  static const List<Map<String, String>> languages = [
    {
      'name': 'Tiếng Việt',
      'emoji': '🇻🇳',
      'value': 'vi',
    },
    {
      'name': 'English',
      'emoji': '🇺🇸',
      'value': 'en',
    },
    {
      'name': '日本語',
      'emoji': '🇯🇵',
      'value': 'ja',
    },
    {
      'name': '한국어',
      'emoji': '🇰🇷',
      'value': 'ko',
    },
    {
      'name': '中文',
      'emoji': '🇨🇳',
      'value': 'zh',
    },
  ];

  String _language = 'vi';

  String get language => _language;

  Future<void> init() async {
    _language = await SharedPref.getString(
      _languageKey,
    );

    if (_language.isEmpty) {
      _language = 'vi';
    }

    dlog("Lang: $_language");
  }

  Future<void> changeLanguage(
    String lang,
  ) async {
    debugPrint('START CHANGE');

    final isValid = languages.any(
      (e) => e['value'] == lang,
    );

    if (!isValid) return;

    _language = lang;

    debugPrint('SAVE: $lang');

    await SharedPref.putString(
      _languageKey,
      lang,
    );

    final test = await SharedPref.getString(
      _languageKey,
    );

    debugPrint('READ AFTER SAVE: $test');

    notifyListeners();
  }

  Map<String, String> get currentLanguage {
    return languages.firstWhere(
      (e) => e['value'] == _language,
      orElse: () => languages.first,
    );
  }

  bool isCurrentLanguage(String lang) {
    return _language == lang;
  }
}
