import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/educational_content_model.dart';

class EducationalContentService {
  final CollectionReference<EducationalContent> _contentRef =
      FirebaseFirestore.instance
          .collection('educational_content')
          .withConverter<EducationalContent>(
            fromFirestore: (snapshot, _) =>
                EducationalContent.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (content, _) => content.toJson(),
          );

  /// Fetch all content (optionally filtered by type or category)
  Future<List<EducationalContent>> fetchContent({
    String? type,       // 'video', 'article', 'infographic'
    String? category,   // e.g., 'Waste Reduction'
  }) async {
    try {
      Query<EducationalContent> query = _contentRef
          .orderBy('publishedAt', descending: true);

      if (type != null && type.isNotEmpty) {
        query = query.where('type', isEqualTo: type);
      }

      if (category != null && category.isNotEmpty) {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching educational content: $e");
      return [];
    }
  }

  /// Fetch a single content item by ID
  Future<EducationalContent?> fetchContentById(String id) async {
    try {
      final doc = await _contentRef.doc(id).get();
      return doc.data();
    } catch (e) {
      print("Error fetching content by ID: $e");
      return null;
    }
  }

  /// Fetch all distinct categories for displaying on list screen
  Future<List<String>> fetchCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('educational_content')
          .get();

      final allCategories = snapshot.docs
          .map((doc) => (doc.data()['category'] ?? '').toString().trim())
          .where((cat) => cat.isNotEmpty)
          .toSet()
          .toList();

      allCategories.sort(); // Optional: sort alphabetically
      return allCategories;
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
}
