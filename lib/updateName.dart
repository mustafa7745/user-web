import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/main.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';

class UpdateNamePage extends StatefulWidget {
  @override
  State<UpdateNamePage> createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends State<UpdateNamePage> {
  final pageName = "updateName";

  final TextEditingController nameController = TextEditingController();

  final Requestserver requestserver = Requestserver();

  late StateController stateController;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
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
                Text("أخبرنا عن اسمك عند استخدامك التطبيق"),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintTextDirection: TextDirection.rtl,
                    labelText: 'الاسم',
                    border: OutlineInputBorder(), // إضافة الحدود
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue, width: 2.0), // الحدود عند التركيز
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0), // الحدود عند التفعيل
                    ),
                  ),
                  onChanged: (value) {
                    stateController.update();
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: nameController.text.trim().length >= 2 &&
                          nameController.text.trim().length <= 20
                      ? () async {
                          sendPostRequestUpdateName();
                        }
                      : null,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      textAlign: TextAlign.center,
                      'حفظ',
                      style: TextStyle(
                          color: Colors.white, // Text color
                          fontFamily: 'bukraBold'),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green, // Set the background color to green
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius
                          .zero, // Make it rectangular (no rounded corners)
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0), // Optional padding
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> sendPostRequestUpdateName() async {
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
