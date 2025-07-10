import 'package:flutter/material.dart';
import '../../models/recipe_model.dart';
import '../../services/nutrition_service.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$label: ${value ?? 'N/A'} ${unit.isNotEmpty ? unit : ''}"
        "${(range != null && range['min'] != null && range['max'] != null) ? " (Range: ${range['min']} - ${range['max']})" : ""}",
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(widget.recipe.image, height: 200, fit: BoxFit.cover),
          const SizedBox(height: 16),

          Text("Ingredients", style: Theme.of(context).textTheme.titleLarge),
          ...widget.recipe.ingredients.map((i) => Text("• $i")),
          const SizedBox(height: 16),

          Text("Instructions", style: Theme.of(context).textTheme.titleLarge),
          ...widget.recipe.instructions.map((i) => Text("• $i")),
          const SizedBox(height: 24),

          Text("Nutrition Info", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : nutrition != null
                  ? Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildNutritionRow(
                              "Calories",
                              nutrition!['calories']?['value'],
                              nutrition!['calories']?['unit'] ?? 'kcal',
                              nutrition!['calories']?['confidenceRange95Percent'],
                            ),
                            buildNutritionRow(
                              "Protein",
                              nutrition!['protein']?['value'],
                              nutrition!['protein']?['unit'] ?? 'g',
                              nutrition!['protein']?['confidenceRange95Percent'],
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
                  : const Text("Nutrition info not available."),
        ],
      ),
    );
  }
}
