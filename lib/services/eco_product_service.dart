import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/eco_product.dart';

class EcoProductService {
  final _collection = FirebaseFirestore.instance.collection('eco_friendly_products');

  Future<List<EcoProduct>> fetchAllProducts() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => EcoProduct.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<EcoProduct> getProductById(String id) async {
    final doc = await _collection.doc(id).get();
    return EcoProduct.fromJson(doc.data()!, doc.id);
  }
}
