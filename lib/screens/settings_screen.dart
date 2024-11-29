import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/language_provider.dart';
import '../providers/currency_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Theme Toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return SwitchListTile(
                title: const Text('Dark Mode'),
                secondary: Icon(
                  themeProvider.isDarkMode ? MingCute.moon_stars_fill : MingCute.moonlight_line,
                  size: 30,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
          const Divider(),
          
          // Language Selection
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return ExpansionTile(
                leading: const Icon(MingCute.translate_2_line, size: 30,),
                title: const Text('Language'),
                children: languageProvider.supportedLanguages.entries.map((language) {
                  return RadioListTile<String>(
                    title: Text(language.value),
                    value: language.key,
                    groupValue: languageProvider.currentLocale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        languageProvider.setLanguage(value);
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
          const Divider(),
          
          // Currency Selection
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Currency'),
            subtitle: Row(
              children: [
                Text(
                  currencyProvider.currentCurrencyData['flag'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text('${currencyProvider.currentCurrencyData['name']} (${currencyProvider.currentCurrency})'),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select Currency'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: currencyProvider.supportedCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = currencyProvider.supportedCurrencies[index];
                        final isSelected = currency['symbol'] == currencyProvider.currentCurrency;
                        
                        return InkWell(
                          onTap: () {
                            currencyProvider.setCurrency(currency['symbol']!);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.grey.withOpacity(0.20),
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1) : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currency['flag']!,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currency['code']!,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          
          // Privacy Policy
          ListTile(
            leading: const Icon(MingCute.question_fill, size: 30,),
            title: const Text('Privacy Policy'),
            onTap: () {
              launchUrl(Uri.parse('https://sites.google.com/view/finflux?usp=sharing'));
            },
          ),
          const Divider(),
          
          // Share App
          ListTile(
            leading: const Icon(MingCute.share_2_fill, size: 30,),
            title: const Text('Share App'),
            onTap: () {
              Share.share('Check out this amazing EMI Calculator app! '
                  'https://play.google.com/store/apps/details?id=com.fin.flux.dev.app');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(MingCute.star_half_fill, size: 30,),
            title: const Text('Rate App'),
            onTap: () {
              // Add your Play Store link here
              launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.fin.flux.dev.app'));
            },
          ),
          const Divider(),
          // About
          ListTile(
            leading: const Icon(MingCute.information_fill, size: 30,),
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Fin Flux - EMI Loan Calculator',
                applicationVersion: '1.4',
                applicationIcon: ClipRRect(borderRadius:  BorderRadius.circular(18),child: Image.asset('assets/app_icon.png', width: 70, height: 70)),
                children: const [
                  Text('This comprehensive financial calculator is designed to save you time and reduce errors'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
