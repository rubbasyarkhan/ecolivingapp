import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_living_app/models/waste_log_model.dart';
import 'package:eco_living_app/services/waste_tracker_service.dart';
import 'package:eco_living_app/constants/colors.dart'; // ✅ Make sure AppColors is here

class WasteTrackerInputScreen extends StatefulWidget {
  @override
  State<WasteTrackerInputScreen> createState() => _WasteTrackerInputScreenState();
}

class _WasteTrackerInputScreenState extends State<WasteTrackerInputScreen> {
  final _formKey = GlobalKey<FormState>();
  WasteCategory _selectedCategory = WasteCategory.recycling;
  String _method = '';
  int _quantity = 1;
  bool _loading = false;

  final List<String> _units = ['items', 'bags', 'kg', 'liters'];
  String _selectedUnit = 'items';

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
      unit: _selectedUnit,
      date: DateTime.now(),
    );

    try {
      await WasteTrackerService().addWasteLog(newLog);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Log submitted successfully!')),
      );

      setState(() {
        _quantity = 1;
        _method = '';
        _selectedCategory = WasteCategory.recycling;
        _selectedUnit = 'items';
        _formKey.currentState!.reset();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text("Log Waste Reduction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          
          
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    "Help the planet by logging your sustainable actions.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<WasteCategory>(
                    value: _selectedCategory,
                    items: WasteCategory.values
                        .where((cat) => cat != WasteCategory.other)
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.name[0].toUpperCase() + cat.name.substring(1)),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCategory = val!),
                    decoration: InputDecoration(
                      labelText: 'Waste Category',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    initialValue: '1',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity Reduced',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) {
                      final num = int.tryParse(val!);
                      if (num == null || num <= 0) return 'Enter a valid quantity';
                      return null;
                    },
                    onChanged: (val) => _quantity = int.tryParse(val) ?? 1,
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    items: _units
                        .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedUnit = val!),
                    decoration: InputDecoration(
                      labelText: 'Unit',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Method Used',
                      hintText: 'e.g. Reused cloth bag, composted food',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (val) =>
                        (val == null || val.trim().isEmpty) ? 'Please enter a method' : null,
                    onChanged: (val) => _method = val.trim(),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.highlight,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(_loading ? "Saving..." : "Submit Log"),
                      onPressed: _loading ? null : _submitLog,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
