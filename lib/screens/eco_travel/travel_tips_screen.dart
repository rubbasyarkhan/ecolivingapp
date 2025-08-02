import 'package:eco_living_app/constants/colors.dart';
import 'package:eco_living_app/screens/eco_travel/saved_tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelTipsScreen extends StatelessWidget {
  const TravelTipsScreen({super.key});

  Future<void> _saveTip(Map<String, dynamic> tip, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userSavedTipsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('saved_tips');

    await userSavedTipsRef.add({
      'title': tip['title'],
      'description': tip['description'],
      'imageUrl': tip['imageUrl'],
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🌱 Tip saved successfully!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Eco Travel Tips'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            tooltip: 'View Saved Tips',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedTipsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('eco_travel_tips').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No travel tips found.",
                style: TextStyle(fontSize: 16, color: AppColors.text),
              ),
            );
          }

          final tips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tips.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final tip = tips[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                color: AppColors.card,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          tip['title'] ?? 'Travel Tip',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tip['imageUrl'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    tip['imageUrl'],
                                    height: 160,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                tip['description'] ?? 'No description provided.',
                                style: const TextStyle(fontSize: 15, color: AppColors.text),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    leading: tip['imageUrl'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              tip['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.eco, size: 40, color: AppColors.primary),
                    title: Text(
                      tip['title'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    subtitle: Text(
                      (tip['description']?.toString().length ?? 0) > 60
                          ? '${tip['description'].toString().substring(0, 60)}...'
                          : tip['description'] ?? '',
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_add_outlined, color: AppColors.highlight),
                      tooltip: "Save Tip",
                      onPressed: () => _saveTip(tip, context),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
