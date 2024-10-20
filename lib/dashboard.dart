import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Requestserver requestserver = Requestserver();
  // final ValueNotifier<bool> _isValidPhone = ValueNotifier<bool>(true);

  late StateController stateController;
  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);
    return Scaffold(
        body: MainCompose(
            padding: 10,
            stateController: stateController,
            content: () {
              return mainContent();
            }));
  }

  mainContent() {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Text("Dashboard" + Requestserver().getLogined().token)));
  }
}
