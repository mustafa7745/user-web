import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gl1/main.dart';
import 'package:gl1/models/locationTypeModel.dart';
import 'package:gl1/shared/locationService.dart';
import 'package:gl1/shared/mainCompose.dart';
import 'package:gl1/shared/requestServer.dart';
import 'package:gl1/shared/stateController.dart';
import 'package:gl1/shared/urls.dart';
import 'package:gl1/storage/userStorage.dart';
import 'package:provider/provider.dart';

import 'dart:js' as js;

var isEnabled = false;
bool? isAllowd;
String? latLong;
String? errorLatLong;

List<LocationTypeModel>? locationTypes;
LocationTypeModel? selectedLocationTypes;

class addUserLocationPage extends StatefulWidget {
  @override
  State<addUserLocationPage> createState() => _addUserLocationPageState();
}

class _addUserLocationPageState extends State<addUserLocationPage> {
  final pageName = "addUserLocation";
  UserStorage userStorage = UserStorage();

  final TextEditingController streetController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  late TextEditingController phoneController;

  final Requestserver requestserver = Requestserver();

  late StateController stateController;
  late LocationService locationService;

  @override
  void initState() {
    super.initState();
    // Call sendPostRequestInit after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      stateController.setPage(pageName);
      // final isEnabled =

      isEnabled = await Geolocator.isLocationServiceEnabled();
      phoneController =
          TextEditingController(text: userStorage.getUser().phone);
      // if (!isEnabled) {
      //   // Navigator.pop(context);
      //   // stateController.errorStateAUD("يجب تفعيل الموقع للمتابعة");
      // }
      //else {

      // }

      // js.context.callMethod('isGeolocationEnabled') as bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    stateController = Provider.of<StateController>(context);
    locationService = LocationService();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: greenColor,
          foregroundColor: Colors.white,
          title: Text("اضافة موقع"),
        ),
        body: MainCompose(
          page: pageName,
          padding: 10,
          stateController: stateController,
          content: () {
            return mainContent();
          },
        ),
      ),
    );
  }

  Widget mainContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                if (isEnabled) onServiceEnabled() else onServiceNotEnabled()
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget onServiceNotEnabled() {
    return Center(
      child: Column(
        children: [
          Text("افتح الموقع واضغط على اعادة المحاولة"),
          myButton("اعادة المحاولة", () async {
            isEnabled = await Geolocator.isLocationServiceEnabled();
            stateController.update();
          })
        ],
      ),
    );
  }

  Widget onServiceEnabled() {
    return Center(
      child: Column(
        children: [
          if (isAllowd != null)
            Column(
              children: [
                if (isAllowd == false)
                  onServiceNotAllowed()
                else
                  Card(
                    child: onServiceAllowed(),
                  )
              ],
            )
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("تأكد من تشغيل ال GPS"),
                    ),
                    myButton("السماح للموقع بتحديد عنوان التوصيل", () async {
                      stateController.startAud();
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);

                      latLong = "${position.latitude},${position.longitude}";
                      // 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
                      isAllowd = true;
                      stateController.successStateAUD();
                    }),
                  ],
                )),
              ],
            ),
          if (errorLatLong != null)
            Text('Error retrieving location: $errorLatLong'),
        ],
      ),
    );
  }

  onServiceAllowed() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "اخبرنا عن موقع توصيل طلبك بالتحديد",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: streetController,
            decoration: const InputDecoration(
              hintTextDirection: TextDirection.rtl,
              labelText: 'الشارع',
              border: OutlineInputBorder(), // إضافة الحدود
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue, width: 2.0), // الحدود عند التركيز
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: 1.0), // الحدود عند التفعيل
              ),
            ),
            onChanged: (value) {
              stateController.update();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: descController,
            decoration: const InputDecoration(
              hintTextDirection: TextDirection.rtl,
              labelText: 'بالقرب من او جوار مركز معروف',
              border: OutlineInputBorder(), // إضافة الحدود
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue, width: 2.0), // الحدود عند التركيز
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: 1.0), // الحدود عند التفعيل
              ),
            ),
            onChanged: (value) {
              stateController.update();
            },
            maxLines: 3,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: myButton(
                selectedLocationTypes != null
                    ? 'نوع موقع التوصيل' + " : " + selectedLocationTypes!.name
                    : 'نوع موقع التوصيل', () {
              if (locationTypes != null) {
                openDailogChooseType();
              } else
                sendPostRequestReadTypes();
            })),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              hintTextDirection: TextDirection.rtl,
              labelText: 'رقم الهاتف للتواصل معه',
              border: OutlineInputBorder(), // إضافة الحدود
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.blue, width: 2.0), // الحدود عند التركيز
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: 1.0), // الحدود عند التفعيل
              ),
            ),
            onChanged: (value) {
              stateController.update();
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: myButton("حفظ", () {
              sendPostRequestaddUserLocation();
            }))
      ],
    );
  }

  onServiceNotAllowed() {
    Navigator.pop(navigatorKey.currentContext!);
    stateController.errorStateAUD("لم يتم منح الوصول");
    return ElevatedButton(
        onPressed: () async {
          // stateController.startAud();
          // Position position = await Geolocator.getCurrentPosition(
          //     desiredAccuracy: LocationAccuracy.high);

          // latLong =
          //     'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
          // isAllowd = true;
          // stateController.successState();
        },
        child: Text("السماح للموقع"));
  }

  Future<void> sendPostRequestaddUserLocation() async {
    const String url = '${Urls.root}users_locations/';

    stateController.startAud();
    final data1 = await requestserver.getData1();
    final data2 = requestserver.getData2Token();
    final data3 = {
      "tag": "add",
      "inputUserLocationCity": "صنعاء",
      "inputUserLocationStreet": streetController.text.trim(),
      "inputUserLocationLatLong": latLong!,
      "inputUserLocationNearTo": descController.text.trim(),
      "inputUserLocationContactPhone": phoneController.text.trim(),
      if (selectedLocationTypes != null)
        "inputLocationTypeId": selectedLocationTypes!.id,
    };
    // Map<String, String> formData = {"data1": json.encode(data1)};
    Map<String, String> formData = {
      "data1": jsonEncode(data1),
      "data2": jsonEncode(data2),
      "data3": jsonEncode(data3)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateAUD(fail);
      },
      onSuccess: (data) {
        stateController.successStateAUD();
        Navigator.pop(navigatorKey.currentContext!, data);
      },
    );
  }

  Future<void> sendPostRequestReadTypes() async {
    const String url = '${Urls.root}location_types/';

    stateController.startAud();
    // final data1 = await requestserver.getData1();
    // final data2 = requestserver.getData2Token();
    final data3 = {
      "tag": "read",
    };
    // Map<String, String> formData = {"data1": json.encode(data1)};
    Map<String, String> formData = {
      // "data1": jsonEncode(data1),
      // "data2": jsonEncode(data2),
      "data3": jsonEncode(data3)
    };

    requestserver.request2(
      body: formData,
      url: url,
      onFail: (code, fail) {
        stateController.errorStateAUD(fail);
      },
      onSuccess: (data) {
        locationTypes = LocationTypeModel.locationTypeModelFromJson(data);
        stateController.successStateAUD();
        openDailogChooseType();
      },
    );
  }

  openDailogChooseType() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: ListView.builder(
                  itemCount: locationTypes!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final locationType = locationTypes![index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: myButton(
                          locationType.name,
                          () {
                            selectedLocationTypes = locationType;
                            stateController.update();
                            Navigator.pop(context);
                          },
                        ));
                  }));
        });
  }
}
