import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider extends ChangeNotifier {
  String _currencySymbol = '₹';

  String get currencySymbol => _currencySymbol;

  CurrencyProvider() {
    _loadCurrencySymbol();
  }

  Future<void> _loadCurrencySymbol() async {
    final prefs = await SharedPreferences.getInstance();
    _currencySymbol = prefs.getString('currency_symbol') ?? '₹';
    notifyListeners();
  }

  Future<void> setCurrencySymbol(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_symbol', symbol);
    _currencySymbol = symbol;
    notifyListeners();
  }
}
