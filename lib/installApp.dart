import 'package:flutter/material.dart';
import 'package:gl1/main.dart';
import 'dart:js' as js;

class InstallAppPage extends StatefulWidget {
  @override
  State<InstallAppPage> createState() => _InstallAppPageState();
}

class _InstallAppPageState extends State<InstallAppPage> {
  final pageName = "installApp";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (isInstallPromptAvailable()) {
            js.context.callMethod('showInstallPrompt');
          }
        },
        child: Card(
          elevation: 4, // Shadow effect
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Container(
            padding: EdgeInsets.all(16.0), // Padding inside the card
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "تحميل",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10), // Space between text and image
                  Image.asset(
                    'assets/images/image.png',
                    width: 50,
                    height: 50,
                  ),
                  Image.asset(
                    'images/apple.jpg',
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
