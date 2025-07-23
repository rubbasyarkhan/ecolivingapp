import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_living_app/screens/carbon_tracker/carbon_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CarbonDashboardScreen extends StatefulWidget {
  @override
  _CarbonDashboardScreenState createState() => _CarbonDashboardScreenState();
}

class _CarbonDashboardScreenState extends State<CarbonDashboardScreen> {
  double totalEmissions = 0;
  double todayEmission = 0;
  Map<String, double> categoryEmissions = {
    'Transportation': 0,
    'Electricity': 0,
    'Gas': 0,
    'Food': 0,
  };

  final Map<String, IconData> categoryIcons = {
    'Transportation': Icons.directions_car,
    'Electricity': Icons.flash_on,
    'Gas': Icons.local_gas_station,
    'Food': Icons.restaurant,
  };

  final Map<String, Color> categoryColors = {
    'Transportation': Colors.blueAccent,
    'Electricity': Colors.yellow.shade800,
    'Gas': Colors.deepOrange,
    'Food': Colors.green,
  };

  @override
  void initState() {
    super.initState();
    fetchCarbonData();
  }

  Future<void> fetchCarbonData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final allDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carbon_footprint')
        .get();

    double total = 0;
    double today = 0;
    Map<String, double> categories = {
      'Transportation': 0,
      'Electricity': 0,
      'Gas': 0,
      'Food': 0,
    };

    for (var doc in allDocs.docs) {
      final data = doc.data();
      double co2 = (data['co2_kg'] ?? 0).toDouble();
      String cat = data['category'] ?? 'Other';
      String date = data['date'] ?? '';

      total += co2;
      if (date == todayKey) today += co2;

      if (categories.containsKey(cat)) {
        categories[cat] = categories[cat]! + co2;
      }
    }

    setState(() {
      totalEmissions = total;
      todayEmission = today;
      categoryEmissions = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (totalEmissions / 100).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: Text("Carbon Emission Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CarbonInputScreen()),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Emission"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Total Carbon Emission",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress < 0.33
                              ? Colors.green
                              : (progress < 0.66 ? Colors.orange : Colors.red),
                        ),
                      ),
                    ),
                    Text("${totalEmissions.toStringAsFixed(1)} kg CO₂",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 32),
          Text("Today's Emission",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            leading: Icon(Icons.today, color: Colors.teal),
            title: Text(todayEmission > 0
                ? "${todayEmission.toStringAsFixed(2)} kg CO₂"
                : "No data logged today"),
          ),

          Divider(height: 32),
          Text("Emissions by Category",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          ...categoryEmissions.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(categoryIcons[entry.key],
                    color: categoryColors[entry.key]),
                title: Text(entry.key),
                trailing: Text("${entry.value.toStringAsFixed(2)} kg",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          }).toList(),

          SizedBox(height: 32),
          Text("Category Comparison",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: categoryEmissions.values.fold(
                        0.0, (a, b) => a > b ? a : b) +
                    5,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 30)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final category =
                            categoryEmissions.keys.toList()[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(category.substring(0, 3),
                              style: TextStyle(fontSize: 12)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(categoryEmissions.length, (index) {
                  final key = categoryEmissions.keys.elementAt(index);
                  final value = categoryEmissions[key]!;
                  return BarChartGroupData(x: index, barRods: [
                    BarChartRodData(
                      toY: value,
                      width: 24,
                      gradient: LinearGradient(
                        colors: [
                          categoryColors[key]!,
                          categoryColors[key]!.withOpacity(0.6)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    )
                  ]);
                }),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
              swapAnimationDuration: Duration(milliseconds: 400),
            ),
          ),
        ],
      
      ),
    );
  }
}
