import 'package:eco_living_app/screens/eco_tips/EnergyTipDetailScreen.dart';
import 'package:flutter/material.dart';
import '../../services/energy_tip_service.dart';
import '../../models/energy_tip_model.dart';

class EnergyTipsScreen extends StatefulWidget {
  const EnergyTipsScreen({super.key});

  @override
  State<EnergyTipsScreen> createState() => _EnergyTipsScreenState();
}

class _EnergyTipsScreenState extends State<EnergyTipsScreen> {
  final EnergyTipService _service = EnergyTipService();
  List<EnergyTip> _tips = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTips();
  }

  Future<void> loadTips() async {
    final tips = await _service.fetchEnergyTips();
    setState(() {
      _tips = tips;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Energy Saving Tips")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _tips.length,
              itemBuilder: (context, index) {
                final tip = _tips[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(tip.imageUrl, width: 50, height: 50),
                    title: Text(tip.title),
                    subtitle: Text(tip.description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EnergyTipDetailScreen(tip: tip, allTips: _tips),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
