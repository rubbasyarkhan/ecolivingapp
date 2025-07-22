import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/energy_tip_model.dart';

class EnergyTipService {
  Future<List<EnergyTip>> fetchEnergyTips() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('energy_tips')
          .get();

      return snapshot.docs.map((doc) {
        return EnergyTip.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching energy tips: $e');
      return [];
    }
  }
}
