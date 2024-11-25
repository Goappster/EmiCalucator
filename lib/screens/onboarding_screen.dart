import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/currency_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _selectedCurrency = '₹';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _currencies = [
    {'symbol': '₹', 'name': 'Indian Rupee', 'code': 'INR', 'flag': '🇮🇳'},
    {'symbol': '\$', 'name': 'US Dollar', 'code': 'USD', 'flag': '🇺🇸'},
    {'symbol': '€', 'name': 'Euro', 'code': 'EUR', 'flag': '🇪🇺'},
    {'symbol': '£', 'name': 'British Pound', 'code': 'GBP', 'flag': '🇬🇧'},
    {'symbol': '¥', 'name': 'Japanese Yen', 'code': 'JPY', 'flag': '🇯🇵'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildCurrencySelectionPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: _isLoading ? null : () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox(width: 80),
                  Row(
                    children: List.generate(
                      2,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : () {
                      if (_currentPage < 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _saveCurrencyAndComplete();
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_currentPage < 1 ? 'Next' : 'Get Started') ,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calculate_outlined,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to EMI Calculator',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Calculate your EMI payments easily and plan your finances better',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select Your Currency',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _currencies.length,
              itemBuilder: (context, index) {
                final currency = _currencies[index];
                final isSelected = currency['symbol'] == _selectedCurrency;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCurrency = currency['symbol']!;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currency['flag']!,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${currency['code']}',
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Theme.of(context).primaryColor : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCurrencyAndComplete() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
      await currencyProvider.setCurrency(_selectedCurrency);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
      
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}