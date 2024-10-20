import 'dart:convert';

class TokenResult {
  final String token;
  final DateTime expireAt;

  TokenResult({required this.token, required this.expireAt});

  // Factory method to create an instance from JSON
  factory TokenResult.fromJson(Map<String, dynamic> json) {
    return TokenResult(
      token: json['token'],
      expireAt: DateTime.parse(json['expire_at']),
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expire_at': expireAt.toIso8601String(),
    };
  }
}
