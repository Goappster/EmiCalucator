import 'package:flutter/material.dart';

void main() {
  runApp(LoanMasterApp());
}

class LoanMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoanMaster',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanMasterHomePage(),
    );
  }
}

class LoanMasterHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('loanmaster.'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.airplane_ticket, color: Colors.blue),
                  Text('Get \$15 Off on inviting your friend'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Loan Type Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.business),
                Icon(Icons.home),
                Icon(Icons.directions_car, color: Colors.blue, size: 30), // Auto loan icon
                Icon(Icons.agriculture),
              ],
            ),
            SizedBox(height: 20),

            // Loan Amount Slider
            Text('Loan Amount'),
            Slider(
              value: 34000,
              min: 100,
              max: 100000,
              divisions: 1000,
              label: '\$34,000',
              onChanged: (value) {},
            ),
            Text('\$34,000', style: TextStyle(fontSize: 18)),

            // Loan Duration Selector
            SizedBox(height: 20),
            Text('Loan Duration'),
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
            SizedBox(height: 20),
            Text('Expected Rate'),
            TextField(
              decoration: InputDecoration(
                hintText: '9% - 13%',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // See Loans Button
            ElevatedButton(
              onPressed: () {
                // Navigate to loans page or show loans
              },
              child: Text('See Loans'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Best Deals Section
            Text('Best Deals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: [
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
    Key? key,
    required this.bankName,
    required this.loanAmount,
    required this.monthlyInstalment,
    required this.rate,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bankName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Amount: $loanAmount'),
            Text('Monthly Instalment: $monthlyInstalment'),
            Text('Rate: $rate'),
            Text('Duration: $duration'),
            SizedBox(height: 10),
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
