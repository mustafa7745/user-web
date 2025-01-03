import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gl1/cart.dart';
import 'package:gl1/main.dart';
import 'package:gl1/models/categoryModel.dart';
import 'package:gl1/models/homeComponent.dart';
import 'package:gl1/models/userModel.dart';
import 'package:gl1/orders.dart';
import 'package:gl1/products.dart';
import 'package:gl1/search.dart';
import 'package:gl1/shared/loading.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/homeComponentStorage.dart';
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
            padding: 0,
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
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate the item height based on the screen height
    // Adjust the number of rows as needed
    final itemHeight = (screenHeight - AppBar().preferredSize.height - 20) /
        3; // Assuming 3 rows

    return Column(
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
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 7),
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
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                goToCart();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text((cartController.products.length +
                                              cartController.offers.length)
                                          .toString()),
                                      Icon(Icons.shopping_cart, size: 30),
                                    ],
                                  ),
                                  Text("السلة")
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                goToOrders();
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.stacked_bar_chart, size: 30),
                                  Text("الطلبات")
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                goToSearch();
                              },
                              child: Column(
                                children: [
                                  Icon(Icons.search, size: 30),
                                  Text("البحث")
                                ],
                              ),
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
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              childAspectRatio: 0.85, // Adjust as needed for item shape
              crossAxisSpacing: 10, // Space between columns
              mainAxisSpacing: 10, // Space between rows
            ),
            itemCount: homeComponent.categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(
                  context, homeComponent.categories[index]);
            },
          ),
        ),
      ],
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

  goToOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrdersPage()),
    );
  }

  goToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage()),
    );
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsPage(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(category.name),
        //     duration: const Duration(seconds: 2),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: Colors.red,
        //   ),
        // );
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0), // Rounded top-left corner
                  topRight: Radius.circular(12.0), // Rounded top-right corner
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: category.categoryImagePath + category.image,
                    placeholder: (context, url) =>
                        LoadingWidget(), // Loading indicator
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error), // Error widget
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(category.name),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendPostRequestGetHome() async {
    final homeComponentStorage = HomeComponentStorage();
    // read(homeComponentStorage);
    if (homeComponentStorage.isSetHomeComponent()) {
      // final current Date
      final diff = getCurrentDate().difference(homeComponentStorage.getDate());
      // print(diff);
      // print(diff.inMinutes);
      // print(getCurrentDate());
      // print(homeComponentStorage.getDate());
      if (diff.inMinutes > 200) {
        read(homeComponentStorage);
      } else {
        homeComponent = homeComponentStorage.getHomeComponent();
        isInitalHomeComponent = true;
      }
    } else {
      read(homeComponentStorage);
    }
  }

  read(HomeComponentStorage homeComponentStorage) async {
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
        homeComponentStorage.setHomeComponent(jsonEncode(homeComponent));

        isInitalHomeComponent = true;
        // print(homeComponent.categories.first.);
        stateController.successState();

        if (homeComponent1.user!.name2 == null) {
          await goToAddName();
        }
      },
    );
  }
}

goToCart() {
  Navigator.push(
    navigatorKey.currentContext!,
    MaterialPageRoute(builder: (context) => CartPage()),
  );
}
