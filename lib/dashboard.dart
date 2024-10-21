import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gl1/models/homeComponent.dart';
import 'package:gl1/models/userModel.dart';
import 'package:gl1/shared/imageWidget.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/userStorage.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final Requestserver requestserver = Requestserver();

  late HomeComponent homeComponent;

  // final ValueNotifier<bool> _isValidPhone = ValueNotifier<bool>(true);
  late StateController stateController;
  var isInitalHomeComponent = false;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sendPostRequestGetHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);
    return Scaffold(
        body: MainCompose(
            padding: 10,
            stateController: stateController,
            onRead: sendPostRequestGetHome,
            content: () {
              if (isInitalHomeComponent) {
                return mainContent();
              }
              return SizedBox();
            }));
  }

  mainContent() {
    // final String proxyUrl = 'https://cors-anywhere.herokuapp.com/';
    // final String imageUrl =
    //     'https://greenland-rest.com/v1/include/images/categories/52897402766f279af1abdd.jpg';

    // final String fullUrl = proxyUrl + imageUrl;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount:
            (homeComponent.categories.length / 2).ceil(), // Two items per row
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // First item
              Expanded(
                child: Container(
                  // padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                    border: Border.all(
                        color: Colors.grey, width: 1), // Border color and width
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                12.0), // Rounded top-left corner
                            topRight: Radius.circular(
                                12.0), // Rounded top-right corner
                          ),
                          child: CachedNetworkImage(
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            imageUrl: homeComponent
                                    .categories[index * 2].categoryImagePath +
                                homeComponent.categories[index * 2].image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(), // Loading indicator
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error), // Error widget
                          ),
                        ),
                        Text(homeComponent.categories[index * 2].name),
                      ],
                    ),
                  ),
                ),
              ),
              // Second item
              if (index * 2 + 1 <
                  homeComponent
                      .categories.length) // Check if the second item exists
                Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              homeComponent.categories[index * 2 + 1].name),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    child: Container(
                      // padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                        border: Border.all(
                            color: Colors.grey,
                            width: 1), // Border color and width
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    12.0), // Rounded top-left corner
                                topRight: Radius.circular(
                                    12.0), // Rounded top-right corner
                              ),
                              child: CachedNetworkImage(
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.fill,
                                imageUrl: homeComponent
                                        .categories[index * 2 + 1]
                                        .categoryImagePath +
                                    homeComponent
                                        .categories[index * 2 + 1].image,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(), // Loading indicator
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error), // Error widget
                              ),
                            ),
                            Text(homeComponent.categories[index * 2 + 1].name),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
    // return Padding(
    //     padding: EdgeInsets.all(16.0),
    //     child: ListView.builder(
    //       itemCount: homeComponent.categories.length,
    //       itemBuilder: (context, index) {
    //         return Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             // First item
    //             Expanded(
    //               child: Container(
    //                 padding: EdgeInsets.all(8.0),
    //                 child: Center(
    //                   child: Column(
    //                     children: [
    //                       SizedBox(
    //                           height: 120,
    //                           width: 120,
    //                           child: CachedNetworkImage(
    //                               imageUrl: homeComponent
    //                                       .categories[index].categoryImagePath +
    //                                   homeComponent
    //                                       .categories[index + 1].image)),
    //                       Text(homeComponent.categories[index].name),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         );
    //       },
    //     ));

    // return ListTile(
    //   title: Text(homeComponent.categories[index].name),
    // );
  }

  Future<void> sendPostRequestGetHome() async {
    UserStorage userStorage = UserStorage();
    const String url = '${Urls.root}home/';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3;
    if (userStorage.isSetUser()) {
      data3 = {"tag": "read"};
    } else {
      data3 = {"tag": "readWithUser2"};
    }

    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2),
      "data3": jsonEncode(data3)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateRead(fail);
      },
      onSuccess: (data) {
        // requestserver.setLogined(data);
        HomeComponent homeComponent1 =
            HomeComponent.fromJson(json.decode(data));
        if (homeComponent1.user != null) {
          userStorage.setUser(jsonEncode(homeComponent1.user));
        } else {
          homeComponent1.user = userStorage.getUser();
        }
        homeComponent = homeComponent1;
        isInitalHomeComponent = true;
        print(homeComponent.user?.name.toString());
        // print(homeComponent.categories.first.);
        stateController.successState();
        // Navigator.pushAndRemoveUntil(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(builder: (context) => DashboardPage()),
        //   (Route<dynamic> route) => false,
        // );
      },
    );
  }
}

HtmlImageWidget htmlWidget(imageUrl) {
  return HtmlImageWidget(
    imageUrl: imageUrl,
    height: "100%",
    width: "100%",
  );
}
