class TravelTipModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;

  TravelTipModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory TravelTipModel.fromMap(Map<String, dynamic> map, String docId) {
    return TravelTipModel(
      id: docId,
      title: map['title'],
      description: map['description'],
      category: map['category'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
    };
  }
}