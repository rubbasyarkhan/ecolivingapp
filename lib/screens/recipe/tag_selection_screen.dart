import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'recipe_list_screen.dart';
import '../../services/recipe_service.dart';

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
        SetOptions(merge: true), // merge with existing user data
      );
    }
  }

  Future<void> _proceed() async {
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_tags', selectedTags);

    // Save to Firestore
    await _saveTagsToFirestore(selectedTags);

    // Navigate to recipe list
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RecipeListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Food Preferences")),
      body: allTags.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: allTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return ListTile(
                  title: Text(tag),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                  onTap: () => _toggleTag(tag),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selectedTags.length >= 5 ? _proceed : null,
        label: const Text("Show Recipes"),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
