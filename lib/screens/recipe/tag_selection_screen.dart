import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'recipe_list_screen.dart';
import '../../services/recipe_service.dart';
import '../../constants/colors.dart'; // for AppColors

class TagSelectionScreen extends StatefulWidget {
  const TagSelectionScreen({super.key});

  @override
  State<TagSelectionScreen> createState() => _TagSelectionScreenState();
}

class _TagSelectionScreenState extends State<TagSelectionScreen> {
  List<String> allTags = [];
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final recipes = await RecipeService.fetchAllRecipes();
    final Set<String> tagsSet = {};
    for (var recipe in recipes) {
      tagsSet.addAll(recipe.tags);
    }
    setState(() {
      allTags = tagsSet.toList();
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
    });
  }

  Future<void> _saveTagsToFirestore(List<String> tags) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'selectedRecipeTags': tags,
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<void> _proceed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_tags', selectedTags);
    await _saveTagsToFirestore(selectedTags);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RecipeListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Select Your Food Preferences"),
        foregroundColor: Colors.white,
      ),
      body: allTags.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Choose at least 5 tags that match your food preferences. These will help us show recipes you'll love!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: allTags.length,
                    itemBuilder: (context, index) {
                      final tag = allTags[index];
                      final isSelected = selectedTags.contains(tag);
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        color: isSelected
                            ? AppColors.secondary.withOpacity(0.15)
                            : Colors.white,
                        child: ListTile(
                          title: Text(tag),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: AppColors.primary)
                              : const Icon(Icons.circle_outlined,
                                  color: Colors.grey),
                          onTap: () => _toggleTag(tag),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: selectedTags.length >= 5
            ? AppColors.primary
            : Colors.grey,
        onPressed: selectedTags.length >= 5 ? _proceed : null,
        label: const Text("Show Recipes"),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
