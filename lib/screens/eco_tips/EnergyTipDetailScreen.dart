import 'package:eco_living_app/constants/colors.dart';
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
      backgroundColor: AppColors.background, // Set the background color
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Use the primary color for the app bar
        title: Text(
          tip.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image at the top with a smooth border radius and shadow
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Image.network(
                tip.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with a bold and large font size
                  Text(
                    tip.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Description Text
                  Text(
                    tip.description * 3, // Multiply for a longer body feel
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: AppColors.text.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // More Tips Section Title
                  Text(
                    "More Energy Tips",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // List of more tips
                  ...moreTips.map(
                    (t) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: AppColors.card,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            t.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          t.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                        subtitle: Text(
                          t.description,
                          style: TextStyle(
                            color: AppColors.text.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
