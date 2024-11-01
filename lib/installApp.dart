import 'package:flutter/material.dart';

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
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Container(
            child: Text("حمل التطبيق الان"),
          ),
        )
      ],
    ));
  }
}
