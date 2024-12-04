import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pcparts/crunncy/test.dart';
import 'package:pcparts/screens/home_screen.dart';
import 'package:pcparts/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const LoanOptions(),
    const CurrencyConverterScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    
    if (isFirstLaunch) {
      _showDisclaimerDialog();
      await prefs.setBool('isFirstLaunch', false);
    }
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Disclaimer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "This FinFlux - EMI Calculator app is just a financial tool and not any loan provider or connection with any NBFC or any finance services. "
                "This app is working as a financial calculator app and not giving any lending services."
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final Uri url = Uri.parse('https://sites.google.com/view/finflux?usp=sharing');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(MingCute.home_4_line),
            selectedIcon: Icon(MingCute.home_4_fill),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(MingCute.tool_line),
            selectedIcon: Icon(MingCute.tool_fill),
            label: 'Tool',
          ),
          NavigationDestination(
            icon: Icon(MingCute.settings_3_line),
            selectedIcon: Icon(MingCute.settings_3_fill),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
