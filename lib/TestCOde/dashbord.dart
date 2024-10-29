import 'package:flutter/material.dart';

void main() {
  runApp(EMICalculatorApp());
}

class EMICalculatorApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMI Calculator',
      home: Scaffold(
        key: _scaffoldKey, // Assign the key here
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('EMI Calculator'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.home, color: Colors.black), // Custom drawer icon
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer(); // Open the drawer
            },
          ),
        ),
        drawer: AppDrawer(),
        body: LoanOptions(),
      ),
    );
  }
}

class LoanOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: [
          LoanCard(title: 'Car Loan', ImagePath: 'assets/house_loan.png'),
          LoanCard(title: 'Business Loan', ImagePath: 'assets/house_loan.png'),
          LoanCard(title: 'Mortgage Loans', ImagePath: 'assets/house_loan.png'),
          LoanCard(title: 'Flat Vs Reducing', ImagePath: 'assets/house_loan.png'),
          LoanCard(title: 'Home Loan', ImagePath: 'assets/house_loan.png'),
          LoanCard(title: 'Fixed Deposit', ImagePath: 'assets/house_loan.png'),
        ],
      ),
    );
  }
}

class LoanCard extends StatelessWidget {
  final String title;
  final String ImagePath;

  LoanCard({required this.title, required this.ImagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagePath,
            height: 80,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/app_logo.png'), // Replace with your app logo
                ),
                SizedBox(height: 10),
                Text(
                  'EMI Calculator',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Other Apps'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OtherAppsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate Us'),
            onTap: () {
              // Handle the rating functionality here
            },
          ),
        ],
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
