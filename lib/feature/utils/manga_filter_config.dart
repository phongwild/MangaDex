import 'package:app/core/app_log.dart';
import 'package:app/core/cache/shared_prefs.dart';
import 'package:flutter/foundation.dart';

class ContentRatingManager extends ChangeNotifier {
  ContentRatingManager._internal();
  static final ContentRatingManager _instance =
      ContentRatingManager._internal();

  factory ContentRatingManager() => _instance;

  static const String _key = 'content_rating';

  static const List<String> allRatings = [
    'safe',
    'suggestive',
    'erotica',
    'pornographic',
  ];

  List<String> _selected = ['safe', 'suggestive'];

  List<String> get selected => _selected;

  Future<void> init() async {
    final List<String>? raw = await SharedPref.getStringList(_key);

    if (raw == null || raw.isEmpty) {
      _selected = ['safe'];
    } else {
      _selected = List<String>.from(raw);
    }

    dlog('Content rating: $_selected');
    notifyListeners();
  }

  Future<void> toggle(String value) async {
    if (_selected.contains(value)) {
      _selected.remove(value);
    } else {
      _selected.add(value);
    }

    await SharedPref.putStringList(_key, _selected);
    notifyListeners();
  }

  Future<void> setAll(List<String> values) async {
    _selected = values;
    await SharedPref.putStringList(_key, _selected);
    notifyListeners();
  }

  bool isSelected(String value) => _selected.contains(value);
}
