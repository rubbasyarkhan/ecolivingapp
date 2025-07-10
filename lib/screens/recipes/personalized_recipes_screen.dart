import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalizedRecipesScreen extends StatefulWidget {
  const PersonalizedRecipesScreen({super.key});

  @override
  State<PersonalizedRecipesScreen> createState() =>
      _PersonalizedRecipesScreenState();
}

class _PersonalizedRecipesScreenState extends State<PersonalizedRecipesScreen> {
  List recipes = [];
  bool loading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        loading = false;
        errorMessage = "User not signed in.";
      });
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final prefs = List<String>.from(snapshot['preferences'] ?? []);

      if (prefs.isEmpty) {
        setState(() {
          loading = false;
          errorMessage = "No preferences found.";
        });
        return;
      }

      final cuisinePrefs = prefs
          .where(
            (e) => ![
              "Vegan",
              "Vegetarian",
              "Keto",
              "Paleo",
              "Gluten Free",
              "Low FODMAP",
            ].contains(e),
          )
          .join(",");

      final dietPref = prefs.firstWhere(
        (e) => [
          "Vegan",
          "Vegetarian",
          "Keto",
          "Paleo",
          "Gluten Free",
          "Low FODMAP",
        ].contains(e),
        orElse: () => "",
      );

      final uri = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch'
        '?apiKey=fe499f278150484c8d1f795b5e8603f0'
        '&number=10'
        '&addRecipeInformation=true'
        '&cuisine=$cuisinePrefs'
        '&diet=$dietPref',
      );

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        setState(() {
          loading = false;
          errorMessage = "Failed to fetch recipes: ${response.statusCode}";
        });
        return;
      }

      final data = jsonDecode(response.body);

      setState(() {
        recipes = data['results'] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Recipes")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : recipes.isEmpty
          ? const Center(child: Text("No recipes found."))
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                final imageUrl = recipe['image'] ?? '';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 60,
                                height: 60,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(recipe['title'] ?? 'No title'),
                    subtitle: Text(
                      "Ready in ${recipe['readyInMinutes'] ?? 'N/A'} mins",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
