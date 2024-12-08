import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'loan_result_screen.dart';
import '../utils/currency_utils.dart';

class AdvancedLoanCalculatorScreen extends StatefulWidget {
  const AdvancedLoanCalculatorScreen({super.key});

  @override
  _AdvancedLoanCalculatorScreenState createState() => _AdvancedLoanCalculatorScreenState();
}

class _AdvancedLoanCalculatorScreenState extends State<AdvancedLoanCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController(text: '10');
  final TextEditingController _yearsController = TextEditingController(text: '5');
  final TextEditingController _monthsController = TextEditingController(text: '0');
  final TextEditingController _originationFeeController = TextEditingController(text: '5');
  final TextEditingController _documentationFeeController = TextEditingController(text: '750');
  final TextEditingController _otherFeesController = TextEditingController();

  String _compoundingPeriod = 'Monthly';
  String _paybackPeriod = 'Monthly';
  String _selectedCurrencyCode = 'INR';

  double calculateEMI() {
    try {
      double principal = double.parse(_loanAmountController.text);
      double annualRate = double.parse(_interestRateController.text) / 100;
      int years = int.parse(_yearsController.text);
      int months = int.parse(_monthsController.text);
      
      // Calculate total months
      int totalMonths = (years * 12) + months;
      if (totalMonths <= 0) {
        throw Exception('Loan term must be greater than 0');
      }
      
      // Adjust rate based on compounding period
      double effectiveRate;
      switch (_compoundingPeriod) {
        case 'Monthly':
          effectiveRate = annualRate / 12;
          break;
        case 'Quarterly':
          effectiveRate = annualRate / 4;
          break;
        case 'Semi-Annually':
          effectiveRate = annualRate / 2;
          break;
        case 'Annually':
          effectiveRate = annualRate;
          break;
        default:
          effectiveRate = annualRate / 12;
      }
      
      // Calculate fees
      double originationFee = principal * (double.parse(_originationFeeController.text.isEmpty ? "0" : _originationFeeController.text) / 100);
      double documentationFee = double.parse(_documentationFeeController.text.isEmpty ? "0" : _documentationFeeController.text);
      double otherFees = _otherFeesController.text.isEmpty ? 0 : double.parse(_otherFeesController.text);
      
      // Add fees to principal
      double totalPrincipal = principal + originationFee + documentationFee + otherFees;
      
      // Adjust payment frequency based on payback period
      int paymentsPerYear;
      switch (_paybackPeriod) {
        case 'Monthly':
          paymentsPerYear = 12;
          break;
        case 'Quarterly':
          paymentsPerYear = 4;
          break;
        case 'Semi-Annually':
          paymentsPerYear = 2;
          break;
        case 'Annually':
          paymentsPerYear = 1;
          break;
        default:
          paymentsPerYear = 12;
      }
      
      double periodicRate = effectiveRate / paymentsPerYear;
      int totalPayments = (totalMonths * paymentsPerYear) ~/ 12;
      
      // EMI calculation formula: P * r * (1 + r)^n / ((1 + r)^n - 1)
      double emi = totalPrincipal * 
                   periodicRate * 
                   pow(1 + periodicRate, totalPayments) / 
                   (pow(1 + periodicRate, totalPayments) - 1);
      
      return emi;
    } catch (e) {
      rethrow;
    }
  }

  Map<String, double> calculateLoanDetails() {
    try {
      double principal = double.parse(_loanAmountController.text);
      double emi = calculateEMI();
      int years = int.parse(_yearsController.text);
      int months = int.parse(_monthsController.text);
      
      // Calculate payments based on payback period
      int paymentsPerYear;
      switch (_paybackPeriod) {
        case 'Monthly':
          paymentsPerYear = 12;
          break;
        case 'Quarterly':
          paymentsPerYear = 4;
          break;
        case 'Semi-Annually':
          paymentsPerYear = 2;
          break;
        case 'Annually':
          paymentsPerYear = 1;
          break;
        default:
          paymentsPerYear = 12;
      }
      
      int totalMonths = (years * 12) + months;
      int totalPayments = (totalMonths * paymentsPerYear) ~/ 12;
      double totalAmount = emi * totalPayments;
      double totalInterest = totalAmount - principal;
      
      return {
        'emi': emi,
        'totalAmount': totalAmount,
        'totalInterest': totalInterest,
        'principal': principal,
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Loan Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _loanAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Loan Amount',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter loan amount';
                        }
                        double? amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrencyCode,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                      ),
                      items: CurrencyService.currencyCodes.map((String code) {
                        Currency currency = CurrencyService.getCurrency(code);
                        return DropdownMenuItem<String>(
                          value: code,
                          child: Text('${currency.symbol} - ${currency.code}'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedCurrencyCode = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
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
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter interest rate';
                  }
                  double? rate = double.tryParse(value);
                  if (rate == null || rate <= 0 || rate > 100) {
                    return 'Interest rate must be between 0 and 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _compoundingPeriod,
                decoration: const InputDecoration(
                  labelText: 'Compound',
                  border: OutlineInputBorder(),
                ),
                items: ['Monthly', 'Quarterly', 'Semi-Annually', 'Annually']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _compoundingPeriod = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _yearsController,
                      decoration: const InputDecoration(
                        labelText: 'Years',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter years';
                        }
                        int? years = int.tryParse(value);
                        if (years == null || years < 0) {
                          return 'Years must be 0 or greater';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _monthsController,
                      decoration: const InputDecoration(
                        labelText: 'Months',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter months';
                        }
                        int? months = int.tryParse(value);
                        if (months == null || months < 0 || months > 11) {
                          return 'Months must be between 0 and 11';
                        }
                        // Check if both years and months are 0
                        int years = int.tryParse(_yearsController.text) ?? 0;
                        if (years == 0 && months == 0) {
                          return 'Total loan period must be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paybackPeriod,
                decoration: const InputDecoration(
                  labelText: 'Pay Back Period',
                  border: OutlineInputBorder(),
                ),
                items: ['Monthly', 'Quarterly', 'Semi-Annually', 'Annually']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _paybackPeriod = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _originationFeeController,
                decoration: const InputDecoration(
                  labelText: 'Origination Fee (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    double? fee = double.tryParse(value);
                    if (fee == null || fee < 0 || fee > 100) {
                      return 'Fee must be between 0 and 100%';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentationFeeController,
                decoration: const InputDecoration(
                  labelText: 'Documentation Fee',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    double? fee = double.tryParse(value);
                    if (fee == null || fee < 0) {
                      return 'Fee must be 0 or greater';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otherFeesController,
                decoration: const InputDecoration(
                  labelText: 'Other Fees',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    double? fee = double.tryParse(value);
                    if (fee == null || fee < 0) {
                      return 'Fee must be 0 or greater';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      try {
                        Map<String, double> loanDetails = calculateLoanDetails();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoanResultScreen(
                              emi: loanDetails['emi']!,
                              loanAmount: loanDetails['principal']!,
                              interestRate: double.parse(_interestRateController.text),
                              years: int.parse(_yearsController.text),
                              months: int.parse(_monthsController.text),
                              totalInterest: loanDetails['totalInterest']!,
                              totalAmount: loanDetails['totalAmount']!,
                              currencyCode: _selectedCurrencyCode,
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Calculate EMI',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
