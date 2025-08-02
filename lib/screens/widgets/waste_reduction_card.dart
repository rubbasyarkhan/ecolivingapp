// lib/screens/widgets/waste_reduction_card.dart
import 'package:flutter/material.dart';

class WasteReductionCard extends StatelessWidget {
  final Map<String, double> data;

  const WasteReductionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Waste Reduction Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (data.isEmpty)
              const Text("No data available.")
            else
              ...data.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text('${entry.value.toStringAsFixed(1)} units'),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}
