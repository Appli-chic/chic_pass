import 'package:chicpass/model/theme.dart';
import 'package:chicpass/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const int DEFAULT_THEME_LIGHT = 0;
const int DEFAULT_THEME_DARK = 1;

class ThemeProvider with ChangeNotifier {
  List<ChicTheme> _themeList = List();
  ChicTheme _theme;

  ThemeProvider() {
    _generateThemeList();
    _theme = _themeList[0];
    _loadTheme();
  }

  /// Generates the list of themes and insert it in the [_themeList].
  _generateThemeList() {
    ChicTheme _defaultLightTheme = ChicTheme(
      id: DEFAULT_THEME_LIGHT,
      backgroundColor: Color(0xFFEEF4F6),
      secondBackgroundColor: Color(0xFFFFFFFF),
      primaryColor: Color(0xFFE02020),
      textColor: Color(0xFF2D2D2D),
      secondTextColor: Color(0xFF575757),
      thirdTextColor: Color(0xFF7F7F7F),
      isLight: true,
    );

    _themeList.add(_defaultLightTheme);
  }

  /// Load the [_theme] stored in the secured storage
  _loadTheme() async {
    final storage = FlutterSecureStorage();
    String _themeString = await storage.read(key: KEY_THEME);

    if (_themeString != null) {
      // Load the theme if it exists
      _theme = _themeList
          .where((theme) => theme.id == int.parse(_themeString))
          .toList()[0];
    }

    notifyListeners();
  }

  /// Set the new theme using the [id] of the [_theme]
  setTheme(int id) {
    _theme = _themeList.where((theme) => theme.id == id).toList()[0];
    notifyListeners();
  }

  /// Set the brightness from the actual [_theme]
  Brightness getBrightness() {
    if (theme.isLight) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  /// Retrieve the background color corresponding to the [_theme]
  ChicTheme get theme => _theme;

  /// Retrieve the background color corresponding to the [_theme]
  Color get backgroundColor => _theme.backgroundColor;

  // Retrieve the second background color corresponding to the [_theme]
  Color get secondBackgroundColor => _theme.secondBackgroundColor;

  /// Retrieve the first color corresponding to the [_theme]
  Color get primaryColor => _theme.primaryColor;

  /// Retrieve the text color corresponding to the [_theme]
  Color get textColor => _theme.textColor;

  /// Retrieve the second text color corresponding to the [_theme]
  Color get secondTextColor => _theme.secondTextColor;

  /// Retrieve the third text color corresponding to the [_theme]
  Color get thirdTextColor => _theme.thirdTextColor;
}