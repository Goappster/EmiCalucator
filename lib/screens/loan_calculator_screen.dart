import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../utils/constants.dart';

class LoanCalculatorScreen extends StatefulWidget {
  final String loanType;
  final String title;
  final double minAmount;
  final double maxAmount;
  final double minTenure;
  final double maxTenure;
  final double defaultInterestRate;

  const LoanCalculatorScreen({
    super.key,
    required this.loanType,
    required this.title,
    this.minAmount = LoanConstants.defaultMinAmount,
    this.maxAmount = LoanConstants.defaultMaxAmount,
    this.minTenure = LoanConstants.defaultMinTenure,
    this.maxTenure = LoanConstants.defaultMaxTenure,
    this.defaultInterestRate = LoanConstants.defaultInterestRate,
  });

  @override
  _LoanCalculatorScreenState createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _loanAmountController;
  late TextEditingController _tenureController;
  late TextEditingController _interestRateController;
  double _loanAmount = 0;
  double _tenure = 0;
  double _interestRate = 0;

  @override
  void initState() {
    super.initState();
    _loanAmountController = TextEditingController();
    _tenureController = TextEditingController();
    _interestRateController = TextEditingController(text: widget.defaultInterestRate.toString());
    _interestRate = widget.defaultInterestRate;
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _tenureController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  void _calculateEMI() {
    if (_formKey.currentState!.validate()) {
      _loanAmount = double.parse(_loanAmountController.text);
      _tenure = double.parse(_tenureController.text);
      _interestRate = double.parse(_interestRateController.text);

      // Monthly interest rate
      double r = _interestRate / (12 * 100);
      // Total number of months
      double n = _tenure * 12;
      // EMI calculation formula
      double emi = _loanAmount * r * (pow((1 + r), n) / (pow((1 + r), n) - 1));
      double totalAmount = emi * n;
      double totalInterest = totalAmount - _loanAmount;

      Navigator.pushNamed(
        context,
        '/result',
        arguments: {
          'loanAmount': _loanAmount,
          'tenure': _tenure,
          'interestRate': _interestRate,
          'emi': emi,
          'totalAmount': totalAmount,
          'totalInterest': totalInterest,
          'loanType': widget.loanType,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Currency Selector
                  // Container(
                  //   margin: const EdgeInsets.only(bottom: 16.0),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey),
                  //     borderRadius: BorderRadius.circular(8.0),
                  //   ),
                  //   child: DropdownButtonHideUnderline(
                  //     child: ButtonTheme(
                  //       alignedDropdown: true,
                  //       child: DropdownButton<String>(
                  //         value: currencyProvider.currentCurrency,
                  //         isExpanded: true,
                  //         items: currencyProvider.supportedCurrencies.map((currency) {
                  //           return DropdownMenuItem<String>(
                  //             value: currency['symbol']!,
                  //             child: Row(
                  //               children: [
                  //                 Text(currency['flag']!, style: const TextStyle(fontSize: 20)),
                  //                 const SizedBox(width: 8),
                  //                 Text('${currency['name']} (${currency['symbol']})')
                  //               ],
                  //             ),
                  //           );
                  //         }).toList(),
                  //         onChanged: (String? value) {
                  //           if (value != null) {
                  //             currencyProvider.setCurrency(value);
                  //           }
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _loanAmountController,
                            decoration: InputDecoration(
                              labelText: 'Loan Amount',
                              prefixText: currencyProvider.currentCurrency,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter loan amount';
                              }
                              double amount = double.parse(value);
                              if (amount < widget.minAmount || amount > widget.maxAmount) {
                                return 'Amount should be between ${widget.minAmount} and ${widget.maxAmount}';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _tenureController,
                            decoration: const InputDecoration(
                              labelText: 'Loan Tenure (Years)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter loan tenure';
                              }
                              double tenure = double.parse(value);
                              if (tenure < widget.minTenure || tenure > widget.maxTenure) {
                                return 'Tenure should be between ${widget.minTenure} and ${widget.maxTenure} years';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _interestRateController,
                            decoration: const InputDecoration(
                              labelText: 'Interest Rate (%)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter interest rate';
                              }
                              double rate = double.parse(value);
                              if (rate <= 0 || rate > 30) {
                                return 'Interest rate should be between 0 and 30%';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _calculateEMI,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Calculate EMI',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

double pow(double x, double y) {
  return double.parse((x.toDouble() * y.toDouble()).toStringAsFixed(2));
}