import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/currency_utils.dart';

class LoanResultScreen extends StatefulWidget {
  final double emi;
  final double loanAmount;
  final double interestRate;
  final int years;
  final int months;
  final double totalInterest;
  final double totalAmount;
  final String currencyCode;

  const LoanResultScreen({
    super.key,
    required this.emi,
    required this.loanAmount,
    required this.interestRate,
    required this.years,
    required this.months,
    required this.totalInterest,
    required this.totalAmount,
    required this.currencyCode,
  });

  @override
  State<LoanResultScreen> createState() => _LoanResultScreenState();
}

class _LoanResultScreenState extends State<LoanResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> monthlyBreakdown;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMonthlyBreakdown();
  }

  void _generateMonthlyBreakdown() {
    monthlyBreakdown = [];
    double remainingLoan = widget.loanAmount;
    double monthlyRate = widget.interestRate / (12 * 100);
    int totalMonths = (widget.years * 12) + widget.months;

    for (int i = 1; i <= totalMonths; i++) {
      double interest = remainingLoan * monthlyRate;
      double principal = widget.emi - interest;
      remainingLoan -= principal;

      monthlyBreakdown.add({
        'month': i,
        'emi': widget.emi,
        'principal': principal,
        'interest': interest,
        'balance': remainingLoan > 0 ? remainingLoan : 0,
      });
    }
  }

  void _shareDetails() {
    Currency currency = CurrencyService.getCurrency(widget.currencyCode);
    String details = '''
Loan Details Summary:
-------------------
Principal Amount: ${currency.format(widget.loanAmount)}
Interest Rate: ${widget.interestRate}%
Loan Term: ${widget.years} years ${widget.months} months
Monthly EMI: ${currency.format(widget.emi)}
Total Interest: ${currency.format(widget.totalInterest)}
Total Amount: ${currency.format(widget.totalAmount)}
''';
    Share.share(details);
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
        title: Text('Loan Analysis',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareDetails,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.details), text: 'Details'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Charts'),
            Tab(icon: Icon(Icons.calendar_month), text: 'Schedule'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailsTab(),
          _buildChartsTab(),
          _buildScheduleTab(),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    Currency currency = CurrencyService.getCurrency(widget.currencyCode);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Monthly EMI',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currency.format(widget.emi),
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loan Summary',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(),
                  _buildDetailRow('Principal Amount', currency.format(widget.loanAmount)),
                  _buildDetailRow('Interest Rate', '${widget.interestRate}%'),
                  _buildDetailRow('Loan Term', '${widget.years} years ${widget.months} months'),
                  _buildDetailRow('Total Interest', currency.format(widget.totalInterest)),
                  _buildDetailRow('Total Amount', currency.format(widget.totalAmount)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Principal vs Interest',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: widget.loanAmount,
                            title: 'Principal\n${(widget.loanAmount / widget.totalAmount * 100).toStringAsFixed(1)}%',
                            color: Theme.of(context).colorScheme.primary,
                            radius: 100,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: widget.totalInterest,
                            title: 'Interest\n${(widget.totalInterest / widget.totalAmount * 100).toStringAsFixed(1)}%',
                            color: Theme.of(context).colorScheme.secondary,
                            radius: 100,
                            titleStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Payment Breakdown',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: widget.totalAmount,
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: widget.loanAmount,
                                color: Theme.of(context).colorScheme.primary,
                                width: 40,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: widget.totalInterest,
                                color: Theme.of(context).colorScheme.secondary,
                                width: 40,
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 2,
                            barRods: [
                              BarChartRodData(
                                toY: widget.totalAmount,
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 40,
                              ),
                            ],
                          ),
                        ],
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                String text = '';
                                switch (value.toInt()) {
                                  case 0:
                                    text = 'Principal';
                                    break;
                                  case 1:
                                    text = 'Interest';
                                    break;
                                  case 2:
                                    text = 'Total';
                                    break;
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    text,
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '₹${value.toInt()}',
                                  style: GoogleFonts.poppins(fontSize: 10),
                                );
                              },
                              reservedSize: 60,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    Currency currency = CurrencyService.getCurrency(widget.currencyCode);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Amortization Schedule',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text('Month', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                    DataColumn(
                      label: Text('EMI', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                    DataColumn(
                      label: Text('Principal', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                    DataColumn(
                      label: Text('Interest', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                    DataColumn(
                      label: Text('Balance', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    ),
                  ],
                  rows: monthlyBreakdown.map((month) {
                    return DataRow(
                      cells: [
                        DataCell(Text(month['month'].toString())),
                        DataCell(Text(currency.format(month['emi'].toDouble()))),
                        DataCell(Text(currency.format(month['principal'].toDouble()))),
                        DataCell(Text(currency.format(month['interest'].toDouble()))),
                        DataCell(Text(currency.format(month['balance'].toDouble()))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
}
