import 'package:flutter/material.dart';
import 'package:pcparts/Widget/bottom_nav.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'theme/theme_provider.dart';
import 'theme/language_provider.dart';
import 'providers/currency_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/car_loan_calculator.dart';
import 'screens/personal_loan_calculator.dart';
import 'screens/result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
  runApp(EMICalculatorApp(showOnboarding: !hasCompletedOnboarding));
}

class EMICalculatorApp extends StatelessWidget {

  final bool showOnboarding;
  const EMICalculatorApp({super.key, this.showOnboarding = true});

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
          
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              ColorScheme lightScheme;
              ColorScheme darkScheme;

              if (lightDynamic != null && darkDynamic != null) {
                lightScheme = lightDynamic;
                darkScheme = darkDynamic;
              } else {
                lightScheme = ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.light,
                );
                darkScheme = ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                );
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: lightScheme,
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: darkScheme,
                ),
                themeMode: themeProvider.themeMode,
                locale: languageProvider.currentLocale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                home: showOnboarding ? const OnboardingScreen() : const BottomNav(),
                routes: {
                  '/home': (context) => const BottomNav(),
                  // '/home_loan': (context) => const HomeLoalnCalculator(),
                  '/car_loan': (context) => const CarLoanCalculator(),
                  '/personal_loan': (context) => const PersonalLoanCalculator(),
                  '/result': (context) => const ResultScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }

}


