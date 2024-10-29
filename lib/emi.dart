import 'package:flutter/material.dart';
import 'dart:math';

import 'TestCOde/dashbord.dart';

void main() {
  runApp(EMICalculator());
}

class EMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanTypeSelection(),
    );
  }
}

class LoanTypeSelection extends StatelessWidget {
  final List<String> loanTypes = [
    'Home Loan',
    'Car Loan',
    'Personal Loan',
    'Education Loan',
  ];

  final List<IconData> loanIcons = [
    Icons.house,
    Icons.directions_car,
    Icons.person,
    Icons.school,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Loan Type'),
      ),
      drawer: AppDrawer(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: loanTypes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EMIHomePage(loanType: loanTypes[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(loanIcons[index], size: 60),
                  const SizedBox(height: 10),
                  Text(
                    loanTypes[index],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



class EMIHomePage extends StatefulWidget {
  final String loanType;

  EMIHomePage({required this.loanType});

  @override
  _EMIHomePageState createState() => _EMIHomePageState();
}

class _EMIHomePageState extends State<EMIHomePage> {
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  List<Map<String, String>> paymentSchedule = [];

  void calculateEMI() {
    double principal = double.parse(loanAmountController.text);
    double annualInterest = double.parse(interestRateController.text);
    int tenure = int.parse(tenureController.text);

    double monthlyInterest = annualInterest / (12 * 100);
    int numberOfMonths = tenure * 12;

    double emi = (principal * monthlyInterest * pow(1 + monthlyInterest, numberOfMonths)) /
        (pow(1 + monthlyInterest, numberOfMonths) - 1);

    double remainingPrincipal = principal;

    paymentSchedule.clear(); // Clear previous results

    for (int month = 1; month <= numberOfMonths; month++) {
      double interestForMonth = remainingPrincipal * monthlyInterest;
      double principalPayment = emi - interestForMonth;
      remainingPrincipal -= principalPayment;

      paymentSchedule.add({
        'month': month.toString(),
        'emi': emi.toStringAsFixed(2),
        'principal': principalPayment.toStringAsFixed(2),
        'interest': interestForMonth.toStringAsFixed(2),
        'remaining': remainingPrincipal > 0 ? remainingPrincipal.toStringAsFixed(2) : '0.00',
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.loanType} EMI Calculator'),
      ),
      drawer: AppDrawer(), // Reuse the drawer in this screen
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loanAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Loan Amount'),
            ),
            TextField(
              controller: interestRateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Annual Interest Rate (%)'),
            ),
            TextField(
              controller: tenureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tenure (in years)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateEMI,
              child: const Text('Calculate EMI'),
            ),
            const SizedBox(height: 20),
            if (paymentSchedule.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: paymentSchedule.length,
                  itemBuilder: (context, index) {
                    final payment = paymentSchedule[index];
                    return ListTile(
                      title: Text('Month ${payment['month']}'),
                      subtitle: Text(
                        'EMI: ${payment['emi']}, Principal: ${payment['principal']}, Interest: ${payment['interest']}, Remaining: ${payment['remaining']}',
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: const Center(child: Text('This is the About Us page.')),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const Center(child: Text('This is the Privacy Policy page.')),
    );
  }
}

class OtherAppsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Other Apps')),
      body: const Center(child: Text('List of other apps will be shown here.')),
    );
  }
}
