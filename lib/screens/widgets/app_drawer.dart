import 'dart:convert';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';

class AppDrawer extends StatefulWidget {
  final String username;

  const AppDrawer({super.key, required this.username});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: isExpanded ? 280 : 90,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Logo and Toggle Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: isExpanded
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (isExpanded)
                  Row(
                    children: [
                      Image.asset(
                        'logo.png',
                        width:
                            MediaQuery.of(context).size.width *
                            0.4, // 40% of the screen width
                        height:
                            MediaQuery.of(context).size.width *
                            0.4, // 40% of the screen width
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Top Tabs

          // Main Menu List
          Expanded(
            child: ListView(
              children: [
                _drawerItem(Icons.home, "Home", AppRoutes.home),
                _drawerItem(Icons.person, "Profile", AppRoutes.profile),
                ExpansionTile(
                  leading: Icon(Icons.restaurant_menu),
                  title: Text("Recipes"),
                  childrenPadding: EdgeInsets.only(left: 20),
                  children: [
                    ListTile(
                      leading: Icon(Icons.tune),
                      title: Text("Preferences"),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.tagSelection),
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text("All Recipes"),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.recipeList),
                    ),
                  ],
                ),

                _drawerExpansionTile(Icons.flight_takeoff, "Eco Travel", [
                  _drawerItem(
                    Icons.flight_takeoff,
                    "Travel Tips",
                    AppRoutes.travelTips,
                  ),
                  _drawerItem(
                    Icons.flight_takeoff,
                    "Travel Options",
                    AppRoutes.travelOptions,
                  ),
                  _drawerItem(
                    Icons.flight_takeoff,
                    "Saved Travel Tips",
                    AppRoutes.savedTips,
                  ),
                ]),
                // _drawerItem(Icons.bolt, "Energy Tips", AppRoutes.energyTips),
                _drawerItem(
                  Icons.eco,
                  "Carbon Tracker",
                  AppRoutes.carbondashboard,
                ),
                _drawerItem(
                  Icons.shopping_bag,
                  "Eco Products",
                  AppRoutes.ecoproducts,
                ),
                _drawerExpansionTile(Icons.delete_outline, "Waste Tracker", [
                  _drawerItem(
                    Icons.delete_outline,
                    "Tips",
                    AppRoutes.Wastetipsscreen,
                  ),
                  _drawerItem(
                    Icons.delete_outline,
                    "Dashboard",
                    AppRoutes.Wastetrackerdashboard,
                  ),
                  _drawerItem(
                    Icons.delete_outline,
                    "Input Log",
                    AppRoutes.Wastetrackerinput,
                  ),
                ]),
                _drawerItem(
                  Icons.school,
                  "Educational Content",
                  AppRoutes.educationalContentList,
                ),
                _drawerItem(Icons.forum, "Community", AppRoutes.communityList),
              ],
            ),
          ),

          // User Profile at Bottom
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox(height: 80);
              var user = snapshot.data!.data() as Map<String, dynamic>?;

              String? profileImage = user?['image'];
              String userName = user?['name'] ?? 'User';

              return Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: profileImage != null
                          ? MemoryImage(base64Decode(profileImage))
                          : null,
                      child: profileImage == null
                          ? Text(userName[0].toUpperCase())
                          : null,
                    ),
                    if (isExpanded) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.username,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // const Icon(Icons.more_vert),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String label,
    String route, {
    int badgeCount = 0,
  }) {
    return ListTile(
      leading: badgeCount > 0
          ? badges.Badge(
              badgeContent: Text(
                '$badgeCount',
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
              position: badges.BadgePosition.topEnd(top: -8, end: -8),
              badgeStyle: const badges.BadgeStyle(badgeColor: Colors.green),
              child: Icon(icon, color: Colors.black),
            )
          : Icon(icon, color: Colors.black),
      title: isExpanded
          ? Text(label, style: const TextStyle(color: Colors.black))
          : null,
      onTap: () => Navigator.pushNamed(context, route),
      contentPadding: EdgeInsets.symmetric(horizontal: isExpanded ? 20 : 12),
      horizontalTitleGap: 12,
    );
  }

  Widget _drawerExpansionTile(
    IconData icon,
    String label,
    List<Widget> children,
  ) {
    return ExpansionTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      children: children,
    );
  }
}
