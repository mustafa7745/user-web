import 'dart:convert';

import 'package:gl1/models/productImageModel.dart';

class ProductModel {
  final String id;
  final String name;
  final String prePrice;
  final String postPrice;
  final String categoryId;
  final String isAvailable;
  final String productsGroupsId;
  final String productsGroupsName;
  final List<ProductImageModel> productImages;

  ProductModel({
    required this.id,
    required this.name,
    required this.prePrice,
    required this.postPrice,
    required this.categoryId,
    required this.isAvailable,
    required this.productsGroupsId,
    required this.productsGroupsName,
    required this.productImages,
  });

  // Factory constructor for creating a ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var imagesJson = json['productImages'] as List;
    List<ProductImageModel> imagesList = imagesJson
        .map((imageJson) => ProductImageModel.fromJson(imageJson))
        .toList();

    return ProductModel(
      id: json['id'],
      name: json['name'],
      prePrice: json['prePrice'],
      postPrice: json['postPrice'],
      categoryId: json['categoryId'],
      isAvailable: json['isAvailable'],
      productsGroupsId: json['products_groupsId'],
      productsGroupsName: json['products_groupsName'],
      productImages: imagesList,
    );
  }

  // Method to convert a ProductModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'prePrice': prePrice,
      'postPrice': postPrice,
      'categoryId': categoryId,
      'isAvailable': isAvailable,
      'products_groupsId': productsGroupsId,
      'products_groupsName': productsGroupsName,
      'productImages': productImages.map((image) => image.toJson()).toList(),
    };
  }

  static List<ProductModel> decodeProducts(String data) {
    try {
      final List<dynamic> jsonData = jsonDecode(data);

      // Map the decoded JSON to OrderModel objects
      List<ProductModel> orders = jsonData.map((item) {
        return ProductModel.fromJson(item as Map<String, dynamic>);
      }).toList();
      return orders;
    } catch (e) {
      return [];
    }
  }
}
