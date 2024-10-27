import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/dashboard.dart';
import 'package:gl1/models/productModel.dart';
import 'package:gl1/products.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final pageName = "search";
  final TextEditingController _searchController = TextEditingController();

  final Requestserver requestserver = Requestserver();
  List<ProductModel>? products;

  late StateController stateController;
  var isInitSearch = false;

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("بحث عن المنتجات"),
                  InkWell(
                    onTap: () {
                      goToCart();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text((cartController.products.length +
                                cartController.offers.length)
                            .toString()),
                        Icon(Icons.shopping_cart, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  // onChanged: _filterProducts,
                  onSubmitted: (value) {
                    sendPostRequestGetSearch(); // Call search on Enter
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed:
                          sendPostRequestGetSearch, // Handle search action
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: MainCompose(
              page: pageName,
              padding: 10,
              stateController: stateController,
              onRead: sendPostRequestGetSearch,
              content: () {
                if (products != null) {
                  return mainContent();
                } else {
                  return SizedBox();
                }
              })),
    );
  }

  mainContent() {
    final newList = groupProductsByGroupName(products!);

    if (products!.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("لاتوجد بيانات"),
          )
        ],
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
        ),
        itemCount: newList.length,
        itemBuilder: (context, index) {
          final product = newList[index];
          return productInMain(product: product, products: products!);
        },
      );
    }
  }

  Future<void> sendPostRequestGetSearch() async {
    read();
  }

  read() async {
    const String url = '${Urls.root}products/';

    // stateController.startRead();
    // final data1 = await requestserver.getData1();
    // final data2 = requestserver.getData2Token();
    final data3 = {
      "tag": "search",
      "inputProductName": _searchController.text.trim()
    };

    Map<String, String> formData = {
      // "data1": jsonEncode(data1),
      // "data2": jsonEncode(data2),
      "data3": jsonEncode(data3)
    };

    stateController.startAud();

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateAUD(fail);
      },
      onSuccess: (data) async {
        products = ProductModel.decodeProducts(data);
        stateController.successStateAUD();
      },
    );
  }
}
