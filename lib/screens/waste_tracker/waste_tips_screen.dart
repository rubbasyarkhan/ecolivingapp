import 'package:flutter/material.dart';
import '../../constants/colors.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Waste Reduction Tips'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tips.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            color: AppColors.card,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(
                Icons.eco,
                color: AppColors.primary,
                size: 28,
              ),
              title: Text(
                tips[index],
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
