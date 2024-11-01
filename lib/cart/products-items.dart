import 'package:flutter/material.dart';
import 'package:gl1/main.dart';
import 'package:gl1/products.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:provider/provider.dart';

int? deliveryPrice;

class CartHelper extends StatelessWidget {
  Widget _tableHeader(String text, double weight) {
    return Expanded(
      flex: (weight * 100).toInt(), // Adjust flex based on weight
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.grey,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _tableCell(String text, double weight) {
    return Expanded(
      flex: (weight * 100).toInt(), // Adjust flex based on weight
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget tableContent(StateController stateController, BuildContext context) {
    final double column0Weight = 0.1; // Adjust according to your needs
    final double column1Weight = 0.4; // Adjust according to your needs
    final double column2Weight = 0.2; // Adjust according to your needs
    final double column3Weight = 0.2; // Adjust according to your needs
    final double column4Weight = 0.2; // Adjust according to your needs
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "للتعديل او الحذف اضغط على المنتج",
              style: TextStyle(fontSize: 8, color: Colors.blue),
            ),
          ),
          Row(
            children: [
              _tableHeader("#", column0Weight),
              _tableHeader("الصنف", column1Weight),
              _tableHeader("الكمية", column2Weight),
              _tableHeader("السعر", column3Weight),
              _tableHeader("الاجمالي", column4Weight),
            ],
          ),
          ...cartController.products.asMap().entries.map((entry) {
            int index = entry.key;
            ProductInCart product = entry.value;
            return GestureDetector(
              onTap: () {
                showProductDialog(product, stateController, context);
                // stateController.update();
              },
              child: Row(
                children: [
                  _tableCell((index + 1).toString(), column0Weight),
                  _tableCell(product.productsModel.name, column1Weight),
                  _tableCell(product.productCount.toString(), column2Weight),
                  _tableCell(
                      formatPrice(double.parse(product.productsModel.postPrice))
                          .toString(),
                      column3Weight),
                  _tableCell(
                    formatPrice((double.parse(product.productsModel.postPrice) *
                            product.productCount))
                        .toString(),
                    column4Weight,
                  ),
                ],
              ),
            );
          }).toList(),
          ...cartController.offers.asMap().entries.map((entry) {
            int index = entry.key;
            OfferInCart offer = entry.value;
            return GestureDetector(
              onTap: () {
                showOfferDialog(offer, stateController);

                // Handle offer click
              },
              child: Row(
                children: [
                  _tableCell((index + 1).toString(), column0Weight),
                  _tableCell(offer.offerModel.name, column1Weight),
                  _tableCell(offer.offerCount.toString(), column2Weight),
                  _tableCell(
                      formatPrice(double.parse(offer.offerModel.price))
                          .toString(),
                      column3Weight),
                  _tableCell(
                    formatPrice((double.parse(offer.offerModel.price) *
                            offer.offerCount))
                        .toString(),
                    column4Weight,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void showProductDialog(ProductInCart productInCart,
      StateController stateController, BuildContext context) {
    ProductInCart? foundItem;

    for (var item in cartController.products) {
      // print("object");
      if (item.productsModel.id == productInCart.productsModel.id) {
        foundItem = item;
        break; // Exit the loop once found
      }
    }
    if (foundItem != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    foundItem!.productsModel.name.toString(),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              cartController.incrementProductQuantity(
                                  productInCart.productsModel);
                              stateController.update();

                              // addDeliveryPriceToFinalPrice();
                            },
                            icon: Icon(Icons.add),
                          ),
                          Text(
                            "   ",
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                            onPressed: () {
                              cartController.decrementProductQuantity(
                                  productInCart.productsModel);
                              stateController.update();

                              // addDeliveryPriceToFinalPrice();
                            },
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          cartController
                              .removeProduct(productInCart.productsModel.id);
                          stateController.update();

                          // addDeliveryPriceToFinalPrice();
                          Navigator.of(context).pop(); // Close dialog
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void showOfferDialog(
      OfferInCart offerInCart, StateController stateController) {
    final existingOfferIndex = cartController.offers.indexWhere(
      (item) => item.offerModel.id == offerInCart.offerModel.id,
    );
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cartController.offers[existingOfferIndex].offerModel.name
                      .toString(),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            cartController
                                .incrementOfferQuantity(offerInCart.offerModel);

                            stateController.update();
                            // addDeliveryPriceToFinalPrice();
                          },
                          icon: Icon(Icons.add),
                        ),
                        Text(
                          cartController.offers[existingOfferIndex].offerCount
                              .toString(),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          onPressed: () {
                            cartController
                                .decrementOfferQuantity(offerInCart.offerModel);
                            stateController.update();

                            // addDeliveryPriceToFinalPrice();
                          },
                          icon: Icon(Icons.remove),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        cartController.removeOffer(offerInCart.offerModel.id);
                        stateController.update();

                        // addDeliveryPriceToFinalPrice();
                        Navigator.of(context).pop(); // Close dialog
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateController = Provider.of<StateController>(context);

    return tableContent(stateController, context);
  }
}

double formatPrice(double price) {
  return double.parse(price.toStringAsFixed(2)); // Format to 2 decimal places
}

double roundToNearestFifty(double price) {
  return (price / 50).round() * 50; // Rounding logic
}

finalPriceWithDeliveyPrice() {
  var result = roundToNearestFifty(formatPrice(cartController.getFinalPrice()));
  if (deliveryPrice != null) {
    result = result + deliveryPrice!;
  }
  return result;
}
