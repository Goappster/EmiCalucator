import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'dart:math';

import '../resultscreen.dart';
import '../theme/app_colors.dart';

class PersonalLoanPlanner extends StatefulWidget {
  const PersonalLoanPlanner({super.key});

  @override
  _PersonalLoanPlannerState createState() => _PersonalLoanPlannerState();
}

class _PersonalLoanPlannerState extends State<PersonalLoanPlanner> {

  final TextEditingController amountController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController loanTenureController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  DateTime? selectedStartDate;
  String tenureType = 'Months';

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter loan amount';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  String? _validateInterestRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter interest rate';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) <= 0 || double.parse(value) > 100) {
      return 'Rate must be between 0 and 100';
    }
    return null;
  }

  String? _validateTenure(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter loan tenure';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (int.parse(value) <= 0) {
      return 'Tenure must be greater than 0';
    }
    return null;
  }

  void _navigateToResultScreen() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (selectedStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return;
    }

    double principal = double.parse(amountController.text);
    double annualRate = double.parse(interestRateController.text);
    int tenure = int.parse(loanTenureController.text);

    if (tenureType == 'Years') {
      tenure *= 12; // Convert years to months
    }

    // Calculate EMI
    double monthlyRate = annualRate / 12 / 100;
    double emi = (principal * monthlyRate * pow(1 + monthlyRate, tenure)) /
        (pow(1 + monthlyRate, tenure) - 1);

    double totalPayment = emi * tenure;
    double totalInterest = totalPayment - principal;

    // Navigate to Result Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          emi: emi,
          totalPayment: totalPayment,
          totalInterest: totalInterest,
          startDate: selectedStartDate!,
          principal: principal,
          annualRate: annualRate,
          tenure: tenure,
        ),
      ),
    );
  }


  String nameCategory = 'Car loan';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryColor
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, ),
                        ),
                         Text(
                         nameCategory,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          amountController.clear();
                          interestRateController.clear();
                          loanTenureController.clear();
                          selectedStartDate = null;
                          tenureType = 'Months';
                        });
                      },
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            'Loan Amount',
                            MingCute.coin_2_fill,
                            amountController,
                            'Enter amount',
                            _validateAmount,
                          ),
                          const SizedBox(height: 20),
                          _buildInputField(
                            'Interest Rate (%)',
                            Icons.percent_rounded,
                            interestRateController,
                            'Enter rate',
                            _validateInterestRate,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildInputField(
                                  'Loan Tenure',
                                  MingCute.to_do_fill,
                                  loanTenureController,
                                  'Duration',
                                  _validateTenure,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Duration',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: tenureType,
                                          isExpanded: true,
                                          icon: Icon(
                                           MingCute.down_small_fill,
                                            // color: Theme.of(context).primaryColor,
                                          ),
                                          items: ['Months', 'Years']
                                              .map((type) => DropdownMenuItem(
                                                    value: type,
                                                    child: Text(type),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              tenureType = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Date Picker
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedStartDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedStartDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(MingCute.calendar_fill,
                                     /* color: Theme.of(context).primaryColor*/),
                                  const SizedBox(width: 12),
                                  Text(
                                    selectedStartDate == null
                                        ? 'Select Start Date'
                                        : 'Start Date: ${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Calculate Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _navigateToResultScreen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  
                                ),
                              ),
                              child:  Text(
                                'Calculate',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                                ),
                              ),
                            ),
                    
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    TextEditingController controller,
    String hint, [
    String? Function(String?)? validator,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon,),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

