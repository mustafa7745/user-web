class AdsModel {
  final String id;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  AdsModel({
    required this.id,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating an AdsModel instance from JSON
  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json['id'],
      description: json['description'],
      image: json['image'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert an AdsModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
