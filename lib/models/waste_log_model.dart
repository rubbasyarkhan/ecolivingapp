import 'package:cloud_firestore/cloud_firestore.dart';

enum WasteCategory {
  recycling,
  composting,
  plasticReduction,
  other,
}

class WasteLog {
  final String id;
  final String userId;
  final WasteCategory category;
  final String method;
  final int quantity;
  final String unit;
  final DateTime date;

  WasteLog({
    required this.id,
    required this.userId,
    required this.category,
    required this.method,
    required this.quantity,
    required this.unit,
    required this.date,
  });

  /// ✅ Factory to create a WasteLog from Firestore JSON
  factory WasteLog.fromJson(Map<String, dynamic> json, String id) {
    return WasteLog(
      id: id,
      userId: json['userId'] ?? '',
      category: _categoryFromString(json['category']),
      method: json['method'] ?? '',
      quantity: (json['quantity'] as int?) ?? 0,
      unit: json['unit'] ?? '',
      date: _parseDate(json['date']),
    );
  }

  /// ✅ Convert to JSON for saving to Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'category': category.name,
      'method': method,
      'quantity': quantity,
      'unit': unit,
      'date': Timestamp.fromDate(date),
    };
  }

  /// ✅ Create a copy with optional overrides
  WasteLog copyWith({
    String? id,
    String? userId,
    WasteCategory? category,
    String? method,
    int? quantity,
    String? unit,
    DateTime? date,
  }) {
    return WasteLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      method: method ?? this.method,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      date: date ?? this.date,
    );
  }

  /// ✅ Helper to map Firestore string to enum
  static WasteCategory _categoryFromString(String? category) {
    switch (category?.toLowerCase()) {
      case 'recycling':
        return WasteCategory.recycling;
      case 'composting':
        return WasteCategory.composting;
      case 'plasticreduction':
      case 'plastic_reduction':
        return WasteCategory.plasticReduction;
      default:
        return WasteCategory.other;
    }
  }

  /// ✅ Human-readable category name
  static String categoryToString(WasteCategory category) {
    switch (category) {
      case WasteCategory.recycling:
        return 'Recycling';
      case WasteCategory.composting:
        return 'Composting';
      case WasteCategory.plasticReduction:
        return 'Plastic Reduction';
      default:
        return 'Other';
    }
  }

  /// ✅ Parse Firestore Timestamp or String to DateTime
  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }
}
