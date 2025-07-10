import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionService {
  static const String apiKey = 'fe499f278150484c8d1f795b5e8603f0';

  static Future<Map<String, dynamic>?> getNutritionData(String recipeId, String recipeName) async {
    final docRef = FirebaseFirestore.instance.collection('nutrition').doc(recipeId);
    final doc = await docRef.get();

    if (doc.exists) return doc.data();

    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/guessNutrition?title=$recipeName&apiKey=$apiKey');

    final res = await http.get(url);
    if (res.statusCode != 200) return null;

    final data = json.decode(res.body);

    try {
      final nutritionData = {
        'calories': _extractNutrition(data['calories']),
        'protein': _extractNutrition(data['protein']),
        'fat': _extractNutrition(data['fat']),
        'carbs': _extractNutrition(data['carbs']),
      };

      await docRef.set(nutritionData);
      return nutritionData;
    } catch (e) {
      print('Nutrition parsing error: $e');
      return null;
    }
  }

  static Map<String, dynamic> _extractNutrition(dynamic item) {
    if (item is Map<String, dynamic>) {
      return {
        'value': item['value'],
        'unit': item['unit'] ?? '',
        'confidenceRange95Percent': {
          'min': item['confidenceRange95Percent']?['min'],
          'max': item['confidenceRange95Percent']?['max'],
        }
      };
    } else {
      // API sometimes returns just a number
      return {
        'value': item,
        'unit': '',
        'confidenceRange95Percent': {'min': null, 'max': null},
      };
    }
  }
}
