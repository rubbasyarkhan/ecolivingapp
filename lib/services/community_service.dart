import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/community_model.dart';

class CommunityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all communities
  Future<List<Community>> fetchCommunities() async {
    final snapshot = await _firestore.collection('communities').get();
    return snapshot.docs
        .map((doc) => Community.fromJson(doc.data(), doc.id))
        .toList();
  }

  // Subscribe to a community
  Future<void> subscribeToCommunity(String userId, String communityId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.set({
      'subscriptions': FieldValue.arrayUnion([communityId])
    }, SetOptions(merge: true));
  }

  // Unsubscribe from a community
  Future<void> unsubscribeFromCommunity(String userId, String communityId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'subscriptions': FieldValue.arrayRemove([communityId])
    });
  }

  // Get subscribed community IDs
  Future<List<String>> getUserSubscriptions(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final data = userDoc.data();
    if (data != null && data['subscriptions'] != null) {
      return List<String>.from(data['subscriptions']);
    }
    return [];
  }
}
