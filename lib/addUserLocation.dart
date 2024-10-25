import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gl1/main.dart';
import 'package:gl1/shared/locationService.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

import 'dart:js' as js;

class addUserLocationPage extends StatefulWidget {
  @override
  State<addUserLocationPage> createState() => _addUserLocationPageState();
}

class _addUserLocationPageState extends State<addUserLocationPage> {
  final pageName = "addUserLocation";

  final TextEditingController nameController = TextEditingController();

  final Requestserver requestserver = Requestserver();

  late StateController stateController;
  late LocationService locationService;
  var isEnabled = false;
  bool? isAllowd;

  String? latLong;
  String? errorLatLong;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      stateController.setPage(pageName);
      // final isEnabled =

      isEnabled = await Geolocator.isLocationServiceEnabled();
      // if (!isEnabled) {
      //   // stateController.errorStateAUD("يجب تفعيل الموقع للمتابعة");
      // } else {

      // }

      // js.context.callMethod('isGeolocationEnabled') as bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);
    locationService = LocationService();

    return Scaffold(
      body: MainCompose(
        page: pageName,
        padding: 10,
        stateController: stateController,
        content: () {
          return mainContent();
        },
      ),
    );
  }

  Widget mainContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                if (isEnabled)
                  Column(
                    children: [
                      if (isAllowd != null)
                        Column(
                          children: [
                            if (isAllowd == false)
                              ElevatedButton(
                                  onPressed: () async {
                                    stateController.startAud();
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);

                                    latLong =
                                        'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
                                    isAllowd = true;
                                    stateController.successState();
                                  },
                                  child: Text("السماح للموقع"))
                            else
                              Text(latLong!)
                          ],
                        )
                      else
                        ElevatedButton(
                            onPressed: () async {
                              stateController.startAud();

                              try {
                                Position position =
                                    await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high);

                                latLong =
                                    'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
                                isAllowd = true;
                                stateController.successStateAUD();
                                // stateController.update();
                              } catch (e) {
                                isAllowd = false;
                                stateController
                                    .errorStateAUD("يجب السماح للموقع");
                              }
                            },
                            child: Text("Allow Gps Retive info")),
                      if (errorLatLong != null)
                        Text('Error retrieving location: $errorLatLong'),
                    ],
                  )
                else
                  Column(
                    children: [
                      Text("افتح الموقع واضغط على اعادة المحاولة"),
                      ElevatedButton(
                          onPressed: () async {
                            isEnabled =
                                await Geolocator.isLocationServiceEnabled();
                            stateController.update();
                          },
                          child: Text("اعادة المحاولة"))
                    ],
                  )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> sendPostRequestaddUserLocation() async {
    const String url = '${Urls.root}users/';

    stateController.startAud();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3 = {
      "tag": "updateName",
      "inputUserName": nameController.text.trim()
    };
    // Map<String, String> formData = {"data1": json.encode(data1)};
    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2),
      "data3": jsonEncode(data3)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateAUD(fail);
      },
      onSuccess: (data) {
        stateController.successStateAUD();
        Navigator.pop(navigatorKey.currentContext!, data);
      },
    );
  }
}
