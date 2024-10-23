import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/dashboard.dart';
import 'package:gl1/main.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

class Main2Page extends StatefulWidget {
  @override
  State<Main2Page> createState() => _Main2PageState();
}

class _Main2PageState extends State<Main2Page> {
  final pageName = "main2";
  final Requestserver requestserver = Requestserver();

  // final ValueNotifier<bool> _isValidPhone = ValueNotifier<bool>(true);
  late StateController stateController;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      sendPostRequestUpdateToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);

    return Scaffold(
        body: MainCompose(
            page: pageName,
            padding: 10,
            stateController: stateController,
            onRead: sendPostRequestUpdateToken,
            content: () {
              return SizedBox();
            }));
  }

  Future<void> sendPostRequestUpdateToken() async {
    const String url = '${Urls.root}refresh_token.php';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();

    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateRead(fail);
      },
      onSuccess: (data) async {
        requestserver.setLogined(data);
        stateController.successState();
        Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (route) => false,
        );
        // // requestserver.setLogined(data);
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
