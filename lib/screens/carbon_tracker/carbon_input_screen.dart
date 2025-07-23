import 'package:flutter/material.dart';
import 'carbon_result_screen.dart';

class CarbonInputScreen extends StatefulWidget {
  @override
  _CarbonInputScreenState createState() => _CarbonInputScreenState();
}

class _CarbonInputScreenState extends State<CarbonInputScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedCategory = 'Transportation';

  // Inputs
  String _transportMode = 'car';
  double _distanceKm = 0;

  double _electricityKwh = 0;
  double _gasTherms = 0;

  String _dietType = 'omnivore';

  double calculateCo2() {
    switch (_selectedCategory) {
      case 'Transportation':
        return _distanceKm * _getTransportFactor(_transportMode);
      case 'Electricity':
        return _electricityKwh * 0.5;
      case 'Gas':
        return _gasTherms * 5.3;
      case 'Food':
        return _getDietFactor(_dietType);
      default:
        return 0;
    }
  }

  double _getTransportFactor(String mode) {
    switch (mode) {
      case 'bus':
        return 0.1;
      case 'bike':
      case 'walk':
        return 0.0;
      case 'train':
        return 0.05;
      case 'car':
      default:
        return 0.21;
    }
  }

  double _getDietFactor(String type) {
    switch (type) {
      case 'vegan':
        return 2.0;
      case 'vegetarian':
        return 3.0;
      case 'omnivore':
      default:
        return 5.0;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final totalCo2 = calculateCo2();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CarbonResultScreen(
            co2Kg: totalCo2,
            category: _selectedCategory,
            transportMode: _transportMode,
            distanceKm: _distanceKm,
            electricityKwh: _electricityKwh,
            gasTherms: _gasTherms,
            dietType: _dietType,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Carbon Footprint Input")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Transportation', 'Electricity', 'Gas', 'Food']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategory = val!;
                  });
                },
                decoration: InputDecoration(labelText: 'Select Category'),
              ),
              const SizedBox(height: 16),

              if (_selectedCategory == 'Transportation') ...[
                DropdownButtonFormField<String>(
                  value: _transportMode,
                  items: ['car', 'bus', 'train', 'bike', 'walk']
                      .map((mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _transportMode = val!),
                  decoration: InputDecoration(labelText: 'Transport Mode'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Distance (km)'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) =>
                      _distanceKm = double.tryParse(val ?? '0') ?? 0,
                ),
              ],
              if (_selectedCategory == 'Electricity')
                TextFormField(
                  decoration: InputDecoration(labelText: 'Electricity Usage (kWh)'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) =>
                      _electricityKwh = double.tryParse(val ?? '0') ?? 0,
                ),
              if (_selectedCategory == 'Gas')
                TextFormField(
                  decoration: InputDecoration(labelText: 'Gas Usage (therms)'),
                  keyboardType: TextInputType.number,
                  onSaved: (val) =>
                      _gasTherms = double.tryParse(val ?? '0') ?? 0,
                ),
              if (_selectedCategory == 'Food')
                DropdownButtonFormField<String>(
                  value: _dietType,
                  items: ['omnivore', 'vegetarian', 'vegan']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _dietType = val!),
                  decoration: InputDecoration(labelText: 'Diet Type'),
                ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Calculate Carbon Footprint"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
