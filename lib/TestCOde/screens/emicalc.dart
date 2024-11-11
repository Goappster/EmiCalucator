import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/textbox.dart';
import '../widgets/output.dart';
import '../widgets/slider.dart';
import 'dart:math';

class EMICalcWidget extends StatefulWidget {
  @override
  _EMICalcWidgetState createState() => _EMICalcWidgetState();
}

class _EMICalcWidgetState extends State<EMICalcWidget> {
  final TextEditingController tcAmount = TextEditingController();
  final TextEditingController tcROI = TextEditingController();
  double loanEMI = 0;
  double _years = 0;
  double interestPayable = 0;
  double totalPayment = 0;
  Map<String, double> dataMap = {"Principal Loan Amount": 0, "Total Interest": 0};

  _setSliderValue(double years) {
    setState(() {
      _years = years;
    });
  }

  _calEMI({required double principalAmount, required double roi, required double years}) {
    double monthlyInterestRate = roi / (12 * 100);
    double months = years * 12;

    loanEMI = monthlyInterestRate > 0
        ? (principalAmount * monthlyInterestRate * pow(1 + monthlyInterestRate, months)) /
        (pow(1 + monthlyInterestRate, months) - 1)
        : principalAmount / months;

    totalPayment = loanEMI * months;
    interestPayable = totalPayment - principalAmount;
    dataMap = {
      "Principal Loan Amount": principalAmount,
      "Total Interest": interestPayable,
    };
  }

  TextStyle _getTextStyle() {
    return GoogleFonts.oswald(fontSize: 25, color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('EMI Calculator', style: _getTextStyle())),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextBox(label: 'Enter Loan Amount', helpertext: 'Enter Amount in Rupees', tc: tcAmount, icon: Icons.money),
                TextBox(label: 'Enter ROI', helpertext: 'Enter Percentage', tc: tcROI, icon: Icons.percent),
                MySlider(_setSliderValue, _years),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(textStyle: _getTextStyle(), padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
                  onPressed: () {
                    if (tcAmount.text.isNotEmpty && tcROI.text.isNotEmpty && _years > 0) {
                      setState(() {
                        _calEMI(
                          principalAmount: double.parse(tcAmount.text),
                          roi: double.parse(tcROI.text),
                          years: _years,
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields with valid values.')));
                    }
                  },
                  child: Text('CALCULATE'),
                ),
                OutputWidget(dataMap, loanEMI, interestPayable, totalPayment),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
