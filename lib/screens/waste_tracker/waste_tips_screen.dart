import 'package:flutter/material.dart';

class WasteTipsScreen extends StatelessWidget {
  final List<String> tips = [
    "♻️ Use reusable bags, bottles, and containers.",
    "🌱 Start composting your food scraps.",
    "🚫 Avoid single-use plastics like straws and cutlery.",
    "📦 Repurpose jars, boxes, and packaging.",
    "🧴 Buy in bulk to reduce packaging waste.",
    "🌍 Participate in local clean-up drives.",
    "👚 Donate or recycle old clothes instead of throwing them away.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waste Reduction Tips')),
      body: ListView.builder(
        itemCount: tips.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.lightbulb_outline, color: Colors.green),
              title: Text(tips[index]),
            ),
          );
        },
      ),
    );
  }
}
