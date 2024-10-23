import 'package:gl1/models/productModel.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class ProductsStorage {
  final String categoryId;

  ProductsStorage({required this.categoryId});
  // static const String productsKey = "C";
  // Generate a date key based on categoryId
  String get productsKey => "$categoryId-Ca"; // Use getter for dynamic value

  String get dateKey => "$categoryId-PD"; // Use getter for dynamic value
  // static const String dateKey = categoryId+"PD"; // categoryId,Product DATE

  isSetProducts() {
    try {
      getProducts();
      return true;
    } catch (e) {
      // setProducts("");
      // print("object");
      // print(e);
      return false;
    }
  }

  List<ProductModel> getProducts() {
    // final prefs = await _getPrefs();
    String? productsData = localStorage.getItem(productsKey);

    return ProductModel.decodeProducts(productsData!);
  }

  setProducts(String products) {
    // print(getCurrentDate().toString());
    localStorage.setItem(productsKey, products);

    localStorage.setItem(dateKey, getCurrentDate().toString());
  }

  DateTime getDate() {
    String? dateString = localStorage.getItem(dateKey);
    final date = (DateTime.parse(dateString!));
    return date;
  }
}

DateTime getCurrentDate() {
  // String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  return DateTime.now();
}

String formatPrice(String price) {
  double doublePrice = double.parse(price);
  final NumberFormat formatter =
      NumberFormat('#.##', 'en_US'); // Format to two decimal places
  return formatter.format(doublePrice);
}
