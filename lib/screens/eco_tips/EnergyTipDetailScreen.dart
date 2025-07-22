import 'package:flutter/material.dart';
import '../../models/energy_tip_model.dart';

class EnergyTipDetailScreen extends StatelessWidget {
  final EnergyTip tip;
  final List<EnergyTip> allTips;

  const EnergyTipDetailScreen({
    Key? key,
    required this.tip,
    required this.allTips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moreTips = allTips.where((t) => t != tip).take(3).toList();

    return Scaffold(
      appBar: AppBar(title: Text(tip.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              tip.imageUrl,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  // const SizedBox(height: 8),
                  // Chip(
                  //   label: Text(tip.category),
                  //   backgroundColor: Colors.green.shade100,
                  // ),
                  const SizedBox(height: 16),
                  Text(
                    tip.description * 3, // Multiply for a longer body feel
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "More Energy Tips",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...moreTips.map(
                    (t) => ListTile(
                      leading: Image.network(t.imageUrl, width: 50, height: 50),
                      title: Text(t.title),
                      subtitle: Text(t.description),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EnergyTipDetailScreen(
                              tip: t,
                              allTips: allTips,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
