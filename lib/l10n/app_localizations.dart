import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('ur'),
    Locale('ar'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'shareApp': 'Share App',
      'rateApp': 'Rate App',
      'about': 'About',
      'home': 'Home',
      'tools': 'Tools',
      'dashboard': 'Dashboard',
      'businessLoan': 'Business Loan',
      'mortgageLoans': 'Mortgage Loans',
      'flatVsReducing': 'Flat Vs Reducing',
      'homeLoan': 'Home Loan',
      'fixedDeposit': 'Fixed Deposit',
      'carLoan': 'Car Loan',
      'recurringDeposit': 'Recurring Deposit',
    },
    'hi': {
      // 'settings': 'सेटिंग्स',
      // 'darkMode': 'डार्क मोड',
      // 'language': 'भाषा',
      // 'shareApp': 'ऐप शेयर करें',
      // 'rateApp': 'ऐप रेट करें',
      // 'about': 'के बारे में',
      // 'home': 'होम',
      // 'tools': 'टूल्स',
      // 'dashboard': 'डैशबोर्ड',
      // 'businessLoan': 'बिजनेस लोन',
      // 'mortgageLoans': 'मॉर्टगेज लोन',
      // 'flatVsReducing': 'फ्लैट बनाम रिड्यूसिंग',
      // 'homeLoan': 'होम लोन',
      // 'fixedDeposit': 'फिक्स्ड डिपॉजिट',
      // 'carLoan': 'कार लोन',
      // 'recurringDeposit': 'रिकरिंग डिपॉजिट',
    },
    'ur': {
      // 'settings': 'ترتیبات',
      // 'darkMode': 'ڈارک موڈ',
      // 'language': 'زبان',
      // 'shareApp': 'ایپ شیئر کریں',
      // 'rateApp': 'ایپ کی درجہ بندی کریں',
      // 'about': 'کے بارے میں',
      // 'home': 'گھر',
      // 'tools': 'ٹولز',
      // 'dashboard': 'ڈیش بورڈ',
      // 'businessLoan': 'بزنس لون',
      // 'mortgageLoans': 'مارٹگیج لون',
      // 'flatVsReducing': 'فلیٹ بمقابلہ ریڈیوسنگ',
      // 'homeLoan': 'ہوم لون',
      // 'fixedDeposit': 'فکسڈ ڈپازٹ',
      // 'carLoan': 'کار لون',
      // 'recurringDeposit': 'ریکرنگ ڈپازٹ',
    },
    'ar': {
      // 'settings': 'الإعدادات',
      // 'darkMode': 'الوضع المظلم',
      // 'language': 'اللغة',
      // 'shareApp': 'مشاركة التطبيق',
      // 'rateApp': 'تقييم التطبيق',
      // 'about': 'حول',
      // 'home': 'الرئيسية',
      // 'tools': 'الأدوات',
      // 'dashboard': 'لوحة القيادة',
      // 'businessLoan': 'قرض تجاري',
      // 'mortgageLoans': 'قروض عقارية',
      // 'flatVsReducing': 'ثابت مقابل متناقص',
      // 'homeLoan': 'قرض منزل',
      // 'fixedDeposit': 'وديعة ثابتة',
      // 'carLoan': 'قرض سيارة',
      // 'recurringDeposit': 'وديعة متكررة',
    },
  };

  String get settings => _localizedValues[locale.languageCode]?['settings'] ?? 'Settings';
  String get darkMode => _localizedValues[locale.languageCode]?['darkMode'] ?? 'Dark Mode';
  String get language => _localizedValues[locale.languageCode]?['language'] ?? 'Language';
  String get shareApp => _localizedValues[locale.languageCode]?['shareApp'] ?? 'Share App';
  String get rateApp => _localizedValues[locale.languageCode]?['rateApp'] ?? 'Rate App';
  String get about => _localizedValues[locale.languageCode]?['about'] ?? 'About';
  String get home => _localizedValues[locale.languageCode]?['home'] ?? 'Home';
  String get tools => _localizedValues[locale.languageCode]?['tools'] ?? 'Tools';
  String get dashboard => _localizedValues[locale.languageCode]?['dashboard'] ?? 'Dashboard';
  String get businessLoan => _localizedValues[locale.languageCode]?['businessLoan'] ?? 'Business Loan';
  String get mortgageLoans => _localizedValues[locale.languageCode]?['mortgageLoans'] ?? 'Mortgage Loans';
  String get flatVsReducing => _localizedValues[locale.languageCode]?['flatVsReducing'] ?? 'Flat Vs Reducing';
  String get homeLoan => _localizedValues[locale.languageCode]?['homeLoan'] ?? 'Home Loan';
  String get fixedDeposit => _localizedValues[locale.languageCode]?['fixedDeposit'] ?? 'Fixed Deposit';
  String get carLoan => _localizedValues[locale.languageCode]?['carLoan'] ?? 'Car Loan';
  String get recurringDeposit => _localizedValues[locale.languageCode]?['recurringDeposit'] ?? 'Recurring Deposit';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'ur', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
