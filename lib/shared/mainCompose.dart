import 'package:flutter/material.dart';
import 'package:gl1/shared/stateController.dart';

class MainCompose extends StatelessWidget {
  final double padding;
  final StateController stateController;
  final Widget Function() content;
  final Future<void> Function()? onRead;
  final String page;

  MainCompose({
    required this.padding,
    required this.stateController,
    required this.content,
    this.onRead,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    // Check if there's an error and show a SnackBar if so
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (stateController.isErrorAUD && page == stateController.page) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(stateController.errorAUD),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        stateController.resetIsErrorAud();
      }
      if (stateController.isLoadingAUD && page == stateController.page) {
        // Show dialog when loading state changes
        Future.microtask(() {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text("Loading..."),
                  ],
                ),
              );
            },
          );
        });
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("object");
    //   print(stateController.isLoadingAUD);

    // });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: padding), // Top padding

        if (stateController.isLoadingRead && page == stateController.page)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (stateController.isErrorRead && page == stateController.page)
          Center(
            child: Column(
              children: [
                Text(stateController.errorRead),
                ElevatedButton(onPressed: onRead, child: Text("اعادة المحاولة"))
              ],
            ),
          )
        else
          Expanded(child: content()),
      ],
    );
  }
}
