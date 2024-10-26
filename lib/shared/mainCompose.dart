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
              return const AlertDialog(
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

    if (stateController.isLoadingRead && page == stateController.page) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (stateController.isErrorRead && page == stateController.page) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(stateController.errorRead),
            ElevatedButton(
                onPressed: onRead, child: const Text("اعادة المحاولة"))
          ],
        ),
      );
    } else {
      return content();
    }
  }
}

Widget myButton(String text, Function()? onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
    ),
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontFamily: 'bukraBold'),
    ),
  );
}

Widget myButtonSmall(String text, Function()? onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        color: greenColor,
        width: 50,
        height: 20,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontFamily: 'bukraBold', fontSize: 8),
          ),
        ),
      ),
    ),
  );

  // ElevatedButton(
  //   onPressed: onPressed,
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: Colors.green,
  //     fixedSize: Size(20, 5),
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.zero,
  //     ),
  //     padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
  //   ),

  // );
}

final greenColor = Colors.green;
