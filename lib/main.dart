import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:pcparts/crunncy/test.dart';
import 'package:pcparts/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'theme/language_provider.dart';
import 'providers/currency_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';

import 'TestCOde/dashbord.dart';
import 'screens/home_loan_calculator.dart';
import 'screens/car_loan_calculator.dart';
import 'screens/personal_loan_calculator.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const EMICalculatorApp());
}

class EMICalculatorApp extends StatelessWidget {
  const EMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          final languageProvider = Provider.of<LanguageProvider>(context);
          Provider.of<CurrencyProvider>(context);
          
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            locale: languageProvider.currentLocale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: const OnboardingScreen(),
            routes: {
              '/home': (context) => const BottomNavExample(),
              '/home_loan': (context) => const HomeLoanCalculator(),
              '/car_loan': (context) => const CarLoanCalculator(),
              '/personal_loan': (context) => const PersonalLoanCalculator(),
              '/result': (context) => const ResultScreen(),
            },
          );
        },
      ),
    );
  }

  Future<bool> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_completed_onboarding') ?? false;
  }
}

class LoanOptions extends StatelessWidget {
  const LoanOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dashboard),
        centerTitle: true,
        leading:
        Padding(padding: const EdgeInsets.only(left: 8), child: Lottie.asset('assets/permuim.json', width: 30, height: 30, animate: true)),
      ),
     body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8 ),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 2.4,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            GestureDetector(

              child: LoanCard(title: AppLocalizations.of(context)!.businessLoan, ImagePath: 'assets/house_loan.png', BgImagePath: 'assets/bd_07.png'),
            ),
            GestureDetector(
              onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner()),
             );
            },
              child: LoanCard(title: AppLocalizations.of(context)!.mortgageLoans, ImagePath: 'assets/mortgage_loan.png', BgImagePath: 'assets/bd_04.png'),
            ),
            GestureDetector(
              onTap: () { },
              child: LoanCard(title: AppLocalizations.of(context)!.flatVsReducing, ImagePath: 'assets/car_loan.png', BgImagePath:'assets/bd_02.png'),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home_loan');
              } ,
              child: LoanCard(title: AppLocalizations.of(context)!.homeLoan, ImagePath: 'assets/home_loan.png', BgImagePath: 'assets/bd_01.png'),
            ),
            GestureDetector(
              onTap: () { },
              child: LoanCard(title: AppLocalizations.of(context)!.fixedDeposit, ImagePath: 'assets/deposit_loan.png', BgImagePath: 'assets/bd_03.png'),
            ),
            GestureDetector(
              onTap: () { },
              child: LoanCard(title: AppLocalizations.of(context)!.carLoan, ImagePath: 'assets/car_cal_loan.png',  BgImagePath: 'assets/bd_06.png'),
            ),
            GestureDetector(
              onTap: () { },
              child: LoanCard(title: AppLocalizations.of(context)!.recurringDeposit, ImagePath: 'assets/recurring_dep.png', BgImagePath: 'assets/bd_05.png'),
            ),
          ],
        ),
      ),
    );
  }
}


class LoanCard extends StatelessWidget {
  final String title;
  final String ImagePath;
  final String BgImagePath;

  const LoanCard({super.key, required this.title, required this.ImagePath, required this.BgImagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
       borderRadius: BorderRadius.circular(16),
        image:  DecorationImage(image: AssetImage(BgImagePath), fit: BoxFit.cover, ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text( title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],),
            ],
          ),
      ),
    );
  }
}


class BottomNavExample extends StatefulWidget {
  const BottomNavExample({super.key});

  @override
  _BottomNavExampleState createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
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
      _showDisclaimerDialog();
    });
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('disclaimer'),
          content: const Text("This FinFlux - EMI Calculator app is just a financial tool and not any loan provider or connection with any NBFC or any finance services"
          "This app is working as a financial calculator app and not giving any lending services."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('accept'),
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
