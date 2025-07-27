import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedCommunities() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> communities = [
    {
      'id': 'waste_reduction',
      'name': 'Waste Reduction',
      'description': 'Share tips and stories on reducing waste and plastic use.',
    },
    {
      'id': 'eco_travel',
      'name': 'Eco Travel',
      'description': 'Sustainable travel ideas, carpooling, cycling, and more.',
    },
    {
      'id': 'green_energy',
      'name': 'Green Energy',
      'description': 'Solar panels, renewable energy and clean tech discussions.',
    },
    {
      'id': 'sustainable_eating',
      'name': 'Sustainable Eating',
      'description': 'Plant-based diets, organic food, and ethical consumption.',
    },
    {
      'id': 'minimalist_living',
      'name': 'Minimalist Living',
      'description': 'Living with less and reducing environmental impact.',
    },
    {
      'id': 'upcycling_diy',
      'name': 'Upcycling & DIY',
      'description': 'Creative upcycling and do-it-yourself sustainability ideas.',
    },
  ];

  for (final community in communities) {
    final docRef = firestore.collection('communities').doc(community['id']);
    await docRef.set({
      'name': community['name'],
      'description': community['description'],
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('Created community: ${community['name']}');
  }

  print('✅ All communities have been created.');
}
