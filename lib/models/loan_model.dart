import 'dart:math' as math;

class LoanModel {
  final double loanAmount;
  final double tenure;
  final double interestRate;
  final String loanType;

  LoanModel({
    required this.loanAmount,
    required this.tenure,
    required this.interestRate,
    required this.loanType,
  });

  double calculateEMI() {
    double r = interestRate / (12 * 100);
    double n = tenure * 12;
    double emi = (loanAmount * r * math.pow((1 + r), n)) / (math.pow((1 + r), n) - 1);
    return emi;
  }

  double calculateTotalAmount() {
    return calculateEMI() * tenure * 12;
  }

  double calculateTotalInterest() {
    return calculateTotalAmount() - loanAmount;
  }
}

double pow(double x, double y) {
  return double.parse((math.pow(x, y)).toStringAsFixed(2));
}
