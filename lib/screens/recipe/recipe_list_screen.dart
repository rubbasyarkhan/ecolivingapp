import 'package:eco_living_app/screens/widgets/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/recipe_model.dart';
import '../../services/recipe_service.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> filteredRecipes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedTags = prefs.getStringList('user_tags') ?? [];
    final recipes = await RecipeService.fetchAllRecipes();

    final filtered = recipes.where((recipe) =>
      recipe.tags.any((tag) => selectedTags.contains(tag))).toList();

    setState(() {
      filteredRecipes = filtered;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Recipes")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
