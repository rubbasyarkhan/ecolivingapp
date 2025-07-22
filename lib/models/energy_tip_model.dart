class EnergyTip {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;

  EnergyTip({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory EnergyTip.fromJson(Map<String, dynamic> json, String id) {
    return EnergyTip(
      id: id,
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      category: json['category'] ?? 'General',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}
