import 'package:gl1/models/adsModel.dart';
import 'package:gl1/models/categoryModel.dart';
import 'package:gl1/models/offerModel.dart';
import 'package:gl1/models/productModel.dart';
import 'package:gl1/models/userModel.dart';

class HomeComponent {
  User? user;
  List<AdsModel> ads;
  List<ProductModel> discounts;
  List<OfferModel> offers;
  List<CategoryModel> categories;

  HomeComponent({
    this.user,
    required this.ads,
    required this.discounts,
    required this.offers,
    required this.categories,
  });

  // Factory constructor to create a HomeComponent from JSON
  factory HomeComponent.fromJson(Map<String, dynamic> json) {
    return HomeComponent(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      ads: (json['ads'] as List).map((i) => AdsModel.fromJson(i)).toList(),
      discounts: (json['discounts'] as List)
          .map((i) => ProductModel.fromJson(i))
          .toList(),
      offers:
          (json['offers'] as List).map((i) => OfferModel.fromJson(i)).toList(),
      categories: (json['categories'] as List)
          .map((i) => CategoryModel.fromJson(i))
          .toList(),
    );
  }

  // Method to convert HomeComponent to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'ads': ads.map((ad) => ad.toJson()).toList(),
      'discounts': discounts.map((discount) => discount.toJson()).toList(),
      'offers': offers.map((offer) => offer.toJson()).toList(),
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}
