import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  String _currentCurrency = '₹'; // Default currency symbol
  final List<Map<String, String>> _supportedCurrencies = [
    {'symbol': '₹', 'name': 'Indian Rupee', 'code': 'INR', 'flag': '🇮🇳'},
    {'symbol': '\$', 'name': 'US Dollar', 'code': 'USD', 'flag': '🇺🇸'},
    {'symbol': '€', 'name': 'Euro', 'code': 'EUR', 'flag': '🇪🇺'},
    {'symbol': '£', 'name': 'British Pound', 'code': 'GBP', 'flag': '🇬🇧'},
    {'symbol': '¥', 'name': 'Japanese Yen', 'code': 'JPY', 'flag': '🇯🇵'},
  ];

  String get currentCurrency => _currentCurrency;
  String get currencySymbol => _currentCurrency;
  List<Map<String, String>> get supportedCurrencies => _supportedCurrencies;

  Map<String, String> get currentCurrencyData => _supportedCurrencies.firstWhere(
    (currency) => currency['symbol'] == _currentCurrency,
    orElse: () => _supportedCurrencies.first,
  );

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currentCurrency = prefs.getString('currency') ?? '₹';
    notifyListeners();
  }

  Future<void> setCurrency(String symbol) async {
    _currentCurrency = symbol;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', symbol);
    notifyListeners();
  }
}
