class User {
  final String name;
  String? name2; // Optional field
  final String phone;

  User({
    required this.name,
    this.name2,
    required this.phone,
  });

  // Factory constructor for creating a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      name2: json['name2'],
      phone: json['phone'],
    );
  }

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'name2': name2,
      'phone': phone,
    };
  }
}
