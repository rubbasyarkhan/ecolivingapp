import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final List<String>? images; // List of base64 strings
  final String userId;
  final String communityId;
  final DateTime? createdAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.userId,
    required this.communityId,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      userId: json['userId'] ?? '',
      communityId: json['communityId'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'images': images ?? [],
      'userId': userId,
      'communityId': communityId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
