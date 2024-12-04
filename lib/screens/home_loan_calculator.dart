import 'package:flutter/material.dart';
import 'loan_calculator_screen.dart';

class HomeLoanCalculator extends StatelessWidget {
  const HomeLoanCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoanCalculatorScreen(
      loanType: 'Home Loan',
      title: 'Home Loan EMI Calculator',
      minAmount: 100000,
      maxAmount: 20000000,
      minTenure: 5,
      maxTenure: 30,
      defaultInterestRate: 8.5,
    );
  }
}
