// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:gl1/main.dart';
import 'package:gl1/shared/deviceInfo.dart';
import 'package:gl1/shared/tokeny.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

class Requestserver {
  // final StateController stateController;
  // Requestserver(this.stateController);

  Future<Map<String, dynamic>> getData1() async {
    final deviceInfo = DeviceInfo(navigatorKey.currentContext!);
    final info = await deviceInfo.getJsonString();
    return {
      'packageName': "com.yemen_restaurant.greenland",
      'appSha':
          "41:C7:4D:A4:15:03:35:83:84:62:54:9A:22:E6:39:DA:07:F9:60:05:44:CC:4C:5E:A2:02:74:34:BD:3A:E2:73",
      'appVersion': 1, // You can define the version manually for web
      'device_type_name': 'browser',
      'deviceId': deviceInfo.getDeviceId(),
      'deviceInfo': jsonEncode(info).toString(),
      'appDeviceToken': "t1",
    };
  }

  Future<void> request2({
    required Map<String, dynamic> body,
    required String url,
    required Function(int code, String fail) onFail,
    required Function(String data) onSuccess,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        // headers: {'Content-Type': 'application/json'},
        body: (body),
      );

      final data = response.body;
      // print("Data: $data");
      // print("URL: $url");

      switch (response.statusCode) {
        case 200:
          if (isJson(data)) {
            onSuccess(data);
          } else {
            onFail(response.statusCode, "not json");
          }
          break;
        case 400:
          if (isJson(data)) {
            final error = ErrorMessage.fromJson(json.decode(data));
            // handleErrorResponse(error);
            onFail(error.code, error.message.ar);
          } else {
            onFail(response.statusCode, "not json E");
          }
          break;
        default:
          onFail(response.statusCode, response.statusCode.toString());
      }
    } catch (e) {
      String errorMessage;
      if (e is http.ClientException) {
        errorMessage = "Failed to connect to server";
      } else if (e is TimeoutException) {
        errorMessage = "Request timed out";
      } else {
        errorMessage = e.toString();
      }
      onFail(0, "Request failed: $errorMessage");
      print("Exception: $e");
    }
  }

  bool isJson(String data) {
    try {
      json.decode(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isInit() {
    String? isInit = localStorage.getItem("1");
    if (isInit == null) {
      return false;
    }
    return true;
  }

  setInit() {
    Uuid uuid = const Uuid();
    localStorage.setItem("1", uuid.v4());
  }

  //
  bool isLogined() {
    String? isLogined = localStorage.getItem("2");
    if (isLogined == null) {
      return false;
    }
    return true;
  }

  setLogined(data) {
    final bytes = utf8.encode(data);
    localStorage.setItem("2", base64Encode(bytes));
  }

  TokenResult getLogined() {
    String? logined = localStorage.getItem("2");
    // Parse JSON string to Map
    final bytes = base64.decode(logined!);

    Map<String, dynamic> jsonMap = json.decode(utf8.decode(bytes));

    // Create TokenResult object
    TokenResult result = TokenResult.fromJson(jsonMap);
    return result;
  }
}

class Message {
  final String ar;
  final String en;

  Message({required this.ar, required this.en});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      ar: json['ar'] as String,
      en: json['en'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }
}

class ErrorMessage {
  final int code;
  final Message message;

  ErrorMessage({required this.code, required this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      code: json['code'] as int,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message.toJson(),
    };
  }
}
