import 'package:flutter/material.dart';
import '../../models/eco_product.dart';

class EcoProductDetailScreen extends StatelessWidget {
  final EcoProduct product;

  EcoProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 200),
            ),
            const SizedBox(height: 16),

            // Long description (if available), else fallback to description
            Text(
              product.longDescription.isNotEmpty
                  ? product.longDescription
                  : product.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            const Text(
              "Advantages:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...product.advantages.map(
              (adv) => ListTile(
                leading: const Icon(Icons.check, color: Colors.green),
                title: Text(adv),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "⚠️ Non-Eco-Friendly Alternatives",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            ...product.nonEcoAlternatives.map(
              (alt) => ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: Text(alt),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 24),

            // Reasons why not to use non-eco alternatives
            if (product.nonEcoReasons.isNotEmpty) ...[
              const Text(
                "Why avoid these non-eco alternatives?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...product.nonEcoReasons.map(
                (reason) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(child: Text(reason)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
