class ProductImageModel {
  final String image;
  // Uncomment if needed
  // final String createdAt;

  ProductImageModel({
    required this.image,
    // required this.createdAt,
  });

  // Factory constructor for creating a ProductImageModel instance from JSON
  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      image: json['image'],
      // createdAt: json['createdAt'],
    );
  }

  // Method to convert a ProductImageModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      // 'createdAt': createdAt,
    };
  }
}
