import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/main.dart';
import 'package:gl1/shared/locationService.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      stateController.setPage(pageName);
      isEnabled = await locationService.isOpend();
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
              children: [if (isEnabled) Text("Enabled") else Text("Disabled")],
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
