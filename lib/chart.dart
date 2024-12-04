import 'package:flutter/material.dart';

void main() {
  runApp(const LoanMasterApp());
}

class LoanMasterApp extends StatelessWidget {
  const LoanMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoanMasterHomePage(),
    );
  }
}

class LoanMasterHomePage extends StatelessWidget {
  const LoanMasterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('loanmaster.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Invite Friends Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.airplane_ticket, color: Colors.blue),
                  Text('Get \$15 Off on inviting your friend'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Loan Type Selection
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.business),
                Icon(Icons.home),
                Icon(Icons.directions_car, color: Colors.blue, size: 30), // Auto loan icon
                Icon(Icons.agriculture),
              ],
            ),
            const SizedBox(height: 20),

            // Loan Amount Slider
            const Text('Loan Amount'),
            Slider(
              value: 34000,
              min: 100,
              max: 100000,
              divisions: 1000,
              label: '\$34,000',
              onChanged: (value) {},
            ),
            const Text('\$34,000', style: TextStyle(fontSize: 18)),

            // Loan Duration Selector
            const SizedBox(height: 20),
            const Text('Loan Duration'),
            DropdownButton<String>(
              value: '5 Years',
              items: <String>['1 Year', '3 Years', '5 Years', '10 Years']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),

            // Expected Rate Selector
            const SizedBox(height: 20),
            const Text('Expected Rate'),
            const TextField(
              decoration: InputDecoration(
                hintText: '9% - 13%',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // See Loans Button
            ElevatedButton(
              onPressed: () {
                // Navigate to loans page or show loans
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('See Loans'),
            ),
            const SizedBox(height: 20),

            // Best Deals Section
            const Text('Best Deals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: const [
                  BestDealCard(
                    bankName: 'Citi Bank',
                    loanAmount: '\$34,000',
                    monthlyInstalment: '\$1,231',
                    rate: '13% p.a.',
                    duration: '5 Years',
                  ),
                  BestDealCard(
                    bankName: 'Bank of America',
                    loanAmount: '\$34,000',
                    monthlyInstalment: '\$1,211',
                    rate: '10.22% p.a.',
                    duration: '5 Years',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BestDealCard extends StatelessWidget {
  final String bankName;
  final String loanAmount;
  final String monthlyInstalment;
  final String rate;
  final String duration;

  const BestDealCard({
    super.key,
    required this.bankName,
    required this.loanAmount,
    required this.monthlyInstalment,
    required this.rate,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bankName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Amount: $loanAmount'),
            Text('Monthly Instalment: $monthlyInstalment'),
            Text('Rate: $rate'),
            Text('Duration: $duration'),
            const SizedBox(height: 10),
            Text(
              'Top rated and very Flexible. Entirely online process and quick approval',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
