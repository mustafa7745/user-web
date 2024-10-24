import 'dart:convert';
import 'package:gl1/models/userLocationMdel.dart';
import 'package:gl1/models/userModel.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class UserStorage {
  static const String userKey = "user";
  static const String userLocationKey = "userLocation";
  static const String dateKey = "dateKey";

  isSetUser() {
    try {
      getUser();
      return true;
    } catch (e) {
      setUser("");
      return false;
    }
  }

  setUser(String user) {
    localStorage.setItem(userKey, user);
  }

  User getUser() {
    // final prefs = await _getPrefs();
    String? userData = localStorage.getItem(userKey);

    return User.fromJson(jsonDecode(userData!));
  }

  isSetUserLocation() {
    try {
      getUserLocation();
      return true;
    } catch (e) {
      setUserLocation("");
      return false;
    }
  }

  setUserLocation(String userLocation) {
    String currentDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    localStorage.setItem(dateKey, currentDate);
    localStorage.setItem(userLocationKey, userLocation);
  }

  UserLocationModel getUserLocation() {
    String? locationData = localStorage.getItem(userLocationKey);

    return UserLocationModel.fromJson(jsonDecode(locationData!));
  }

  DateTime getDateLocation() {
    String? dateString = localStorage.getItem(dateKey);
    return DateTime.parse(dateString!);
  }

  setDateLocation() {
    setUserLocation(""); // Assuming you're setting an empty location
  }
}

// User model classes (replace with your actual implementations)

