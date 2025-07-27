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

  @override
  void initState() {
    super.initState();
    _loadGroupedContent();
  }

  Future<void> _loadGroupedContent() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('educational_contents').get();

      final contents = snapshot.docs
          .map((doc) => EducationalContent.fromJson(doc.data(), doc.id))
          .toList();

      final Map<String, List<EducationalContent>> grouped = {};
      for (var content in contents) {
        final category =
            content.category.isNotEmpty ? content.category : 'Uncategorized';
        grouped.putIfAbsent(category, () => []).add(content);
      }

      if (!mounted) return; // ✅ Prevent setState if widget is disposed

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Educational Content"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groupedContent.isEmpty
              ? const Center(child: Text("No educational content found."))
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: _groupedContent.entries.map((entry) {
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.folder_special_rounded,
                            color: Colors.green.shade700),
                        title: Text(entry.key.toUpperCase(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${entry.value.length} item(s)"),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
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
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
