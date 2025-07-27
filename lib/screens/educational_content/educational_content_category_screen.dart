import 'package:flutter/material.dart';
import 'package:eco_living_app/models/educational_content_model.dart';
import 'package:eco_living_app/screens/widgets/educational_content_card.dart';
import 'educational_content_detail_screen.dart';

class EducationalContentCategoryScreen extends StatelessWidget {
  final String category;
  final List<EducationalContent> contents;

  const EducationalContentCategoryScreen({
    Key? key,
    required this.category,
    required this.contents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.toUpperCase()),
      ),
      body: contents.isEmpty
          ? const Center(
              child: Text(
                "No content found in this category.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: contents.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final content = contents[index];
                return EducationalContentCard(
                  content: content,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EducationalContentDetailScreen(content: content),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
