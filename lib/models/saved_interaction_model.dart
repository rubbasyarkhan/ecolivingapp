import 'package:cloud_firestore/cloud_firestore.dart';

class SavedTipModel {
  final String userId;
  final String tipId;
  final DateTime markedAt;

  SavedTipModel({
    required this.userId,
    required this.tipId,
    required this.markedAt,
  });

  factory SavedTipModel.fromMap(Map<String, dynamic> map) {
    return SavedTipModel(
      userId: map['userId'],
      tipId: map['tipId'],
      markedAt: (map['markedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tipId': tipId,
      'markedAt': markedAt,
    };
  }
}