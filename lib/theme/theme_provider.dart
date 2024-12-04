import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeData get themeData {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Static color definitions
  static const Color primaryColor = Color(0xFF2196F3);  // Main Blue
  static final Color primaryLightColor = primaryColor.withOpacity(0.7);
  static final Color primaryDarkColor = HSLColor.fromColor(primaryColor).withLightness(0.3).toColor();
  static final Color primaryVariant = HSLColor.fromColor(primaryColor).withSaturation(0.85).toColor();
  static const Color secondaryColor = Color(0xFF4CAF50);  // Green
  static const Color accentColor = Color(0xFFFFA726);  // Orange
  static const Color errorColor = Color(0xFFE53935);  // Red
  static const Color successColor = Color(0xFF43A047);  // Green
  static const Color warningColor = Color(0xFFFFB74D);  // Orange

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
  
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: const Color(0xFF2C2C2C),
    ),
  );

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToPrefs();
    notifyListeners();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
  }
}
