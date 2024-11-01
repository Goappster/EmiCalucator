import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SlidingPieChart extends StatefulWidget {
  @override
  _SlidingPieChartState createState() => _SlidingPieChartState();
}

class _SlidingPieChartState extends State<SlidingPieChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Define the animation to go from 0 to 1
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {}); // Rebuilds the widget with updated animation value
    });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sliding Pie Chart"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            PieChartData(
              sections: _createAnimatedSections(),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _createAnimatedSections() {
    // Define the final values for each section
    final sectionValues = [60.0, 30.0, 15.0, 15.0];

    // Apply the animation value to create the sliding effect
    return List.generate(sectionValues.length, (index) {
      final double animatedValue = sectionValues[index] * _animation.value;
      final radius = 50.0; // Keep radius constant here, but adjust if needed

      // Customize each section's color and appearance
      return PieChartSectionData(
        color: index == 0 ? Colors.blue
            : index == 1 ? Colors.orange
            : index == 2 ? Colors.green
            : Colors.red,
        value: animatedValue,
        title: '${(animatedValue).toInt()}%', // Display value dynamically
        radius: radius,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    });
  }
}

void main() {
  runApp(MaterialApp(
    home: SlidingPieChart(),
  ));
}
