import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String> error = ValueNotifier('');
  final ValueNotifier<bool> showDialog = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // أيقونة التطبيق
              Image.asset(
                'image.png',
                width: 100,
                height: 100,
              ),

              // العنوان
              const Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 24, fontFamily: 'bukraBold'),
                textAlign: TextAlign.center,
              ),

              // حقل رقم الهاتف
              Directionality(
                textDirection: TextDirection.rtl,
                child: ValueListenableBuilder<bool>(
                  valueListenable: ValueNotifier(true),
                  builder: (context, isValidPhone, _) {
                    return Column(
                      children: [
                        TextField(
                          controller: phoneController,
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            hintTextDirection: TextDirection.rtl,
                            labelText: 'رقم الهاتف',
                            errorText: !isValidPhone &&
                                    phoneController.text.length > 8
                                ? 'الرجاء إدخال رقم هاتف صحيح (يجب أن يتكون من 9 أرقام ويبدأ بـ 70, 71, 73, 77, أو 78)'
                                : null,

                            border: const OutlineInputBorder(), // إضافة الحدود
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
                            isValidPhone = RegExp(r'^7[0|1|3|7|8][0-9]{7}$')
                                .hasMatch(value);
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),

              // حقل الرقم السري

              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: isLoading,
                      builder: (context, loading, _) {
                        return Expanded(
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
                            obscureText: true,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: isLoading,
                      builder: (context, loading, _) {
                        return ElevatedButton(
                          onPressed: () {
                            if (!loading) {
                              // تنفيذ عملية تسجيل الدخول
                              // يجب إضافة المنطق هنا
                            }
                          },
                          child: loading
                              ? SizedBox(
                                  width: 24, // Set a width
                                  height: 24, // Set a height
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text('دخول'),
                        );
                      },
                    ),
                  ],
                ),
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
                    child: Text('اشتراك', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),

              // رابط استعادة كلمة المرور
              TextButton(
                onPressed: () async {
                  intentFunWhatsappForgetPassword();
                },
                child: Text('نسيت كلمة المرور؟',
                    style: TextStyle(color: Colors.red)),
              ),

              // شروط الاستخدام
              const SizedBox(height: 50),
              const Text('من خلال تسجيل الدخول او الاشتراك فانك توافق على '),

              TextButton(
                onPressed: () async {
                  // final Uri url = Uri.parse('https://greenland-rest.com/policies-terms.html');
                  // if (await canLaunch(url.toString())) {
                  //   await launch(url.toString());
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                },
                child: const Text('سياسة الاستخدام و شروط الخدمه',
                    style: TextStyle(color: Colors.blue)),
              ),

              const SizedBox(height: 200),

              // نص حقوق النشر

              const Text('حقوق الطبع والنشر © 2024'),
            ],
          ),
        ),
      ),
    );
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
    } else {
      print("cant");
    }
  }

  void intentFunWhatsappForgetPassword() async {
    final String formattedNumber = "967780222271";
    final String message =
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
}
