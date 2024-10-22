import 'dart:convert';

class OrderModel {
  final String id;
  final String userId;
  String? code; // Nullable
  final String situationId;
  final String createdAt;
  final String updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    this.code,
    required this.situationId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['userId'],
      code: json['code'],
      situationId: json['situationId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert an OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'code': code,
      'situationId': situationId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static List<OrderModel> decodeOrders(String data) {
    try {
      final List<dynamic> jsonData = jsonDecode(data);

      // Map the decoded JSON to OrderModel objects
      List<OrderModel> orders = jsonData.map((item) {
        return OrderModel.fromJson(item as Map<String, dynamic>);
      }).toList();

      print(orders.length);
      return orders;
    } catch (e) {
      return [];
    }
  }
}
