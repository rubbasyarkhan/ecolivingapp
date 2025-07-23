import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CarbonResultScreen extends StatelessWidget {
  final double co2Kg;
  final String category;
  final String? transportMode;
  final double? distanceKm;
  final double? electricityKwh;
  final double? gasTherms;
  final String? dietType;

  CarbonResultScreen({
    required this.co2Kg,
    required this.category,
    this.transportMode,
    this.distanceKm,
    this.electricityKwh,
    this.gasTherms,
    this.dietType,
  });

  String getFeedback() {
    if (co2Kg < 5) return "🌱 Excellent! Your carbon impact is low. Keep it up!";
    if (co2Kg < 10) return "🙂 Good job! Try reducing transport or electricity use.";
    return "⚠️ High footprint! Consider biking, saving energy, or trying a plant-based diet.";
  }

  Future<void> saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final entryDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carbon_footprint')
        .doc();

    await entryDoc.set({
      'timestamp': DateTime.now(),
      'date': dateKey,
      'category': category,
      'co2_kg': co2Kg,
      'transport_mode': transportMode ?? '',
      'distance_km': distanceKm ?? 0.0,
      'electricity_kwh': electricityKwh ?? 0.0,
      'gas_therms': gasTherms ?? 0.0,
      'diet_type': dietType ?? '',
      'feedback': getFeedback(),
    });

    final summaryDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('carbon_summary')
        .doc(dateKey);

    final existing = await summaryDoc.get();
    final existingValue = existing.exists ? (existing.data()?['co2_kg'] ?? 0.0) : 0.0;

    await summaryDoc.set({
      'co2_kg': existingValue + co2Kg,
    });
  }

  @override
  Widget build(BuildContext context) {
    saveToFirestore();

    return Scaffold(
      appBar: AppBar(title: Text('Your Carbon Impact')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Your estimated daily carbon footprint from $category is:",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text("${co2Kg.toStringAsFixed(2)} kg CO₂",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: co2Kg > 10 ? Colors.red : (co2Kg > 5 ? Colors.orange : Colors.green),
                )),
            SizedBox(height: 24),
            Text(getFeedback(), style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            SizedBox(height: 32),

            // Conditional display based on category
            if (category == 'Transportation') ...[
              ListTile(
                leading: Icon(Icons.directions_car),
                title: Text('Transport Mode'),
                subtitle: Text(transportMode ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.route),
                title: Text('Distance Traveled'),
                subtitle: Text('${distanceKm?.toStringAsFixed(1) ?? "0"} km'),
              ),
            ],
            if (category == 'Electricity') ...[
              ListTile(
                leading: Icon(Icons.bolt),
                title: Text('Electricity Usage'),
                subtitle: Text('${electricityKwh?.toStringAsFixed(1) ?? "0"} kWh'),
              ),
            ],
            if (category == 'Gas') ...[
              ListTile(
                leading: Icon(Icons.local_fire_department),
                title: Text('Gas Usage'),
                subtitle: Text('${gasTherms?.toStringAsFixed(1) ?? "0"} therms'),
              ),
            ],
            if (category == 'Food') ...[
              ListTile(
                leading: Icon(Icons.fastfood),
                title: Text('Diet Type'),
                subtitle: Text(dietType ?? ''),
              ),
            ],

            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Form'),
            ),
          ],
        ),
      ),
    );
  }
}
