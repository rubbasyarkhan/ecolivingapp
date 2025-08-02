import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../services/nutrition_service.dart';
import '../../constants/colors.dart'; // for AppColors

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map<String, dynamic>? nutrition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNutrition();
  }

  Future<void> loadNutrition() async {
    final data = await NutritionService.getNutritionData(
      widget.recipe.id.toString(),
      widget.recipe.name,
    );
    setState(() {
      nutrition = data;
      isLoading = false;
    });
  }

  Widget buildNutritionRow(
      String label, dynamic value, String unit, Map<String, dynamic>? range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        "$label: ${value ?? 'N/A'} ${unit.isNotEmpty ? unit : ''}"
        "${(range != null && range['min'] != null && range['max'] != null) ? " (Range: ${range['min']} - ${range['max']})" : ""}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.recipe.name),
        backgroundColor: const Color.fromARGB(255, 125, 95, 46),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.recipe.image,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          Text("🧂 Ingredients",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 8),
          ...widget.recipe.ingredients
              .map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $i"),
                  ))
              .toList(),
          const SizedBox(height: 20),

          Text("👨‍🍳 Instructions",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 8),
          ...widget.recipe.instructions
              .map((step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $step"),
                  ))
              .toList(),
          const SizedBox(height: 24),

          Text("🍽 Nutrition Info",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 12),

          isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              : nutrition != null
                  ? Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildNutritionRow(
                              "Calories",
                              nutrition!['calories']?['value'],
                              nutrition!['calories']?['unit'] ?? 'kcal',
                              nutrition!['calories']
                                  ?['confidenceRange95Percent'],
                            ),
                            buildNutritionRow(
                              "Protein",
                              nutrition!['protein']?['value'],
                              nutrition!['protein']?['unit'] ?? 'g',
                              nutrition!['protein']
                                  ?['confidenceRange95Percent'],
                            ),
                            buildNutritionRow(
                              "Fat",
                              nutrition!['fat']?['value'],
                              nutrition!['fat']?['unit'] ?? 'g',
                              nutrition!['fat']?['confidenceRange95Percent'],
                            ),
                            buildNutritionRow(
                              "Carbs",
                              nutrition!['carbs']?['value'],
                              nutrition!['carbs']?['unit'] ?? 'g',
                              nutrition!['carbs']?['confidenceRange95Percent'],
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Text(
                      "Nutrition info not available.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
        ],
      ),
    );
  }
}
