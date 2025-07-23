double calculateSelectiveCarbonFootprint({
  required bool includeTransport,
  required bool includeEnergy,
  required bool includeFood,
  required String transportMode,
  required double distanceKm,
  required double electricityKwh,
  required double gasTherms,
  required String dietType,
}) {
  double total = 0;

  if (includeTransport) {
    double transportFactor = {
      'car': 0.21,
      'bus': 0.11,
      'bike': 0.0,
      'walk': 0.0,
    }[transportMode.toLowerCase()] ?? 0.0;

    total += distanceKm * transportFactor;
  }

  if (includeEnergy) {
    total += electricityKwh * 0.4;
    total += gasTherms * 5.3;
  }

  if (includeFood) {
    double dietFactor = {
      'meat': 7.0,
      'vegetarian': 4.0,
      'vegan': 2.0,
    }[dietType.toLowerCase()] ?? 4.0;
    total += dietFactor;
  }

  return double.parse(total.toStringAsFixed(2));
}
