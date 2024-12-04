import 'package:flutter/material.dart';
import 'loan_calculator_screen.dart';

class CarLoanCalculator extends StatelessWidget {
  const CarLoanCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoanCalculatorScreen(
      loanType: 'Car Loan',
      title: 'Car Loan EMI Calculator',
      minAmount: 50000,
      maxAmount: 5000000,
      minTenure: 1,
      maxTenure: 7,
      defaultInterestRate: 9.5,
    );
  }
}
