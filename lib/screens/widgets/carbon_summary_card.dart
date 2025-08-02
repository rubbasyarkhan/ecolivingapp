import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_living_app/models/carbon_log.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class CarbonSummaryCard extends StatefulWidget {
  const CarbonSummaryCard({Key? key}) : super(key: key);

  @override
  State<CarbonSummaryCard> createState() => _CarbonSummaryCardState();
}

class _CarbonSummaryCardState extends State<CarbonSummaryCard> {
  List<CarbonLog> logs = [];
  double todayTotal = 0;
  double allTimeTotal = 0;

  double transport = 0;
  double electricity = 0;
  double gas = 0;
  double food = 0;

  @override
  void initState() {
    super.initState();
    _loadCarbonLogs();
  }

  Future<void> _loadCarbonLogs() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('carbon_logs')
          .where('userId', isEqualTo: uid)
          .get();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      List<CarbonLog> loaded = snapshot.docs
          .map((doc) => CarbonLog.fromJson(doc.data(), doc.id))
          .toList();

      double todaySum = 0, totalSum = 0;
      double t = 0, e = 0, g = 0, f = 0;

      for (var log in loaded) {
        totalSum += log.totalCo2Kg;
        if (log.date.year == today.year &&
            log.date.month == today.month &&
            log.date.day == today.day) {
          todaySum += log.totalCo2Kg;
        }

        t += log.distanceKm * 0.21;
        e += log.electricityKwh * 0.475;
        g += log.gasTherms * 5.3;
        f += _estimateFoodEmission(log.dietType);
      }

      setState(() {
        logs = loaded;
        todayTotal = todaySum;
        allTimeTotal = totalSum;
        transport = t;
        electricity = e;
        gas = g;
        food = f;
      });
    } catch (e) {
      print("Error loading carbon logs: $e");
    }
  }

  double _estimateFoodEmission(String dietType) {
    switch (dietType.toLowerCase()) {
      case 'vegan':
        return 2;
      case 'vegetarian':
        return 3;
      case 'non-veg':
        return 6;
      default:
        return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🌍 Carbon Footprint Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("All-Time: ${allTimeTotal.toStringAsFixed(1)} kg CO₂"),
            Text("Today: ${todayTotal.toStringAsFixed(1)} kg CO₂"),
            const SizedBox(height: 16),
            const Text("Breakdown (by source)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: max(transport, max(electricity, max(gas, food))) + 5,
                  barGroups: [
                    _barData(0, transport, Colors.green, "Transport"),
                    _barData(1, electricity, Colors.orange, "Electricity"),
                    _barData(2, gas, Colors.blue, "Gas"),
                    _barData(3, food, Colors.purple, "Food"),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text("T");
                            case 1:
                              return const Text("E");
                            case 2:
                              return const Text("G");
                            case 3:
                              return const Text("F");
                          }
                          return const Text("");
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData _barData(int x, double y, Color color, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: color, width: 18),
      ],
    );
  }
}
