import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eco_living_app/models/waste_log_model.dart';

class WasteLogCard extends StatelessWidget {
  final WasteLog log;

  const WasteLogCard({super.key, required this.log});

  String getCategoryLabel(WasteCategory category) {
    switch (category) {
      case WasteCategory.recycling:
        return "Recycling";
      case WasteCategory.composting:
        return "Composting";
      case WasteCategory.plasticReduction:
        return "Plastic Reduction";
      case WasteCategory.other:
        return "Other";
    }
  }

  IconData getCategoryIcon(WasteCategory category) {
    switch (category) {
      case WasteCategory.recycling:
        return Icons.recycling;
      case WasteCategory.composting:
        return Icons.eco;
      case WasteCategory.plasticReduction:
        return Icons.delete_outline;
      case WasteCategory.other:
        return Icons.help_outline;
    }
  }

  Color getCategoryColor(WasteCategory category) {
    switch (category) {
      case WasteCategory.recycling:
        return Colors.green.shade600;
      case WasteCategory.composting:
        return Colors.brown.shade400;
      case WasteCategory.plasticReduction:
        return Colors.blue.shade600;
      case WasteCategory.other:
        return Colors.grey.shade600;
    }
  }

  String formatUnit(int quantity, String unit) {
    // Very basic pluralization
    if (quantity == 1) return "$quantity $unit";
    if (unit.endsWith('s')) return "$quantity $unit";
    return "$quantity ${unit}s";
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(log.category);
    final formattedDate = DateFormat('MMM d, yyyy – hh:mm a').format(log.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: categoryColor.withOpacity(0.08), // More subtle background
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Row(
              children: [
                Icon(getCategoryIcon(log.category), color: categoryColor),
                const SizedBox(width: 8),
                Text(
                  getCategoryLabel(log.category),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Method & Quantity
            Text(
              "Method: ${log.method}",
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              "Quantity: ${formatUnit(log.quantity, log.unit)}",
              style: const TextStyle(fontSize: 14.5),
            ),
            const SizedBox(height: 8),

            // Timestamp
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.black54),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Colors.black54, fontSize: 13.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
