import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eco_living_app/models/educational_content_model.dart';
import 'educational_content_category_screen.dart';

class EducationalContentListScreen extends StatefulWidget {
  const EducationalContentListScreen({Key? key}) : super(key: key);

  @override
  State<EducationalContentListScreen> createState() =>
      _EducationalContentListScreenState();
}

class _EducationalContentListScreenState
    extends State<EducationalContentListScreen> {
  Map<String, List<EducationalContent>> _groupedContent = {};
  bool _isLoading = true;

  final List<Color> _cardColors = [
    Colors.teal.shade300,
    Colors.indigo.shade400,
    Colors.orange.shade300,
    Colors.pink.shade300,
    Colors.deepPurple.shade300,
    Colors.green.shade400,
    Colors.cyan.shade400,
    Colors.amber.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _loadGroupedContent();
  }

  Future<void> _loadGroupedContent() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('educational_contents')
          .get();

      final contents = snapshot.docs
          .map((doc) => EducationalContent.fromJson(doc.data(), doc.id))
          .toList();

      final Map<String, List<EducationalContent>> grouped = {};
      for (var content in contents) {
        final category =
            content.category.isNotEmpty ? content.category : 'Uncategorized';
        grouped.putIfAbsent(category, () => []).add(content);
      }

      if (!mounted) return;

      setState(() {
        _groupedContent = grouped;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Error loading educational content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = _groupedContent.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Educational Content"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? const Center(child: Text("No educational content found."))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1 / 2, // Increased card height (taller cards)
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final entry = categories[index];
                      final color = _cardColors[index % _cardColors.length];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EducationalContentCategoryScreen(
                                category: entry.key,
                                contents: entry.value,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.folder_special_rounded,
                                  color: Colors.white, size: 28),
                              Text(
                                entry.key.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "${entry.value.length} item(s)",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
