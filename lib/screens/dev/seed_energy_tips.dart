import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedEnergyTips() async {
  final tips = [
    {
      "title": "Switch to LED Bulbs",
      "description":
          "LED bulbs use up to 80% less energy than traditional incandescent bulbs and last up to 25 times longer.",
      "imageUrl":
          "https://images.unsplash.com/photo-1582719478190-8fdc0d2c72d7?fit=crop&w=600&q=80"
    },
    {
      "title": "Unplug Idle Devices",
      "description":
          "Even when turned off, devices like chargers and microwaves draw standby power. Unplug them to save energy.",
      "imageUrl":
          "https://images.unsplash.com/photo-1581090700227-1e37b190418e?fit=crop&w=600&q=80"
    },
    {
      "title": "Install Smart Thermostats",
      "description":
          "Smart thermostats can automatically adjust heating and cooling to save energy based on your schedule.",
      "imageUrl":
          "https://images.unsplash.com/photo-1600369671722-c2c68147b394?fit=crop&w=600&q=80"
    },
    {
      "title": "Seal Air Leaks",
      "description":
          "Air leaks around doors and windows waste energy. Seal them with weather stripping or caulk.",
      "imageUrl":
          "https://images.unsplash.com/photo-1592878906073-ff5c03f7a8fb?fit=crop&w=600&q=80"
    },
    {
      "title": "Use Natural Light",
      "description":
          "Open blinds during the day to light your space naturally and reduce the need for electric lighting.",
      "imageUrl":
          "https://images.unsplash.com/photo-1544986581-efac024faf62?fit=crop&w=600&q=80"
    },
    {
      "title": "Wash Clothes in Cold Water",
      "description":
          "Using cold water instead of hot can cut your washing machine's energy use by up to 90%.",
      "imageUrl":
          "https://images.unsplash.com/photo-1608198093002-ad4e0054841b?fit=crop&w=600&q=80"
    },
    {
      "title": "Air-Dry Laundry",
      "description":
          "Skip the dryer and hang your clothes to dry. This saves electricity and extends fabric life.",
      "imageUrl":
          "https://images.unsplash.com/photo-1611823702032-300c8d6fdfc2?fit=crop&w=600&q=80"
    },
    {
      "title": "Limit Space Heater Use",
      "description":
          "Space heaters can be very inefficient. Use blankets and insulation to stay warm instead.",
      "imageUrl":
          "https://images.unsplash.com/photo-1616256462809-2bba1350c8ee?fit=crop&w=600&q=80"
    },
    {
      "title": "Maintain Your HVAC System",
      "description":
          "Clean filters and regular maintenance help your heating and cooling systems run efficiently.",
      "imageUrl":
          "https://images.unsplash.com/photo-1604854794414-1e8312d9f2a1?fit=crop&w=600&q=80"
    },
    {
      "title": "Use Energy Star Appliances",
      "description":
          "Look for the Energy Star label when buying appliances. These are certified to use less energy.",
      "imageUrl":
          "https://images.unsplash.com/photo-1616627980880-2a8e6ac4d860?fit=crop&w=600&q=80"
    },
  ];

  final collection = FirebaseFirestore.instance.collection('energy_tips');

  for (var tip in tips) {
    await collection.add(tip);
  }

  print("✅ 10 Energy tips seeded successfully!");
}
