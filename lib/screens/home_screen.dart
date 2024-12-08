import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pcparts/TestCOde/dashbord.dart';
import 'package:pcparts/l10n/app_localizations.dart';
import 'package:pcparts/screens/advanced_loan_calculator.dart';

class LoanOptions extends StatelessWidget {
  const LoanOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dashboard),
        // centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(12.0), // Add some padding around the icon
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8), // Rounded corners
            child: Image.asset(
              'assets/app_icon.png',
              height: 40, // Ensure proper size
              width: 40,
              fit: BoxFit.cover, // Ensures the image fits well within the rounded edges
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(MingCute.announcement_fill, size: 25,), // Notification icon
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('✨Release Notes (1.5)'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1️⃣ Enhanced EMI Calculation 📊"),
                          // SizedBox(height: 8),
                          Text("2️⃣ Multiple Loan Types 🏠🚗🎓"),
                          Text("3️⃣ Customizable Loan Parameters ⚙️💼"),
                          Text("4️⃣ Loan Breakdown💡🎉"),
                          Text("5️⃣ Currency Selection💸🌍"),
                          
                          SizedBox(height: 16),
                          const Text(
                "💡 *Note:* This FinFlux - EMI Calculator app is just a financial tool and not any loan provider or connection with any NBFC or any finance services. "
                "This app is working as a financial calculator app and not giving any lending services."
              ),
                          // Text(
                          //     "💡 *Note:* This is a tool for financial calculations only, not a lending service."
                          // ),
                    
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Got it!'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
     body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 2.4,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            GestureDetector(
              onTap: () {
            //   Navigator.push(
            //    context,
            //    MaterialPageRoute(builder: (context) => const AdvancedLoanCalculatorScreen()),
            //  );
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
              },
              child: LoanCard(title: AppLocalizations.of(context)!.businessLoan, ImagePath: 'assets/house_loan.png', BgImagePath: 'assets/bd_07.png'),
            ),
            GestureDetector(
              onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
            },
              child: LoanCard(title: AppLocalizations.of(context)!.mortgageLoans, ImagePath: 'assets/mortgage_loan.png', BgImagePath: 'assets/bd_04.png'),
            ),
            GestureDetector(
              onTap: () { 

              Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
              },
              child: LoanCard(title: AppLocalizations.of(context)!.flatVsReducing, ImagePath: 'assets/car_loan.png', BgImagePath:'assets/bd_02.png'),
            ),
            GestureDetector(
              onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
              } ,
              child: LoanCard(title: AppLocalizations.of(context)!.homeLoan, ImagePath: 'assets/home_loan.png', BgImagePath: 'assets/bd_01.png'),
            ),
            GestureDetector(
              onTap: () {
               Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
               },
              child: LoanCard(title: AppLocalizations.of(context)!.fixedDeposit, ImagePath: 'assets/deposit_loan.png', BgImagePath: 'assets/bd_03.png'),
            ),
            GestureDetector(
              onTap: () {
                  Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
               },
              child: LoanCard(title: AppLocalizations.of(context)!.carLoan, ImagePath: 'assets/car_cal_loan.png',  BgImagePath: 'assets/bd_06.png'),
            ),
            GestureDetector(
              onTap: () { 
                  Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const PersonalLoanPlanner(nameCategory: 'EMi Calculater',)),
             );
              },
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
  final String? subtitle;
  final IconData? icon;
  final String? ImagePath;
  final String? BgImagePath;
  final VoidCallback? onTap;

  const LoanCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.ImagePath,
    this.BgImagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(BgImagePath ?? ''),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
