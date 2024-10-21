class OfferModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String price;
  final String expireAt;
  final String createdAt;
  final String updatedAt;

  OfferModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.expireAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating an OfferModel instance from JSON
  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      expireAt: json['expireAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Method to convert an OfferModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'expireAt': expireAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
