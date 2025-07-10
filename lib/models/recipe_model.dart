class Recipe {
  final int id;
  final String name;
  final String image;
  final String description;
  final List<String> tags;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.tags,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['instructions'].join(' ').substring(0, 80),
      tags: List<String>.from(json['tags']),
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
    );
  }
}
