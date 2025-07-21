import 'package:eco_living_app/screens/eco_travel/saved_tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelTipsScreen extends StatelessWidget {
  const TravelTipsScreen({super.key});

  Future<void> _saveTip(Map<String, dynamic> tip) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Travel Tips'),
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
        stream: FirebaseFirestore.instance
            .collection('eco_travel_tips')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No travel tips found."));
          }

          final tips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(tip['title'] ?? 'Travel Tip'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tip['imageUrl'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    tip['imageUrl'],
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const SizedBox(height: 12),
                              Text(
                                tip['description'] ?? 'No description provided.',
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
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
                        : const Icon(Icons.eco, size: 40, color: Colors.green),
                    title: Text(
                      tip['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      (tip['description']?.toString().length ?? 0) > 50
                          ? '${tip['description'].toString().substring(0, 50)}...'
                          : tip['description'] ?? '',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_add_outlined),
                      onPressed: () async {
                        await _saveTip(tip);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tip saved!')),
                        );
                      },
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
