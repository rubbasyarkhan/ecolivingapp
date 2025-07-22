import 'package:eco_living_app/screens/eco_products/eco_product_list_screen.dart';
import 'package:eco_living_app/screens/eco_tips/energy_tips_screen.dart';
import 'package:eco_living_app/screens/eco_travel/saved_tips_screen.dart';
import 'package:eco_living_app/screens/eco_travel/travel_options_screen.dart';
import 'package:eco_living_app/screens/eco_travel/travel_tips_screen.dart';
import 'package:eco_living_app/screens/home/profile_screen.dart';
import 'package:eco_living_app/screens/home/splahsecond_screen.dart';
import 'package:eco_living_app/screens/recipe/recipe_list_screen.dart';
import 'package:eco_living_app/screens/recipe/tag_selection_screen.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode and kReleaseMode
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'screens/home/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';

// ✅ Import your seeder
// import 'package:eco_living_app/screens/dev/populate_eco_products.dart'; // adjust the path as needed

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Run Seeder only in debug mode
  // if (kDebugMode) {
  //   final seeder = EcoProductSeeder();
  //   await seeder.seedDatabase();
  // }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Enabled only in debug mode
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Living App',
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.splashscreen2: (context) => const SplahsecondScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
        AppRoutes.tagSelection: (context) => const TagSelectionScreen(),
        AppRoutes.recipeList: (context) => const RecipeListScreen(),
        AppRoutes.travelTips: (context) => const TravelTipsScreen(),
        AppRoutes.travelOptions: (context) => const TravelOptionsScreen(),
        AppRoutes.savedTips: (context) => const SavedTipsScreen(),
        AppRoutes.energyTips: (context) => const EnergyTipsScreen(),
        AppRoutes.ecoproducts: (context) => EcoProductListScreen(),
      },
    );
  }
}
