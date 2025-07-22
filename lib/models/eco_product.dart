class EcoProduct {
  final String id;
  final String name;
  final String description;
  final String longDescription;           // new field
  final String category;
  final List<String> advantages;
  final String imageUrl;
  final List<String> nonEcoAlternatives;
  final List<String> nonEcoReasons;       // new field

  EcoProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.category,
    required this.advantages,
    required this.imageUrl,
    required this.nonEcoAlternatives,
    required this.nonEcoReasons,
  });

  factory EcoProduct.fromJson(Map<String, dynamic> json, String id) {
    return EcoProduct(
      id: id,
      name: json['name'],
      description: json['description'],
      longDescription: json['longDescription'] ?? '', // handle missing field
      category: json['category'],
      advantages: List<String>.from(json['advantages']),
      imageUrl: json['imageUrl'],
      nonEcoAlternatives: List<String>.from(json['nonEcoAlternatives']),
      nonEcoReasons: json['nonEcoReasons'] != null
          ? List<String>.from(json['nonEcoReasons'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'longDescription': longDescription,
      'category': category,
      'advantages': advantages,
      'imageUrl': imageUrl,
      'nonEcoAlternatives': nonEcoAlternatives,
      'nonEcoReasons': nonEcoReasons,
    };
  }
}
