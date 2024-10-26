import 'dart:convert';

class LocationTypeModel {
  final String id;
  final String name;

  LocationTypeModel({
    required this.id,
    required this.name,
  });

  // Factory method to create a LocationTypeModel from JSON
  factory LocationTypeModel.fromJson(Map<String, dynamic> json) {
    return LocationTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  // Method to convert LocationTypeModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Function to parse a list of LocationTypeModel from JSON
  static List<LocationTypeModel> locationTypeModelFromJson(String str) {
    final List<dynamic> jsonData = json.decode(str);
    return jsonData.map((data) => LocationTypeModel.fromJson(data)).toList();
  }
}
