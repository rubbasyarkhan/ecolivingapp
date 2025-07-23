class CarbonLog {
  final String id;
  final String userId;
  final DateTime date;
  final String transportMode;
  final double distanceKm;
  final double electricityKwh;
  final double gasTherms;
  final String dietType;
  final double totalCo2Kg;

  CarbonLog({
    required this.id,
    required this.userId,
    required this.date,
    required this.transportMode,
    required this.distanceKm,
    required this.electricityKwh,
    required this.gasTherms,
    required this.dietType,
    required this.totalCo2Kg,
  });

  /// Factory method to create a CarbonLog from Firestore JSON
  factory CarbonLog.fromJson(Map<String, dynamic> json, String id) {
    return CarbonLog(
      id: id,
      userId: json['userId'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      transportMode: json['transportation']?['mode'] ?? 'unknown',
      distanceKm: (json['transportation']?['distance_km'] ?? 0).toDouble(),
      electricityKwh: (json['energy']?['electricity_kwh'] ?? 0).toDouble(),
      gasTherms: (json['energy']?['gas_therms'] ?? 0).toDouble(),
      dietType: json['food']?['diet_type'] ?? 'unknown',
      totalCo2Kg: (json['total_co2_kg'] ?? 0).toDouble(),
    );
  }

  /// Convert this CarbonLog to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
      'transportation': {
        'mode': transportMode,
        'distance_km': distanceKm,
      },
      'energy': {
        'electricity_kwh': electricityKwh,
        'gas_therms': gasTherms,
      },
      'food': {
        'diet_type': dietType,
      },
      'total_co2_kg': totalCo2Kg,
    };
  }
}
