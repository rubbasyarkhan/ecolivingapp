import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/eco_product.dart';
import '../../models/energy_tip_model.dart';
import '../../models/community_model.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  List<EcoProduct> ecoProducts = [];
  List<EnergyTip> energyTips = [];
  List<Community> communityPosts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (userId == null) return;

    try {
      final ecoProductsSnapshot = await FirebaseFirestore.instance
          .collection('eco_products')
          .where('userId', isEqualTo: userId)
          .get();

      final energyTipsSnapshot = await FirebaseFirestore.instance
          .collection('energy_tips')
          .where('userId', isEqualTo: userId)
          .get();

      final communitySnapshot = await FirebaseFirestore.instance
          .collection('community_posts')
          .where('userId', isEqualTo: userId)
          .get();

      setState(() {
        ecoProducts = ecoProductsSnapshot.docs
            .map((doc) => EcoProduct.fromJson(doc.data(), doc.id))
            .toList();

        energyTips = energyTipsSnapshot.docs
            .map((doc) => EnergyTip.fromJson(doc.data(), doc.id))
            .toList();

        communityPosts = communitySnapshot.docs
            .map((doc) => Community.fromJson(doc.data(), doc.id)) // ✅ fixed here
            .toList();

        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading dashboard data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Dashboard")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Eco Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...ecoProducts.map((product) => ListTile(
                        title: Text(product.name),
                        subtitle: Text(product.description),
                      )),
                  const Divider(),

                  const Text("Energy Tips", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...energyTips.map((tip) => ListTile(
                        title: Text(tip.title),
                        subtitle: Text(tip.description),
                      )),
                  const Divider(),

                  const Text("Community Posts", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...communityPosts.map((post) => ListTile(
                        title: Text(post.name), // ✅ fixed here
                        subtitle: Text(post.description),
                      )),
                ],
              ),
            ),
    );
  }
}
