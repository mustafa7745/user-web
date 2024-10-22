import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gl1/main.dart';
import 'package:gl1/models/categoryModel.dart';
import 'package:gl1/models/homeComponent.dart';
import 'package:gl1/models/userModel.dart';
import 'package:gl1/shared/imageWidget.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/userStorage.dart';
import 'package:gl1/updateName.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final pageName = "dashboard";
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final Requestserver requestserver = Requestserver();

  late HomeComponent homeComponent;

  // final ValueNotifier<bool> _isValidPhone = ValueNotifier<bool>(true);
  late StateController stateController;
  var isInitalHomeComponent = false;
  UserStorage userStorage = UserStorage();

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      sendPostRequestGetHome();
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
      child: Column(
        children: [
          if (homeComponent.user != null)
            // homeComponent.user!.name2 == null ?
            SizedBox(
              width: double.infinity,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color

                    borderRadius: BorderRadius.only(
                      bottomLeft:
                          Radius.circular(12.0), // Rounded top-left corner
                      bottomRight:
                          Radius.circular(12.0), // Rounded top-right corner
                    ),
                    border: Border.all(
                        color: Colors.grey, width: 1), // Border color and width
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.person, size: 30),
                            // child: SvgPicture.asset(
                            //   'images/user.svg', // Path to your SVG file
                            //   width: 24,
                            //   height: 24,
                            // ),
                          ),
                          Text(
                              "مرحبا بك: ${homeComponent.user!.name2 ?? homeComponent.user!.name}"),
                        ],
                      ),
                      if (homeComponent.user!.name2 == null)
                        InkWell(
                          onTap: () async {
                            await goToAddName();
                          },
                          child: Text(
                            "لم يتم تعيين الاسم بعد , تعيين الان",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 7),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                toast("cart");
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.shopping_cart, size: 30),
                                  Text("السلة")
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                toast("orders");
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.stacked_bar_chart, size: 30),
                                  Text("الطلبات")
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                toast("search");
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.search, size: 30),
                                  Text("البحث")
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

          // Text("مرحبا بك: " + homeComponent.user!.name2.toString()),
          Expanded(
            child: Container(
              // height: double.infinity,
              child: ListView.builder(
                itemCount: (homeComponent.categories.length / 2)
                    .ceil(), // Two items per row
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // First item
                      _buildCategoryItem(
                          context, homeComponent.categories[index * 2]),

                      // Second item

                      if (index * 2 + 1 <
                          homeComponent.categories
                              .length) // Check if the second item exists
                        _buildCategoryItem(
                            context, homeComponent.categories[index * 2 + 1])
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> goToAddName() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateNamePage()),
    );

    // Show the returned value
    if (result != null) {
      // print(result);
      final user = User.fromJson(jsonDecode(result));
      userStorage.setUser(result);
      homeComponent.user = user;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        stateController.setPage(pageName);
        stateController.update();
        toast("تمت الاضافة بنجاح");
      });
    }
  }

  toast(text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  // Widget for building category items
  Widget _buildCategoryItem(BuildContext context, CategoryModel category) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(category.name),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            border: Border.all(
                color: Colors.grey, width: 1), // Border color and width
          ),
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0), // Rounded top-left corner
                    topRight: Radius.circular(12.0), // Rounded top-right corner
                  ),
                  child: CachedNetworkImage(
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    imageUrl: category.categoryImagePath + category.image,
                    placeholder: (context, url) =>
                        CircularProgressIndicator(), // Loading indicator
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // Error widget
                  ),
                ),
                Text(category.name),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendPostRequestGetHome() async {
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
      onSuccess: (data) async {
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
        if (homeComponent1.user!.name2 == null) {
          await goToAddName();
        }
      },
    );
  }
}
