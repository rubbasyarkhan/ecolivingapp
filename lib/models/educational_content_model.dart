import 'package:cloud_firestore/cloud_firestore.dart';

class EducationalContent {
  final String id;
  final String title;
  final String type; // 'video', 'article', or 'infographic'
  final String description;
  final String category;
  final String contentUrl;
  final String thumbnail; // optional: for video/image previews
  final DateTime publishedAt;

  EducationalContent({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.category,
    required this.contentUrl,
    required this.thumbnail,
    required this.publishedAt,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json, String id) {
    return EducationalContent(
      id: id,
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      contentUrl: json['contentUrl'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      publishedAt: (json['publishedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'description': description,
      'category': category,
      'contentUrl': contentUrl,
      'thumbnail': thumbnail,
      'publishedAt': Timestamp.fromDate(publishedAt),
    };
  }
}
