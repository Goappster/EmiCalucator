class Currency {
  final String code;
  final String symbol;
  final String name;
  final String flag;

  Currency({
    required this.code,
    required this.symbol,
    required this.name,
    required this.flag,
  });
}

final List<Currency> availableCurrencies = [
  Currency(
    code: 'USD',
    symbol: '\$',
    name: 'US Dollar',
    flag: '🇺🇸',
  ),
  Currency(
    code: 'EUR',
    symbol: '€',
    name: 'Euro',
    flag: '🇪🇺',
  ),
  Currency(
    code: 'GBP',
    symbol: '£',
    name: 'British Pound',
    flag: '🇬🇧',
  ),
  Currency(
    code: 'INR',
    symbol: '₹',
    name: 'Indian Rupee',
    flag: '🇮🇳',
  ),
  Currency(
    code: 'JPY',
    symbol: '¥',
    name: 'Japanese Yen',
    flag: '🇯🇵',
  ),
];
