import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/dashboard.dart';
import 'package:gl1/main.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                Image.asset(
                  'assets/images/image.png',
                  width: 100,
                  height: 100,
                ),
                //
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 24, fontFamily: 'bukraBold'),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                ),
                //
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      labelText: 'رقم الهاتف',
                      errorStyle:
                          TextStyle(fontFamily: 'bukraBold', fontSize: 6),
                      errorText: !stateController.isValidPhone
                          ? 'الرجاء إدخال رقم هاتف صحيح (يجب أن يتكون من 9 أرقام ويبدأ بـ 70, 71, 73, 77, أو 78)'
                          : null,

                      border: const OutlineInputBorder(), // إضافة الحدود
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.0), // الحدود عند التركيز
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0), // الحدود عند التفعيل
                      ),
                    ),
                    onChanged: (value) async {
                      stateController.checkIsValidPhone(value);
                    },
                  ),
                )
                //
                ,
                const Padding(
                  padding: EdgeInsets.all(4.0),
                ),

                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              // Use Expanded to prevent layout issues
                              child: TextField(
                                controller: passwordController,
                                // textDirection: TextDirection.rtl,
                                decoration: const InputDecoration(
                                  hintTextDirection: TextDirection.rtl,
                                  labelText: 'الرقم السري',
                                  border: OutlineInputBorder(), // إضافة الحدود
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 2.0), // الحدود عند التركيز
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0), // الحدود عند التفعيل
                                  ),
                                ),
                                onChanged: (value) {
                                  stateController.updatePassword(value);
                                },
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: stateController.password.length >= 4 &&
                              stateController.password.length <= 8 &&
                              stateController.isValidPhone &&
                              phoneController.text.length == 9
                          ? () async {
                              sendPostRequestLogin();
                            }
                          : null,
                      child: Text(
                        'دخول',
                        style: TextStyle(
                            color: Colors.white, // Text color
                            fontFamily: 'bukraBold'),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green, // Set the background color to green
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius
                              .zero, // Make it rectangular (no rounded corners)
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0), // Optional padding
                      ),
                    )
                  ],
                ),
                // رابط التسجيل
                Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ليس لدي حساب'),
                    TextButton(
                      onPressed: () {
                        // showDialog.value = true; // عرض حوار التسجيل
                        intentFunWhatsapp();
                      },
                      child: Text('اشتراك',
                          style: TextStyle(
                              fontFamily: 'bukraBold', color: Colors.blue)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),

                // رابط استعادة كلمة المرور
                TextButton(
                  onPressed: () async {
                    intentFunWhatsappForgetPassword();
                  },
                  child: Text('نسيت كلمة المرور؟',
                      style: TextStyle(
                          color: Colors.red, fontFamily: 'bukraBold')),
                ),

                // شروط الاستخدام
                const SizedBox(height: 80),
                const Text('من خلال تسجيل الدخول او الاشتراك فانك توافق على '),

                TextButton(
                  onPressed: () async {
                    final Uri uri = Uri.parse(
                        'https://greenland-rest.com/policies-terms.html');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: const Text('سياسة الاستخدام و شروط الخدمه',
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'bukraBold',
                      )),
                ),

                const SizedBox(height: 200),

                // نص حقوق النشر

                const Text('حقوق الطبع والنشر © 2024'),
              ]),
        ));
  }

  void intentFunWhatsapp() async {
    final String formattedNumber = "967781874077";
    final String message = "السلام عليكم";

    // Create the URI for the WhatsApp link
    final Uri uri = Uri.parse(
        "https://api.whatsapp.com/send?phone=$formattedNumber&text=${Uri.encodeComponent(message)}");

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void intentFunWhatsappForgetPassword() async {
    const String formattedNumber = "967780222271";
    const String message =
        "مرحبا بك, لقد نسيت كلمة المرور الخاصة بي الرجاء اعادة تعيينها شكرا لك";

    // Create the URI for the WhatsApp link
    final Uri uri = Uri.parse(
        "https://api.whatsapp.com/send?phone=$formattedNumber&text=${Uri.encodeComponent(message)}");

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("cant");
    }
  }

  Future<void> sendPostRequestLogin() async {
    const String url = '${Urls.root}login.php';

    stateController.startAud();
    final data1 = await requestserver.getData1();
    final data2 = {
      "inputUserPhone": phoneController.text.trim(),
      "inputUserPassword": passwordController.text.trim()
    };
    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateAUD(fail);
      },
      onSuccess: (data) {
        requestserver.setLogined(data);
        print(data);
        stateController.successStateAUD();
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (Route<dynamic> route) => false,
        );
      },
    );
  }
}
