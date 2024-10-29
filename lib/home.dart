import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('EMI Calculator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1,
            children: List.generate(8, (index) {
              String title;
              String imagePath;
              // Define specific names and images for each item
              if (index % 2 == 0) {
                title = 'EMI Calculator';
                imagePath = 'assets/emi_image.png'; // Path to your EMI image
              } else {
                title = 'Loan Details';
                imagePath = 'assets/loan_image.png'; // Path to your Loan image
              }
              return Card(
                color: Colors.white,
                elevation: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        imagePath,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,// Adjust the height as needed
                      ),
                      SizedBox(height: 10),
                      Text(
                        title,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
