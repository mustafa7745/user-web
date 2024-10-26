import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/addUserLocation.dart';
import 'package:gl1/main.dart';
import 'package:gl1/models/userLocationMdel.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/userStorage.dart';
import 'package:provider/provider.dart';

List<UserLocationModel>? userLocations;

class UserLocationsPage extends StatefulWidget {
  @override
  State<UserLocationsPage> createState() => _UserLocationsPageState();
}

class _UserLocationsPageState extends State<UserLocationsPage> {
  final pageName = "userLocations";

  final Requestserver requestserver = Requestserver();
  late StateController stateController;
  UserStorage userStorage = UserStorage();

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      if (userLocations == null) {
        sendPostRequestGetLocations();
      }
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
            title: Text("عناويني"),
          ),
          body: MainCompose(
              page: pageName,
              padding: 0,
              stateController: stateController,
              onRead: sendPostRequestGetLocations,
              content: () {
                return Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: myButton(
                            "اضافة",
                            () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        addUserLocationPage()),
                              );
                              if (result != null) {
                                final d = UserLocationModel.fromJson(
                                    jsonDecode(result));
                                userLocations!.insert(0, d);
                                stateController.update();
                              }
                            },
                          ),
                        )),
                    Expanded(child: mainContent())
                  ],
                );
              })),
    );
  }

  mainContent() {
    if (userLocations != null) {
      if (userLocations!.isEmpty) {
        return Center(
          child: Text("لم يتم اضافة اي موقع بعد"),
        );
      } else {
        return ListView.builder(
            itemCount: userLocations!.length,
            itemBuilder: (context, index) {
              UserLocationModel userLocation = userLocations![index];
              return Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userLocation.street.toString()),
                        Text("الشارع"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userLocation.nearTo.toString()),
                        Text("الوصف"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(userLocation.contactPhone.toString()),
                        Text("رقم الهاتف"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myButton("اختر", () {
                        Navigator.pop(navigatorKey.currentContext!,
                            jsonEncode(userLocation));
                      }),
                    )
                  ],
                ),
              );
            });
      }
    }
  }

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
