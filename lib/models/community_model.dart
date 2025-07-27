import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  final String id;
  final String name;
  final String description;
  final DateTime? createdAt;

  Community({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
  });

  factory Community.fromJson(Map<String, dynamic> json, String id) {
    return Community(
      id: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
