import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './chart.dart';

class OutputWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  final String loanEMI;
  final String interestPayable;
  final String totalPayment;

  OutputWidget(this.dataMap, double loanEMI, double interestPayable, double totalPayment)
      : loanEMI = loanEMI.toStringAsFixed(2),
        interestPayable = interestPayable.toStringAsFixed(2),
        totalPayment = totalPayment.toStringAsFixed(2);

  TextStyle _getStyle({required double size, required Color color, FontWeight fontWeight = FontWeight.bold}) {
    return GoogleFonts.oswald(fontSize: size, fontWeight: fontWeight, color: color);
  }

  Widget _getResultBox(Size deviceSize, {required String heading, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        height: 90,
        width: deviceSize.width / 2 - 20,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(heading, style: _getStyle(size: 18, color: Colors.purple)),
            Text('₹ $value', style: _getStyle(size: 18, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getResultBox(deviceSize, heading: 'Loan EMI', value: loanEMI),
            _getResultBox(deviceSize, heading: 'Interest Payable', value: interestPayable),
            _getResultBox(deviceSize, heading: 'Total Payable Amount', value: totalPayment),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Break-up for Total Payment', style: _getStyle(size: 15, color: Colors.black)),
            Piechart(dataMap),
          ],
        ),
      ],
    );
  }
}
