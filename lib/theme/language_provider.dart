import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');

  LanguageProvider() {
    _loadLanguage();
  }

  Locale get currentLocale => _currentLocale;

  final Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'हिंदी',
    'ur': 'اردو',
    'ar': 'العربية',
  };

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString(_languageKey) ?? 'en';
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (supportedLanguages.containsKey(languageCode)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }
}
