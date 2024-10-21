class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String order;
  final String categoryImagePath;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.order,
    required this.categoryImagePath,
    // Uncomment if needed
    // required this.createdAt,
    // required this.updatedAt,
  });

  // Factory constructor for creating a CategoryModel instance from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      order: json['order'],
      categoryImagePath: json['category_image_path'],
      // Uncomment if needed
      // createdAt: json['createdAt'],
      // updatedAt: json['updatedAt'],
    );
  }

  // Method to convert a CategoryModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'order': order,
      'category_image_path': categoryImagePath,
      // Uncomment if needed
      // 'createdAt': createdAt,
      // 'updatedAt': updatedAt,
    };
  }
}
