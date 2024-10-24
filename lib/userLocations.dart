import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gl1/addUserLocation.dart';
import 'package:gl1/cart.dart';
import 'package:gl1/main.dart';
import 'package:gl1/models/categoryModel.dart';
import 'package:gl1/models/homeComponent.dart';
import 'package:gl1/models/userLocationMdel.dart';
import 'package:gl1/models/userModel.dart';
import 'package:gl1/orders.dart';
import 'package:gl1/products.dart';
import 'package:gl1/shared/loading.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/homeComponentStorage.dart';
import 'package:gl1/storage/userStorage.dart';
import 'package:gl1/updateName.dart';
import 'package:provider/provider.dart';

class UserLocationsPage extends StatefulWidget {
  @override
  State<UserLocationsPage> createState() => _UserLocationsPageState();
}

class _UserLocationsPageState extends State<UserLocationsPage> {
  final pageName = "dashboard";

  List<UserLocationModel> userLocations = [];
  final Requestserver requestserver = Requestserver();
  late StateController stateController;
  UserStorage userStorage = UserStorage();

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      sendPostRequestGetLocations();
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);

    return Scaffold(
        body: MainCompose(
            page: pageName,
            padding: 0,
            stateController: stateController,
            onRead: sendPostRequestGetLocations,
            content: () {
              return Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => addUserLocationPage()),
                        );
                      },
                      child: Text("اضافة")),
                  Expanded(child: mainContent())
                ],
              );
            }));
  }

  mainContent() {
    return ListView.builder(
        itemCount: userLocations.length,
        itemBuilder: (context, index) {
          UserLocationModel userLocation = userLocations[index];
          return Card(
            child: Column(
              children: [
                Text(userLocation.street.toString()),
                Text(userLocation.nearTo.toString()),
                Text(userLocation.contactPhone.toString()),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(navigatorKey.currentContext!,
                          jsonEncode(userLocation));
                    },
                    child: Text("اختيار")),
              ],
            ),
          );
        });
  }

  // Future<void> goToAddName() async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => UpdateNamePage()),
  //   );

  //   // Show the returned value
  //   if (result != null) {
  //     // print(result);
  //     // final user = User.fromJson(jsonDecode(result));
  //     // userStorage.setUser(result);
  //     // homeComponent.user = user;
  //     // WidgetsBinding.instance.addPostFrameCallback((_) {
  //     //   stateController.setPage(pageName);
  //     //   stateController.update();
  //     //   toast("تمت الاضافة بنجاح");
  //     // });
  //   }
  // }

  Future<void> sendPostRequestGetLocations() async {
    read();
  }

  read() async {
    const String url = '${Urls.root}users_locations/';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3 = {"tag": "read"};

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
        userLocations = UserLocationModel.decodeList(data);
        stateController.successState();
      },
    );
  }
}
