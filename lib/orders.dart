import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gl1/models/orderModel.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/orderStatus.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/userStorage.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final pageName = "orders";
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final Requestserver requestserver = Requestserver();

  late List<OrderModel> orders;

  // final ValueNotifier<bool> _isValidPhone = ValueNotifier<bool>(true);
  late StateController stateController;
  var isInitOrders = false;
  UserStorage userStorage = UserStorage();

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stateController.setPage(pageName);
      sendPostRequestGetOrders();
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
            onRead: sendPostRequestGetOrders,
            content: () {
              if (isInitOrders) {
                return mainContent();
              }
              return SizedBox();
            }));
  }

  mainContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Expanded(
              child: ListView.builder(
                itemCount: orders.length, // Two items per row
                itemBuilder: (context, index) {
                  final order = orders[index];
                  String message;
                  Color color;

                  switch (order.situationId) {
                    case SharedOrderStatus.ORDER_COMPLETED:
                      message = "تم انجاز الطلب"; // "Order completed"
                      color = Theme.of(context).primaryColor;
                      break;
                    case SharedOrderStatus.ORDER_CANCELED:
                      message = "تم الغاء الطلب"; // "Order canceled"
                      color = Colors.red;
                      break;
                    default:
                      message = "قيد المعالجة"; // "Processing"
                      color = Colors.grey;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Text("رقم الطلب: " + order.id),
                          Text("تاريخ الطلب: " + order.createdAt),
                          ElevatedButton(
                              onPressed: () {}, child: Text("عرض المنتجات")),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Divider(
                              thickness: 2,
                              color: Colors.blue,
                            ),
                          ),
                          if (order.situationId !=
                                  SharedOrderStatus.ORDER_COMPLETED &&
                              order.situationId !=
                                  SharedOrderStatus.ORDER_CANCELED)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(child: Text("كود استلام الطلب")),
                                  Expanded(child: Text(order.code.toString()))
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text("حالة الطلب")),
                                Expanded(
                                    child: Text(
                                  message,
                                  style: TextStyle(color: color),
                                )),
                                Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("تتبع الطلب")),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendPostRequestGetOrders() async {
    const String url = '${Urls.root}orders/';

    stateController.startRead();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3 = {
      "tag": "read",
      "orderBy": "name",
      "orderType": "ASC",
      "from": 0,
    };

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
        print(data);
        // final List<dynamic> jsonData = jsonDecode(data);
        // requestserver.setLogined(data);

        orders = OrderModel.decodeOrders(data);

        isInitOrders = true;

        stateController.successState();
      },
    );
  }
}
