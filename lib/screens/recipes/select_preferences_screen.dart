import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import '../../models/recipe_tag.dart';
import '../../widgets/tag_chip.dart';
import '../../routes/app_routes.dart';

class SelectPreferencesScreen extends StatefulWidget {
  const SelectPreferencesScreen({super.key});

  @override
  State<SelectPreferencesScreen> createState() => _SelectPreferencesScreenState();
}

class _SelectPreferencesScreenState extends State<SelectPreferencesScreen> {
  final List<String> selected = [];
  final List<String> tags = [
    "Indian", "Italian", "Chinese", "Mexican", "Thai",
    "Vegan", "Vegetarian", "Keto", "Paleo", "Low FODMAP", "Gluten Free"
  ];

  void toggleTag(String tag) {
    setState(() {
      if (selected.contains(tag)) {
        selected.remove(tag);
      } else {
        if (selected.length < 5) {
          selected.add(tag);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You can select up to 5 preferences.")),
          );
        }
      }
    });
  }

  Future<void> savePreferences() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'preferences': selected}, SetOptions(merge: true));

      Navigator.pushReplacementNamed(context, AppRoutes.personalizedRecipes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Food Preferences")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Choose up to 5 preferences", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                return TagChip(
                  label: tag,
                  selected: selected.contains(tag),
                  onTap: () => toggleTag(tag),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: selected.isNotEmpty ? savePreferences : null,
              child: const Text("Save Preferences"),
            )
          ],
        ),
      ),
    );
  }
}
