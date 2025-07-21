import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/travel_option_model.dart';

class OptionCard extends StatelessWidget {
  final TravelOptionModel option;

  const OptionCard({super.key, required this.option});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(option.title),
        subtitle: Text(option.description),
        trailing: Text('${option.co2SavingEstimate} kg CO₂'),
        onTap: () => _launchURL(option.link),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
