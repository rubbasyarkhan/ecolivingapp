import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:eco_living_app/models/waste_log_model.dart';

class WasteStatChart extends StatelessWidget {
  final List<WasteLog> logs;

  const WasteStatChart({super.key, required this.logs});

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

  Color getCategoryColor(WasteCategory category) {
    switch (category) {
      case WasteCategory.recycling:
        return Colors.green.shade600;
      case WasteCategory.composting:
        return Colors.brown.shade400;
      case WasteCategory.plasticReduction:
        return Colors.blue.shade600;
      case WasteCategory.other:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<WasteCategory, double> totals = {
      WasteCategory.recycling: 0,
      WasteCategory.composting: 0,
      WasteCategory.plasticReduction: 0,
      WasteCategory.other: 0,
    };

    for (var log in logs) {
      totals[log.category] = (totals[log.category] ?? 0) + log.quantity.toDouble();
    }

    final totalAll = totals.values.fold(0.0, (a, b) => a + b);
    final categories = totals.keys.toList();

    final barGroups = categories.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;
      final value = totals[category]!;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            width: 20,
            color: getCategoryColor(category),
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();

    final pieSections = categories
        .where((c) => totals[c]! > 0)
        .map((category) {
          final value = totals[category]!;
          final percentage = totalAll == 0 ? 0 : (value / totalAll) * 100;
          return PieChartSectionData(
            color: getCategoryColor(category),
            value: value,
            title: "${percentage.toStringAsFixed(1)}%",
            radius: 48,
            titleStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        })
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Waste Reduction Summary",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // 🟦 Bar Chart
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < 0 || index >= categories.length) return const SizedBox();
                      final label = getCategoryLabel(categories[index]);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // 🟡 Pie Chart
        const Text(
          "Category Breakdown",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Center(
          child: SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: pieSections,
                centerSpaceRadius: 32,
                sectionsSpace: 2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 🔹 Legend
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: categories
              .where((c) => totals[c]! > 0)
              .map((category) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: getCategoryColor(category),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(getCategoryLabel(category), style: const TextStyle(fontSize: 13)),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}
