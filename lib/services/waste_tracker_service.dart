import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/waste_log_model.dart';

class WasteTrackerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Add a new waste log with ID stored in the document
  Future<void> addWasteLog(WasteLog log) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('waste_logs')
          .doc(); // Auto-generate ID

      final newLog = log.copyWith(
        id: docRef.id,
        userId: uid,
      );

      await docRef.set(newLog.toJson());
    } catch (e) {
      print('Error adding waste log: $e');
      rethrow;
    }
  }

  // ✅ Fetch all logs, with optional date filtering
  Future<List<WasteLog>> fetchWasteLogs({DateTime? startDate, DateTime? endDate}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    try {
      Query query = _firestore
          .collection('users')
          .doc(uid)
          .collection('waste_logs')
          .orderBy('date', descending: true);

      if (startDate != null && endDate != null) {
        query = query
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      final snapshot = await query.get();

      return snapshot.docs
          .map((doc) => WasteLog.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching waste logs: $e');
      return [];
    }
  }

  // ✅ Delete a log by its Firestore document ID
  Future<void> deleteWasteLog(String logId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('waste_logs')
          .doc(logId)
          .delete();
    } catch (e) {
      print('Error deleting waste log: $e');
      rethrow;
    }
  }
}
