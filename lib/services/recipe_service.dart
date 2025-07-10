import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeService {
  static Future<List<Recipe>> fetchAllRecipes() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['recipes'];
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
