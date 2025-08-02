import 'package:eco_living_app/constants/colors.dart';
import 'package:flutter/material.dart';

class TravelOptionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const TravelOptionDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(data['name'] ?? 'Travel Option Details'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data['imageUrl'] != null &&
                data['imageUrl'].toString().isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  data['imageUrl'],
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(
                        height: 220,
                        color: AppColors.secondary,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 60, color: AppColors.text),
                        ),
                      ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              data['name'] ?? 'Eco Travel Option',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              data['details'] ?? 'No details available.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
