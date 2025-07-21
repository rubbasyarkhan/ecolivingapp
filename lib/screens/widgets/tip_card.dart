import 'package:flutter/material.dart';
import '../../../../models/travel_tip_model.dart';

class TipCard extends StatelessWidget {
  final TravelTipModel tip;

  const TipCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(tip.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(tip.title),
        subtitle: Text(tip.description),
        trailing: Icon(Icons.eco, color: Colors.green),
      ),
    );
  }
}
