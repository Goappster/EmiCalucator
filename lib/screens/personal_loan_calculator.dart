import 'package:flutter/material.dart';
import 'loan_calculator_screen.dart';

class PersonalLoanCalculator extends StatelessWidget {
  const PersonalLoanCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoanCalculatorScreen(
      loanType: 'Personal Loan',
      title: 'Personal Loan EMI Calculator',
      minAmount: 10000,
      maxAmount: 2000000,
      minTenure: 1,
      maxTenure: 5,
      defaultInterestRate: 12.5,
    );
  }
}
