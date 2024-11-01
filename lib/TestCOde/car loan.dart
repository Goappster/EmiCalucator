import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(CarLoanCalculator());

class CarLoanCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Loan Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanCalculatorScreen(),
    );
  }
}

class LoanCalculatorScreen extends StatefulWidget {
  @override
  _LoanCalculatorScreenState createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final TextEditingController loanAmountController = TextEditingController();
  double interestRate = 5.0; // Default interest rate
  double loanTerm = 12.0;    // Default loan term in months
  String calculationType = 'Monthly';

  @override
  void initState() {
    super.initState();
    loanAmountController.addListener(_formatLoanAmount);
  }

  @override
  void dispose() {
    loanAmountController.removeListener(_formatLoanAmount);
    loanAmountController.dispose();
    super.dispose();
  }

  void _formatLoanAmount() {
    final text = loanAmountController.text.replaceAll(',', '');
    if (text.isNotEmpty) {
      final formattedText = NumberFormat.decimalPattern('en_IN').format(int.parse(text));
      loanAmountController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
  }

  void calculateAndNavigate() {
    final loanAmount = double.tryParse(loanAmountController.text.replaceAll(',', '')) ?? 0.0;
    final annualInterestRate = interestRate;
    final loanTermMonths = loanTerm.toInt();

    // Input validation
    if (loanAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid loan amount.')));
      return;
    }

    double emi;
    if (calculationType == 'Monthly') {
      double monthlyRate = annualInterestRate / 12 / 100;
      emi = (loanAmount * monthlyRate) / (1 - pow(1 + monthlyRate, -loanTermMonths));
    } else {
      double yearlyRate = annualInterestRate / 100;
      int loanTermYears = (loanTermMonths / 12).round(); // Convert months to years
      emi = (loanAmount * yearlyRate) / (1 - pow(1 + yearlyRate, -loanTermYears));
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          loanAmount: loanAmount,
          interestRate: annualInterestRate,
          duration: loanTermMonths,
          emi: emi,
          calculationType: calculationType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Loan Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: loanAmountController,
              decoration: InputDecoration(
                labelText: 'Loan Amount',
                hintText: 'Enter loan amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Interest Rate: ${interestRate.toStringAsFixed(1)}%'),
                Slider(
                  value: interestRate,
                  min: 0.0,
                  max: 20.0,
                  divisions: 200,
                  label: interestRate.toStringAsFixed(1),
                  onChanged: (newValue) {
                    setState(() {
                      interestRate = newValue;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loan Term: ${loanTerm.toInt()}'),
                Slider(
                  value: loanTerm,
                  min: 1,
                  max: 240,
                  divisions: 239,
                  label: loanTerm.toInt().toString(),
                  onChanged: (newValue) {
                    setState(() {
                      loanTerm = newValue;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: calculationType,
              onChanged: (String? newValue) {
                setState(() {
                  calculationType = newValue!;
                });
              },
              items: <String>['Monthly', 'Yearly'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateAndNavigate,
              child: Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final double loanAmount;
  final double interestRate;
  final int duration;
  final double emi;
  final String calculationType;

  ResultScreen({
    required this.loanAmount,
    required this.interestRate,
    required this.duration,
    required this.emi,
    required this.calculationType,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> repaymentSchedule = [];

    if (widget.calculationType == 'Monthly') {
      repaymentSchedule = List.generate(widget.duration, (index) {
        return 'Month ${index + 1}: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(widget.emi)}';
      });
    } else {
      int loanTermYears = (widget.duration / 12).round();
      for (int i = 0; i < loanTermYears; i++) {
        repaymentSchedule.add('Year ${i + 1}: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(widget.emi)}');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Calculation Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loan Amount: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(widget.loanAmount)}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Interest Rate: ${widget.interestRate.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Duration: ${widget.duration} months',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.calculationType == 'Monthly'
                  ? 'Monthly EMI: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(widget.emi)}'
                  : 'Yearly EMI: ${NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(widget.emi)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Repayment Schedule (${widget.calculationType}):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              height: 400,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PieChart(
                    PieChartData(
                      sections: _createAnimatedSections(),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createAnimatedSections() {
    // Calculate total payment and total interest
    double totalPayment = widget.emi * widget.duration;
    double totalInterest = totalPayment - widget.loanAmount;

    // Calculate the principal payment
    double principalPayment = widget.loanAmount;

    // Values for the pie chart
    final sectionValues = [
      principalPayment, // Principal Amount
      totalInterest,    // Total Interest Paid
    ];

    return List.generate(sectionValues.length, (index) {
      final double animatedValue = sectionValues[index] * _animation.value;
      final radius = 50.0;

      return PieChartSectionData(
        color: index == 0 ? Colors.blue : Colors.red,
        value: animatedValue,
        title: '${(animatedValue).toInt()}',
        radius: radius,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}