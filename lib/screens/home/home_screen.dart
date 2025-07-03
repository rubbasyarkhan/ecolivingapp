import 'package:flutter/material.dart';
import '../../routes/app_routes.dart'; // Make sure profile route is defined

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String profileImageUrl =
      "https://i.pravatar.cc/150?img=3"; // Replace with Firebase image later

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eco Living",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome to the Home Screen 🌿",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
