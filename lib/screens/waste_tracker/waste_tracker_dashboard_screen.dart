import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eco_living_app/constants/colors.dart';
import 'package:eco_living_app/models/waste_log_model.dart';
import 'package:eco_living_app/services/waste_tracker_service.dart';
import 'package:eco_living_app/screens/widgets/waste_log_card.dart';
import 'package:eco_living_app/screens/widgets/waste_stat_chart.dart';

class WasteTrackerDashboardScreen extends StatefulWidget {
  @override
  _WasteTrackerDashboardScreenState createState() =>
      _WasteTrackerDashboardScreenState();
}

class _WasteTrackerDashboardScreenState
    extends State<WasteTrackerDashboardScreen> {
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Waste Reduction Dashboard'),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/waste/input');
        },
        backgroundColor: AppColors.highlight,
        icon: const Icon(Icons.add),
        label: const Text('Log Waste Effort'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadLogs,
                  child: _allLogs.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              "No waste reduction logs yet.\nStart tracking your efforts today!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Waste Reduction Stats",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 8),

                              /// Chart
                              WasteStatChart(logs: _allLogs),
                              const SizedBox(height: 16),

                              /// Motivational Card
                              Card(
                                color: AppColors.card,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                child: ListTile(
                                  leading: Icon(Icons.emoji_emotions,
                                      color: AppColors.primary, size: 32),
                                  title: Text(
                                    getMotivationalMessage(todayTotal),
                                    style: TextStyle(
                                      color: AppColors.text,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "You reduced $todayTotal item(s) today.",
                                    style: TextStyle(color: AppColors.text.withOpacity(0.7)),
                                  ),
                                ),
                              ),

                              if (_todayLogs.isNotEmpty) ...[
                                Text(
                                  "Today's Waste Reduction Logs",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.text,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ..._todayLogs.map((log) => WasteLogCard(log: log)).toList(),
                                const SizedBox(height: 24),
                              ],

                              Text(
                                "All Your Waste Logs",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._allLogs.map((log) => WasteLogCard(log: log)).toList(),
                            ],
                          ),
                        ),
                ),
    );
  }
}
