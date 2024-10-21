import 'dart:html';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';

class DeviceInfo {
  // late WebBrowserInfo info;
  final BuildContext context;
  DeviceInfo(this.context);

  Future<String> getOSVersion() async {
    String osVersion = '';

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        osVersion = 'Android';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        osVersion = 'iOS';
      } else if (Theme.of(context).platform == TargetPlatform.windows) {
        osVersion = 'Windows';
      } else if (Theme.of(context).platform == TargetPlatform.macOS) {
        osVersion = 'macOS';
      } else if (Theme.of(context).platform == TargetPlatform.linux) {
        osVersion = 'Linux';
      } else {
        osVersion = 'Unknown OS';
      }
    } catch (e) {
      osVersion = 'Error retrieving OS version: $e';
    }

    return osVersion;
  }

  String extractBrowserInfo(String userAgent) {
    String browserName = "Unknown Browser";
    String version = "Unknown Version";

    // Check for various browsers in the user agent string
    if (userAgent.contains("Chrome")) {
      browserName = "Chrome";
      version = userAgent.split("Chrome/")[1].split(" ")[0];
    } else if (userAgent.contains("Firefox")) {
      browserName = "Firefox";
      version = userAgent.split("Firefox/")[1];
    } else if (userAgent.contains("Safari") && !userAgent.contains("Chrome")) {
      browserName = "Safari";
      version = userAgent.split("Version/")[1].split(" ")[0];
    } else if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
      browserName = "Internet Explorer";
      version = userAgent.split("MSIE ")[1].split(";")[0];
    } else if (userAgent.contains("Edg")) {
      browserName = "Microsoft Edge";
      version = userAgent.split("Edg/")[1].split(" ")[0];
    }

    // return "$browserName Version: $version";
    return version;
  }

  Future<String> getBrowserName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = (await deviceInfo.webBrowserInfo);
    final name = info.browserName;
    // return "${name.name}|${extractBrowserInfo(info.userAgent.toString())}";
    return "${name.name}";

    // return "name ${name.name}| version ${info.v}";

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // String osVersion = '';

    // try {
    //   if (Theme.of(context).platform == TargetPlatform.android) {
    //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //     osVersion =
    //         'Model ${androidInfo.model} Brand ${androidInfo.brand} version ${androidInfo.version.release}';
    //   } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //     osVersion =
    //         'Model ${iosInfo.name} name ${iosInfo.name}|${iosInfo.systemName} version ${iosInfo.systemVersion}';
    //   } else if (Theme.of(context).platform == TargetPlatform.windows) {
    //     // WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    //     osVersion = 'Windows..';
    //   } else if (Theme.of(context).platform == TargetPlatform.macOS) {
    //     // MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
    //     osVersion = 'macOS..';
    //   } else if (Theme.of(context).platform == TargetPlatform.linux) {
    //     // LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    //     osVersion = 'Linux ..';
    //   } else {
    //     osVersion = 'Unknown Info';
    //   }
    // } catch (e) {
    //   // final webInfo = (await deviceInfo.webBrowserInfo);
    //   // final inf = 'Name ${webInfo.browserName} version ${webInfo.appVersion}';
    //   osVersion = '${inf}|Error retrieving OS version: $e';
  }

  // return osVersion;

  String getBrowserVersion() {
    final userAgent = window.navigator.userAgent;
    final RegExp regex =
        RegExp(r'(opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)');
    final matchTest = regex.firstMatch(userAgent);

    if (matchTest != null) {
      final browser = matchTest.group(1);
      final version = matchTest.group(2);

      if (browser == "trident") {
        final RegExp rvRegex = RegExp(r'rv[ :]+(\d+)');
        final rvMatch = rvRegex.firstMatch(userAgent);
        return 'IE ${rvMatch?.group(1) ?? ''}';
      }
      if (browser == "chrome") {
        final operaRegex = RegExp(r'\b(OPR|Edge)\/(\d+)');
        final operaMatch = operaRegex.firstMatch(userAgent);
        if (operaMatch != null)
          return operaMatch.group(0)?.replaceAll('OPR', 'Opera') ?? '';
      }
      return '$browser $version';
    }
    return 'Unknown';
  }

  String getDeviceId() {
    const String deviceIdKey = 'did';
    String? storedId = localStorage.getItem(deviceIdKey);

    if (storedId == null) {
      final id = getUniqueId(4);
      window.localStorage[deviceIdKey] = id;
      return id;
    } else {
      return storedId;
    }
  }

  Future<Map<String, String>> getJsonString() async {
    final browserInfo = await getBrowserName();
    // print(browserInfo);
    final deviceInfo = await getOSVersion();
    print(deviceInfo);
    final data = {'deviceInfo': deviceInfo, 'browserInfo': browserInfo};

    return data;
    // jsonEncode(data);
  }

  String getUniqueId(int parts) {
    final StringBuffer stringBuffer = StringBuffer();
    Uuid uuid = const Uuid();

    for (int i = 0; i < parts; i++) {
      if (i > 0) stringBuffer.write('');
      stringBuffer.write(uuid.v4().substring(0, 4)); // Generate 4 characters
    }

    return stringBuffer.toString();
  }
}
