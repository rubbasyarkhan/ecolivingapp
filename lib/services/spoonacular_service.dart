import 'dart:convert';
import 'package:http/http.dart' as http;

class SpoonacularService {
  static const String _apiKey = 'fe499f278150484c8d1f795b5e8603f0';
  static const String _baseUrl = 'https://api.spoonacular.com';

  /// Fetch recipes based on user preferences
  static Future<List<dynamic>> fetchRecipes({
    required List<String> preferences,
    int number = 10,
  }) async {
    // Separate cuisine and diet filters
    final cuisines = preferences
        .where((tag) => !_dietTags.contains(tag))
        .join(',');
    final diet = preferences
        .firstWhere((tag) => _dietTags.contains(tag), orElse: () => '');

    final uri = Uri.parse('$_baseUrl/recipes/complexSearch').replace(queryParameters: {
      'apiKey': _apiKey,
      'number': number.toString(),
      'addRecipeInformation': 'true',
      if (cuisines.isNotEmpty) 'cuisine': cuisines,
      if (diet.isNotEmpty) 'diet': diet,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded['results'] ?? [];
    } else {
      throw Exception('Failed to fetch recipes: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchRecipeDetails(int id) async {
    final uri = Uri.parse(
      '$_baseUrl/recipes/$id/information?apiKey=$_apiKey&includeNutrition=true',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch recipe details: ${response.body}');
    }
  }

  static const List<String> _dietTags = [
    "Vegan",
    "Vegetarian",
    "Keto",
    "Paleo",
    "Low FODMAP",
    "Gluten Free",
  ];
}
