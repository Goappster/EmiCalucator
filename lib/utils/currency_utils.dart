class Currency {
  final String code;
  final String symbol;
  final String name;
  final bool symbolOnLeft;
  final bool spaceBetweenAmountAndSymbol;
  final int decimalDigits;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
    this.symbolOnLeft = true,
    this.spaceBetweenAmountAndSymbol = false,
    this.decimalDigits = 2,
  });

  String format(double amount) {
    String amountStr = amount.toStringAsFixed(decimalDigits);
    if (symbolOnLeft) {
      return spaceBetweenAmountAndSymbol
          ? '$symbol $amountStr'
          : '$symbol$amountStr';
    } else {
      return spaceBetweenAmountAndSymbol
          ? '$amountStr $symbol'
          : '$amountStr$symbol';
    }
  }
}

class CurrencyService {
  static const Map<String, Currency> _currencies = {
    'INR': Currency(
      code: 'INR',
      symbol: '₹',
      name: 'Indian Rupee',
      symbolOnLeft: true,
      spaceBetweenAmountAndSymbol: false,
    ),
    'USD': Currency(
      code: 'USD',
      symbol: '\$',
      name: 'US Dollar',
      symbolOnLeft: true,
      spaceBetweenAmountAndSymbol: false,
    ),
    'EUR': Currency(
      code: 'EUR',
      symbol: '€',
      name: 'Euro',
      symbolOnLeft: false,
      spaceBetweenAmountAndSymbol: true,
    ),
    'GBP': Currency(
      code: 'GBP',
      symbol: '£',
      name: 'British Pound',
      symbolOnLeft: true,
      spaceBetweenAmountAndSymbol: false,
    ),
    'JPY': Currency(
      code: 'JPY',
      symbol: '¥',
      name: 'Japanese Yen',
      symbolOnLeft: true,
      spaceBetweenAmountAndSymbol: false,
      decimalDigits: 0,
    ),
  };

  static List<Currency> get availableCurrencies => _currencies.values.toList();
  static List<String> get currencyCodes => _currencies.keys.toList();

  static Currency getCurrency(String code) {
    return _currencies[code] ?? _currencies['USD']!;
  }
}
