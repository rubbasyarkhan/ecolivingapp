import 'package:eco_living_app/constants/colors.dart';
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
      backgroundColor: AppColors.background, // Set the background color
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Use primary color for the app bar
        title: const Text(
          "Energy Saving Tips",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: ListView.builder(
                itemCount: _tips.length,
                itemBuilder: (context, index) {
                  final tip = _tips[index];
                  return Card(
                    elevation: 5, // Add some elevation to the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Rounded corners
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.card, // Use card color from AppColors
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Round the image
                        child: Image.network(
                          tip.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        tip.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.text, // Use text color for title
                        ),
                      ),
                      subtitle: Text(
                        tip.description,
                        style: TextStyle(
                          color: AppColors.text.withOpacity(0.7), // Slightly lighter text
                        ),
                        overflow: TextOverflow.ellipsis, // Handle long text gracefully
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EnergyTipDetailScreen(
                              tip: tip,
                              allTips: _tips,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
