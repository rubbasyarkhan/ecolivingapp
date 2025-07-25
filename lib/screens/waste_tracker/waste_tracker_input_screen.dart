import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_living_app/models/waste_log_model.dart';
import 'package:eco_living_app/services/waste_tracker_service.dart';

class WasteTrackerInputScreen extends StatefulWidget {
  @override
  _WasteTrackerInputScreenState createState() => _WasteTrackerInputScreenState();
}

class _WasteTrackerInputScreenState extends State<WasteTrackerInputScreen> {
  final _formKey = GlobalKey<FormState>();
  WasteCategory _selectedCategory = WasteCategory.recycling;
  String _method = '';
  int _quantity = 1;
  bool _loading = false;

  // ✅ Unit selection
  final List<String> _units = ['items', 'bags', 'kg', 'liters'];
  String _selectedUnit = 'items';

  final List<DropdownMenuItem<WasteCategory>> _categoryItems = WasteCategory.values
      .where((cat) => cat != WasteCategory.other)
      .map((cat) {
    return DropdownMenuItem(
      value: cat,
      child: Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
    );
  }).toList();

  Future<void> _submitLog() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      setState(() => _loading = false);
      return;
    }

    final newLog = WasteLog(
      id: '',
      userId: user.uid,
      category: _selectedCategory,
      method: _method,
      quantity: _quantity,
      unit: _selectedUnit, // ✅ Save selected unit
      date: DateTime.now(),
    );

    try {
      await WasteTrackerService().addWasteLog(newLog);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waste log submitted successfully!')),
      );

      setState(() {
        _quantity = 1;
        _method = '';
        _selectedCategory = WasteCategory.recycling;
        _selectedUnit = 'items';
      });

      _formKey.currentState!.reset();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting log: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Waste Reduction Log")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ✅ Description block
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  "Track your daily waste reduction efforts. Select the waste type, describe your method "
                  "(e.g., reused a cloth bag), choose how much you reduced, and in what unit.",
                  style: TextStyle(fontSize: 14.5, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<WasteCategory>(
                value: _selectedCategory,
                items: _categoryItems,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Waste Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '1',
                decoration: const InputDecoration(
                  labelText: 'Quantity Reduced',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  final num = int.tryParse(val!);
                  if (num == null || num <= 0) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
                onChanged: (val) => _quantity = int.tryParse(val) ?? 1,
              ),
              const SizedBox(height: 16),

              // ✅ Unit selector
              DropdownButtonFormField<String>(
                value: _selectedUnit,
                items: _units
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedUnit = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Method Used (e.g. cloth bag, composted food waste)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a method';
                  }
                  return null;
                },
                onChanged: (val) => _method = val.trim(),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.save),
                label: Text(_loading ? 'Saving...' : 'Submit Log'),
                onPressed: _loading ? null : _submitLog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
