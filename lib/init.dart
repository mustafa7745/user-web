import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/dashboard.dart';
import 'package:gl1/login.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

class InitPage extends StatefulWidget {
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final pageName = "init";
  final Requestserver requestserver = Requestserver();
  late StateController stateController;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      sendPostRequestInit();
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
        content: () {
          return mainContent();
        },
        onRead: sendPostRequestInit,
      ),
    );
  }

  Widget mainContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text("جاري تهيئة البيانات لاول مرة"),
      ),
    );
  }

  Future<void> sendPostRequestInit() async {
    const String url = '${Urls.root}init.php';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    Map<String, String> formData = {"data1": json.encode(data1)};

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateRead(fail);
      },
      onSuccess: (data) {
        requestserver.setInit();
        stateController.successState();
        if (requestserver.isLogined()) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      },
    );
  }
}
