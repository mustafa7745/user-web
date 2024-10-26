import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/cart/products-items.dart';
import 'package:gl1/models/userLocationMdel.dart';
import 'package:gl1/products.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/homeComponentStorage.dart';
import 'package:gl1/userLocations.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final pageName = "cart";
  UserLocationModel? userLocation;

  final Requestserver requestserver = Requestserver();
  late StateController stateController;
  // late CartHelper cartHelper;

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);
    // cartHelper = CartHelper();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenColor,
            foregroundColor: Colors.white,
            title: Text("السلة"),
          ),
          body: MainCompose(
              page: pageName,
              padding: 0,
              stateController: stateController,
              onRead: sendPostRequestGetHome,
              content: () {
                return mainContent();
              })),
    );
  }

  mainContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: cardColor,
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "اجمالي الاصناف: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        roundToNearestFifty(
                                formatPrice(cartController.getFinalPrice()))
                            .toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "سعر التوصيل: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        deliveryPrice?.toString() ?? "عرض السعر",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المبلغ المتوجب دفعه: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        finalPriceWithDeliveyPrice().toString(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: userLocation == null
                          ? myButton("اختيار موقع التوصيل", () {
                              goToUserLocations();
                            })
                          : myButton("تأكيد الطلب", () {})),
                ),
              ],
            ),
          ),
        ),
        if (userLocation != null)
          Card(
            color: cardColor,
            child: Column(
              children: [
                const Text("موقع التوصيل"),
                const Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Divider(
                      thickness: 2, color: Color.fromARGB(255, 38, 39, 39)),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(userLocation!.street.toString()),
                      Text(userLocation!.nearTo.toString()),
                      Text(userLocation!.contactPhone.toString()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            myButtonSmall("تغيير العنوان", goToUserLocations),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        Expanded(child: CartHelper()),
      ],
    );
  }

  Future<void> goToUserLocations() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserLocationsPage()),
    );
    if (result != null) {
      // print(result);
      userLocation = UserLocationModel.fromJson(jsonDecode(result));
      deliveryPrice = userLocation!.deliveryPrice.toInt();
      // userStorage.setUser(result);
      // homeComponent.user = user;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stateController.setPage(pageName);
        stateController.update();
      });
    }
  }

  Future<void> sendPostRequestGetHome() async {}

  read(HomeComponentStorage homeComponentStorage) async {
    const String url = '${Urls.root}home/';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3;
    // if (userStorage.isSetUser()) {
    //   data3 = {"tag": "read"};
    // } else {
    //   data3 = {"tag": "readWithUser2"};
    // }

    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2),
      // "data3": jsonEncode(data3)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateRead(fail);
      },
      onSuccess: (data) async {
        // requestserver.setLogined(data);
        // HomeComponent homeComponent1 =
        //     HomeComponent.fromJson(json.decode(data));
        // if (homeComponent1.user != null) {
        //   userStorage.setUser(jsonEncode(homeComponent1.user));
        // } else {
        //   homeComponent1.user = userStorage.getUser();
        // }
        // homeComponent = homeComponent1;
        // homeComponentStorage.setHomeComponent(jsonEncode(homeComponent));

        // isInitalHomeComponent = true;
        // // print(homeComponent.categories.first.);
        // stateController.successState();

        // if (homeComponent1.user!.name2 == null) {
        //   await goToAddName();
        // }
      },
    );
  }
}

final cardColor = Color.fromARGB(255, 191, 196, 223);
