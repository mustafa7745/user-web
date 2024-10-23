import 'dart:convert';
import 'package:gl1/models/homeComponent.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class HomeComponentStorage {
  static const String homeComponentKey = "homeComponent";
  static const String dateKey = "2HCD"; //DATE

  isSetHomeComponent() {
    try {
      getHomeComponent();
      return true;
    } catch (e) {
      // setHomeComponent("");
      return false;
    }
  }

  HomeComponent getHomeComponent() {
    // final prefs = await _getPrefs();
    String? homeComponentData = localStorage.getItem(homeComponentKey);

    return HomeComponent.fromJson(jsonDecode(homeComponentData!));
  }

  setHomeComponent(String homeComponent) {
    // print(getCurrentDate().toString());
    localStorage.setItem(dateKey, getCurrentDate().toString());
    localStorage.setItem(homeComponentKey, homeComponent);
  }

  HomeComponentLocationModel getHomeComponentDate() {
    String? locationData = localStorage.getItem(dateKey);

    return HomeComponentLocationModel.fromJson(jsonDecode(locationData!));
  }

  DateTime getDate() {
    String? dateString = localStorage.getItem(dateKey);
    // print(object)
    final date = (DateTime.parse(dateString!));

    return date;
  }
}

// HomeComponent model classes (replace with your actual implementations)

class HomeComponentLocationModel {
  // Add your HomeComponentLocationModel properties and methods here
  HomeComponentLocationModel.fromJson(Map<String, dynamic> json) {
    // Parse JSON
  }
}

DateTime getCurrentDate() {
  // String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  return DateTime.now();
}
