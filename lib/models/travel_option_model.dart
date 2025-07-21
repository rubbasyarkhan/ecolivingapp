class TravelOptionModel {
  final String id;
  final String title;
  final String description;
  final String type;
  final String region;
  final double co2SavingEstimate;
  final String link;

  TravelOptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.region,
    required this.co2SavingEstimate,
    required this.link,
  });

  factory TravelOptionModel.fromMap(Map<String, dynamic> map, String docId) {
    return TravelOptionModel(
      id: docId,
      title: map['title'],
      description: map['description'],
      type: map['type'],
      region: map['region'],
      co2SavingEstimate: map['co2SavingEstimate']?.toDouble() ?? 0.0,
      link: map['link'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'region': region,
      'co2SavingEstimate': co2SavingEstimate,
      'link': link,
    };
  }
}