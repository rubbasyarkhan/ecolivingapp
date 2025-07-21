import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/travel_tip_model.dart';
import '../models/travel_option_model.dart';

class EcoTravelFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<TravelTipModel>> fetchTravelTips() async {
    final snapshot = await _db.collection('travelTips').get();
    return snapshot.docs.map((doc) => TravelTipModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<TravelOptionModel>> fetchTravelOptions() async {
    final snapshot = await _db.collection('travelOptions').get();
    return snapshot.docs.map((doc) => TravelOptionModel.fromMap(doc.data(), doc.id)).toList();
  }

  Future<void> saveTip(String userId, String tipId) async {
    await _db.collection('savedTips').add({
      'userId': userId,
      'tipId': tipId,
      'markedAt': Timestamp.now(),
    });
  }
}