import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final Requestserver requestserver = Requestserver();

  // final ValueNotifier<bool> _isValidPhone = ValueNotifier<bool>(true);
  late StateController stateController;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendPostRequestGetHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);
    return Scaffold(
        body: MainCompose(
            padding: 10,
            stateController: stateController,
            onRead: sendPostRequestGetHome,
            content: () {
              return mainContent();
            }));
  }

  mainContent() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(child: Text("Dashboard")));
  }

  Future<void> sendPostRequestGetHome() async {
    const String url = '${Urls.root}home/';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3 = {"tag": "readWithUser2"};
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
      onSuccess: (data) {
        // requestserver.setLogined(data);
        print(data);
        stateController.successState();
        // Navigator.pushAndRemoveUntil(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(builder: (context) => DashboardPage()),
        //   (Route<dynamic> route) => false,
        // );
      },
    );
  }
}
