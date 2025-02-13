enum TypeTheme { light, dark }

class AppTheme {
  static final AppTheme _singleton = AppTheme._internal();
  factory AppTheme() => _singleton;
  AppTheme._internal();

  TypeTheme _type = TypeTheme.light;
  TypeTheme get type => _type;
  void changeTheme(TypeTheme value) {
    _type = value;
  }

  bool isDarkMode() {
    return _type == TypeTheme.dark;
  }

  bool isLightMode() {
    return _type == TypeTheme.light;
  }
}
