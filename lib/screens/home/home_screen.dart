import 'package:eco_living_app/screens/widgets/app_drawer.dart';
import 'package:eco_living_app/screens/widgets/carbon_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:eco_living_app/services/waste_tracker_service.dart';
import 'package:eco_living_app/models/waste_log_model.dart';
import 'package:eco_living_app/screens/widgets/waste_stat_chart.dart';
// import 'package:eco_living_app/screens/widgets/carbon_summary_chart.dart'; // assuming this exists

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<WasteLog> _allLogs = [];
  List<WasteLog> _todayLogs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final logs = await WasteTrackerService().fetchWasteLogs();
      final now = DateTime.now();

      final todayLogs = logs.where((log) =>
          log.date.year == now.year &&
          log.date.month == now.month &&
          log.date.day == now.day).toList();

      if (!mounted) return;

      setState(() {
        _allLogs = logs;
        _todayLogs = todayLogs;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Error loading logs: ${e.toString()}";
        _loading = false;
      });
    }
  }

  int getTotalTodayItems() {
    return _todayLogs.fold(0, (sum, log) => sum + log.quantity);
  }

  String getMotivationalMessage(int totalToday) {
    if (totalToday == 0) return "Let's start making an impact today!";
    if (totalToday < 5) return "Good job! Every little effort counts. 🌱";
    if (totalToday < 10) return "You're making real progress! 🌿";
    return "Amazing! You're a true waste reduction hero! 💚";
  }

  @override
  Widget build(BuildContext context) {
    final todayTotal = getTotalTodayItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eco Living Dashboard"),
      ),
      drawer: const AppDrawer(username: '',),
        
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Waste Reduction Section
                      const Text(
                        "Waste Reduction Stats",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      WasteStatChart(logs: _allLogs),
                      const SizedBox(height: 8),
                      Card(
                        color: Colors.teal.shade50,
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.emoji_emotions, color: Colors.teal),
                          title: Text(getMotivationalMessage(todayTotal)),
                          subtitle: Text("You reduced $todayTotal item(s) today."),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Carbon Summary Section
                      const Text(
                        "Carbon Footprint Summary",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const CarbonSummaryCard(), // Replace with your actual chart widget
                    ],
                  ),
                ),
    );
  }
}
