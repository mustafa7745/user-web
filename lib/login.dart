import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            ValueListenableBuilder<bool>(
              valueListenable: ValueNotifier(true),
              builder: (context, isValidPhone, _) {
                return Column(
                  children: [
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        errorText: !isValidPhone &&
                                phoneController.text.length > 8
                            ? 'الرجاء إدخال رقم هاتف صحيح (يجب أن يتكون من 9 أرقام ويبدأ بـ 70, 71, 73, 77, أو 78)'
                            : null,
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        isValidPhone =
                            RegExp(r'^7[0|1|3|7|8][0-9]{7}$').hasMatch(value);
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                );
              },
            ),

            // حقل الرقم السري
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, loading, _) {
                return TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'الرقم السري',
                  ),
                  obscureText: true,
                );
              },
            ),

            // زر الدخول
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
                  child: loading ? CircularProgressIndicator() : Text('دخول'),
                );
              },
            ),

            // رابط التسجيل
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ليس لدي حساب'),
                TextButton(
                  onPressed: () {
                    showDialog.value = true; // عرض حوار التسجيل
                  },
                  child: Text('اشتراك', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),

            // رابط استعادة كلمة المرور
            TextButton(
              onPressed: () async {
                // final Uri url = Uri.parse('https://example.com/forgot-password');
                // if (await canLaunch(url.toString())) {
                //   await launch(url.toString());
                // } else {
                //   throw 'Could not launch $url';
                // }
              },
              child: Text('نسيت كلمة المرور؟',
                  style: TextStyle(color: Colors.red)),
            ),

            // شروط الاستخدام
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('من خلال تسجيل الدخول او الاشتراك فانك توافق على '),
                TextButton(
                  onPressed: () async {
                    // final Uri url = Uri.parse('https://greenland-rest.com/policies-terms.html');
                    // if (await canLaunch(url.toString())) {
                    //   await launch(url.toString());
                    // } else {
                    //   throw 'Could not launch $url';
                    // }
                  },
                  child: Text('سياسة الاستخدام',
                      style: TextStyle(color: Colors.blue)),
                ),
                Text(' و '),
                TextButton(
                  onPressed: () async {
                    // final Uri url = Uri.parse('https://greenland-rest.com/policies-terms.html');
                    // if (await canLaunch(url.toString())) {
                    //   await launch(url.toString());
                    // } else {
                    //   throw 'Could not launch $url';
                    // }
                  },
                  child:
                      Text('شروط الخدمة', style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),

            // نص حقوق النشر
            Spacer(),
            Text('حقوق الطبع والنشر © 2024'),
          ],
        ),
      ),
    );
  }
}
