import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/currency_provider.dart';

class ResultScreen extends StatefulWidget {
  final double emi;
  final double totalPayment;
  final double totalInterest;
  final DateTime startDate;
  final double principal;
  final double annualRate;
  final int tenure;

  const ResultScreen({
    super.key,
    required this.emi,
    required this.totalPayment,
    required this.totalInterest,
    required this.startDate,
    required this.principal,
    required this.annualRate,
    required this.tenure,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loan Summary',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(),
          tabs: const [
            Tab(
              icon: Icon(Icons.info_outline),
              text: 'Details',
            ),
            Tab(
              icon: Icon(Icons.pie_chart),
              text: 'Chart',
            ),
            Tab(
              icon: Icon(Icons.calendar_month),
              text: 'Monthly',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Details Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildEmiCard(),
                const SizedBox(height: 16),
                _buildDetailsCard(),
              ],
            ),
          ),
          
          // Chart Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPieChart(),
              ],
            ),
          ),
          
          // Monthly Details Tab
          _buildMonthlyDetails(),
        ],
      ),
    );
  }

  Widget _buildEmiCard() {
    return Consumer<CurrencyProvider>(
      builder: (context, currencyProvider, child) {
        final currencySymbol = currencyProvider.currencySymbol;
        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 0,
            color: Colors.blue[100],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Monthly EMI',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currencySymbol${widget.emi.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard() {
    final currencySymbol = Provider.of<CurrencyProvider>(context).currencySymbol;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Principal Amount', '$currencySymbol${widget.principal.toStringAsFixed(2)}'),
            _buildDetailRow('Interest Rate', '${widget.annualRate}%'),
            _buildDetailRow('Loan Tenure', '${widget.tenure} months'),
            _buildDetailRow('Total Interest', '$currencySymbol${widget.totalInterest.toStringAsFixed(2)}'),
            _buildDetailRow('Total Payment', '$currencySymbol${widget.totalPayment.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final currencySymbol = Provider.of<CurrencyProvider>(context).currencySymbol;
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: widget.principal,
                      title: '$currencySymbol${widget.principal.toStringAsFixed(0)}',
                      radius: touchedIndex == 0 ? 110 : 100,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: widget.totalInterest,
                      title: '$currencySymbol${widget.totalInterest.toStringAsFixed(0)}',
                      radius: touchedIndex == 1 ? 110 : 100,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$currencySymbol${widget.totalPayment.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildChartDetailRow(
                  'Principal Amount',
                  '$currencySymbol${widget.principal.toStringAsFixed(2)}',
                  Colors.blue,
                  '${((widget.principal / widget.totalPayment) * 100).toStringAsFixed(1)}%',
                ),
                const SizedBox(height: 12),
                _buildChartDetailRow(
                  'Interest Amount',
                  '$currencySymbol${widget.totalInterest.toStringAsFixed(2)}',
                  Colors.orange,
                  '${((widget.totalInterest / widget.totalPayment) * 100).toStringAsFixed(1)}%',
                ),
                const Divider(height: 24),
                _buildChartDetailRow(
                  'Total Amount',
                  '$currencySymbol${widget.totalPayment.toStringAsFixed(2)}',
                  Colors.grey[800]!,
                  '100%',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartDetailRow(String label, String amount, Color color, String percentage, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                  color: isBold ? Colors.grey[800] : color,
                ),
              ),
              Text(
                percentage,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyDetails() {
    final currencySymbol = Provider.of<CurrencyProvider>(context).currencySymbol;
    List<Map<String, dynamic>> monthlyBreakdown = _calculateMonthlyBreakdown();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: monthlyBreakdown.length,
      itemBuilder: (context, index) {
        final payment = monthlyBreakdown[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ExpansionTile(
            title: Text(
              'Month ${index + 1}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildMonthlyDetailRow('EMI Amount', '$currencySymbol${widget.emi.toStringAsFixed(2)}'),
                    _buildMonthlyDetailRow('Principal', '$currencySymbol${payment['principal'].toStringAsFixed(2)}'),
                    _buildMonthlyDetailRow('Interest', '$currencySymbol${payment['interest'].toStringAsFixed(2)}'),
                    _buildMonthlyDetailRow('Balance', '$currencySymbol${payment['balance'].toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthlyDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _calculateMonthlyBreakdown() {
    List<Map<String, dynamic>> breakdown = [];
    double remainingBalance = widget.principal;
    double monthlyRate = widget.annualRate / 12 / 100;

    for (int i = 0; i < widget.tenure; i++) {
      double interest = remainingBalance * monthlyRate;
      double principal = widget.emi - interest;
      remainingBalance -= principal;

      breakdown.add({
        'principal': principal,
        'interest': interest,
        'balance': remainingBalance > 0 ? remainingBalance : 0,
      });
    }

    return breakdown;
  }
}