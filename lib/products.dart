import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gl1/models/offerModel.dart';
import 'package:gl1/models/productModel.dart';
import 'package:gl1/shared/loading.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/productsStorage.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  ProductsPage({required this.categoryId, required this.categoryName});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final pageName = "products";
  final Requestserver requestserver = Requestserver();
  late List<ProductModel> products;

  late StateController stateController;
  var isInitProducts = false;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      sendPostRequestGetProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            foregroundColor: Colors.white,
            title: Text(widget.categoryName),
          ),
          body: MainCompose(
              page: pageName,
              padding: 10,
              stateController: stateController,
              onRead: sendPostRequestGetProducts,
              content: () {
                if (isInitProducts) {
                  return mainContent();
                }
                return SizedBox();
              })),
    );
  }

  mainContent() {
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: ProductsCompose(products: products, cart: CartController()),
    );
  }

  Future<void> sendPostRequestGetProducts() async {
    final productsStorage = ProductsStorage(categoryId: widget.categoryId);
    // read(homeComponentStorage);
    if (productsStorage.isSetProducts()) {
      // final current Date
      final diff = getCurrentDate().difference(productsStorage.getDate());
      // print(diff);
      // print(diff.inMinutes);
      // print(getCurrentDate());
      // print(homeComponentStorage.getDate());
      if (diff.inMinutes > 3) {
        read(productsStorage);
      } else {
        products = productsStorage.getProducts();
        isInitProducts = true;
        stateController.successState();
      }
    } else {
      read(productsStorage);
    }
    //
  }

  read(ProductsStorage productsStorage) async {
    const String url = '${Urls.root}products/';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3 = {"tag": "read", "inputCategoryId": widget.categoryId};

    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2),
      "data3": jsonEncode(data3)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateRead(fail);
      },
      onSuccess: (data) async {
        print(data);
        print("mustafa");
        // if (data) {

        // }
        productsStorage.setProducts(data);
        // print(data);
        // final List<dynamic> jsonData = jsonDecode(data);
        // requestserver.setLogined(data);

        products = ProductModel.decodeProducts(data);
        isInitProducts = true;
        stateController.successState();
      },
    );
  }
}

class ProductsCompose extends StatelessWidget {
  final List<ProductModel> products;
  final CartController cart;

  ProductsCompose({required this.products, required this.cart});

  @override
  Widget build(BuildContext context) {
    final newList = groupProductsByGroupName(products);
    print(newList);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: newList.length,
      itemBuilder: (context, index) {
        final product = newList[index];
        return productInMain(product: product, products: products);
      },
    );
  }
}

List<ProductModel> groupProductsByGroupName(List<ProductModel> products) {
  // Create a set to track added group names
  Set<String> addedGroups = {};

  // Create a list to hold the unique products
  List<ProductModel> uniqueProducts = [];

  for (var product in products) {
    // Check if the product's group has already been added
    if (!addedGroups.contains(product.productsGroupsName)) {
      // If not, add the product to the unique list and mark the group as added
      uniqueProducts.add(product);
      addedGroups.add(product.productsGroupsName);
    }
  }

  return uniqueProducts;
}

class productInMain extends StatelessWidget {
  const productInMain({
    super.key,
    required this.product,
    required this.products,
  });

  final ProductModel product;
  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          children: [
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      formatPrice(product.postPrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(" ريال "),
                  ],
                ),
                if (product.productsGroupsName != "الرئيسية")
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: myButtonSmall(
                      "الانواع",
                      () {
                        // Handle types click
                        showModalList(context, cartController,
                            product.productsGroupsId, products);
                      },
                    ),
                  )
              ],
            ),
            Divider(),
            // Availability Card
            if (product.isAvailable == "0")
              Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    "تم ايقافه مؤقتا",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            else
              AddToCartUi(product: product), // Your AddToCart UI here
            // Image Carousel
            SizedBox(
              height: 5,
            ),
            if (product.productImages.isNotEmpty)
              Expanded(
                child: PageView.builder(
                  itemCount: product.productImages.length,
                  itemBuilder: (context, imageIndex) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: product.productImages[imageIndex].image,
                        placeholder: (context, url) =>
                            LoadingWidget(), // Loading indicator
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error), // Error widget
                      ),
                    );
                  },
                ),
              )
            else
              Center(
                child: Text(
                  "لايوجد صور لهذا الصنف",
                  style: TextStyle(fontSize: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final cartController = CartController();

class AddToCartUi extends StatelessWidget {
  final ProductModel product;

  AddToCartUi({required this.product});

  @override
  Widget build(BuildContext context) {
    final stateController = Provider.of<StateController>(
        context); // Assuming you have a CartController

    ProductInCart? foundItem;

    for (var item in cartController.products) {
      if (item.productsModel.id == product.id) {
        foundItem = item;
        break; // Exit the loop once found
      }
    }

    if (foundItem == null) {
      return GestureDetector(
        onTap: () {
          cartController.addProduct(product);
          stateController.update();
        },
        child: Container(
          width: double.infinity,
          height: 30,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, color: greenColor),
              Text("اضافة الى السلة", style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 30,
        color: Colors.white,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  cartController.incrementProductQuantity(product);
                  stateController.update();
                },
                icon: Icon(
                  Icons.add,
                  size: 17,
                ),
              ),
              Text(foundItem.productCount.toString()),
              IconButton(
                onPressed: () {
                  cartController.decrementProductQuantity(product);
                  stateController.update();
                },
                icon: Icon(Icons.remove, size: 17),
              ),
              IconButton(
                onPressed: () {
                  cartController.removeProduct(product.id);
                  stateController.update();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 17,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class ProductInCart {
  final ProductModel productsModel;
  int productCount;

  ProductInCart({required this.productsModel, required this.productCount});
}

class OfferInCart {
  final OfferModel offerModel;
  int offerCount;

  OfferInCart({required this.offerModel, required this.offerCount});
}

class CartController {
  List<ProductInCart> products = [];
  List<OfferInCart> offers = [];

  void addProduct(ProductModel productModel, {int count = 1}) {
    final existingProductIndex = products.indexWhere(
      (item) => item.productsModel.id == productModel.id,
    );

    if (existingProductIndex != -1) {
      // Update count of existing product
      products[existingProductIndex].productCount += count;
    } else {
      // Add new product to the cart
      products
          .add(ProductInCart(productsModel: productModel, productCount: count));
    }
  }

  void removeProduct(String productId) {
    products.removeWhere((item) => item.productsModel.id == productId);
  }

  void removeOffer(String offerId) {
    offers.removeWhere((item) => item.offerModel.id == offerId);
  }

  void incrementOfferQuantity(OfferModel offerModel, {int count = 1}) {
    final existingOfferIndex = offers.indexWhere(
      (item) => item.offerModel.id == offerModel.id,
    );

    if (existingOfferIndex != -1) {
      // Update count of existing offer
      offers[existingOfferIndex].offerCount += count;
    } else {
      // Add new offer to the cart
      offers.add(OfferInCart(offerModel: offerModel, offerCount: count));
    }
  }

  void incrementProductQuantity(ProductModel productModel, {int count = 1}) {
    final existingProductIndex = products.indexWhere(
      (item) => item.productsModel.id == productModel.id,
    );

    if (existingProductIndex != -1) {
      // Update count of existing offer
      products[existingProductIndex].productCount += count;
    } else {
      // Add new offer to the cart
      products
          .add(ProductInCart(productsModel: productModel, productCount: count));
    }
  }

  void decrementProductQuantity(ProductModel productModel, {int count = 1}) {
    final existingProductIndex = products.indexWhere(
      (item) => item.productsModel.id == productModel.id,
    );

    if (existingProductIndex != -1) {
      final product = products[existingProductIndex];
      product.productCount = (product.productCount - count)
          .clamp(1, product.productCount); // Ensure it doesn't go below 1
    }
  }

  void decrementOfferQuantity(OfferModel offerModel, {int count = 1}) {
    final existingOfferIndex = offers.indexWhere(
      (item) => item.offerModel.id == offerModel.id,
    );

    if (existingOfferIndex != -1) {
      final offer = offers[existingOfferIndex];
      offer.offerCount = (offer.offerCount - count)
          .clamp(0, offer.offerCount); // Ensure it doesn't go below 0
    }
  }

  double calculateTotalProductPrice() {
    return products.fold(0.0, (total, item) {
      double price = double.parse(
          item.productsModel.postPrice); // Assuming postPrice is a string
      return total + price * item.productCount;
    });
  }

  double calculateTotalOfferPrice() {
    return offers.fold(0.0, (total, item) {
      double offerPrice = double.parse(
          item.offerModel.price.toString()); // Assuming price is a string
      return total + offerPrice * item.offerCount;
    });
  }

  double getFinalPrice() {
    return calculateTotalOfferPrice() + calculateTotalProductPrice();
  }
}

void showModalList(BuildContext context, CartController cartController,
    String groupId, List<ProductModel> products) {
  List<ProductModel> modalList =
      products.where((product) => product.productsGroupsId == groupId).toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75, // Adjust to your liking
          ),
          itemCount: modalList.length,
          itemBuilder: (BuildContext context, int index) {
            ProductModel product = modalList[index];
            return Card(
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  // Display product name and price
                  namePriceModal(product),
                  Expanded(
                    child: product.productImages.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text("لايوجد صور لهذا الصنف",
                                      style: TextStyle(fontSize: 8))),
                            ],
                          )
                        : PageView.builder(
                            itemCount: product.productImages.length,
                            itemBuilder: (context, imgIndex) {
                              return AspectRatio(
                                aspectRatio: 1,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      product.productImages[imgIndex].image,
                                  placeholder: (context, url) =>
                                      LoadingWidget(), // Loading indicator
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error), // Error widget
                                ),
                              );
                            },
                          ),
                  ),

                  Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    child: Column(
                      children: [
                        // Availability check
                        if (product.isAvailable == "0")
                          Container(
                            color: Colors.red,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "تم ايقافه مؤقتا",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                        else
                          AddToCartUi(product: product),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

Widget namePriceModal(ProductModel product) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        height: 30,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              product.name,
              style: TextStyle(
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
      Divider(), // Equivalent to HorizontalDivider in your Kotlin code
      Container(
        width: double.infinity,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("السعر: "),
            Text(
              formatPrice(product.postPrice),
            ),
          ],
        ),
      ),
    ],
  );
}
