import 'dart:convert';

class UserLocationModel {
  final String id;
  final String userId;
  final String city;
  final String street;
  final String latLong;
  final String nearTo;
  final String contactPhone;
  double deliveryPrice; // Make this mutable
  final String createdAt;
  final String updatedAt;

  UserLocationModel({
    required this.id,
    required this.userId,
    required this.city,
    required this.street,
    required this.latLong,
    required this.nearTo,
    required this.contactPhone,
    required this.deliveryPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a UserLocationModel from JSON
  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      id: json['id'],
      userId: json['userId'],
      city: json['city'],
      street: json['street'],
      latLong: json['latLong'],
      nearTo: json['nearTo'],
      contactPhone: json['contactPhone'],
      deliveryPrice: json['deliveryPrice'].toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert UserLocationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'city': city,
      'street': street,
      'latLong': latLong,
      'nearTo': nearTo,
      'contactPhone': contactPhone,
      'deliveryPrice': deliveryPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static List<UserLocationModel> decodeList(String data) {
    try {
      final List<dynamic> jsonData = jsonDecode(data);

      // Map the decoded JSON to OrderModel objects
      List<UserLocationModel> orders = jsonData.map((item) {
        return UserLocationModel.fromJson(item as Map<String, dynamic>);
      }).toList();
      return orders;
    } catch (e) {
      return [];
    }
  }
}
