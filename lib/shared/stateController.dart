import 'package:flutter/material.dart';
import 'package:gl1/main.dart';

class StateController extends ChangeNotifier {
  // State variables for reading
  bool _isLoadingRead = false;
  bool _isSuccessRead = false;
  bool _isErrorRead = false;
  String _errorRead = "";

  // State variables for AUD
  bool _isLoadingAUD = false;
  bool _isErrorAUD = false;
  String _errorAUD = "";
  String _page = "";

  // Getters for the read state
  bool get isLoadingRead => _isLoadingRead;
  bool get isSuccessRead => _isSuccessRead;
  bool get isErrorRead => _isErrorRead;
  String get errorRead => _errorRead;

  // Getters for the AUD state
  bool get isLoadingAUD => _isLoadingAUD;
  bool get isErrorAUD => _isErrorAUD;
  String get errorAUD => _errorAUD;

  String get page => _page;
  // Start read process
  void startRead() {
    _isErrorRead = false;
    _errorRead = "";
    _isLoadingRead = true;
    notifyListeners(); // Notify listeners of state change
  }

  // Handle read error
  void errorStateRead(String e) {
    _isLoadingRead = false;
    _isErrorRead = true;
    _errorRead = e;
    notifyListeners();
  }

  // Handle read success
  void successState() {
    _isLoadingRead = false;
    _isSuccessRead = true;
    _isErrorRead = false;
    notifyListeners();
  }

  // Start AUD process
  void startAud() {
    _errorAUD = "";
    _isLoadingAUD = true;
    _isErrorAUD = false;
    notifyListeners();
  }

  // Handle AUD error
  void errorStateAUD(String e) {
    _isLoadingAUD = false;
    _isErrorAUD = true;
    _errorAUD = e;
    Navigator.of(navigatorKey.currentContext!).pop();
    notifyListeners();
  }

  resetIsErrorAud() {
    _isErrorAUD = false;
    _errorAUD = "";
  }

  // Handle AUD success
  void successStateAUD() {
    _isLoadingAUD = false;
    _isErrorAUD = false;
    Navigator.of(navigatorKey.currentContext!).pop();
    notifyListeners();
  }

  bool isValidPhone = true;
  String password = "";
  void checkIsValidPhone(phone1) {
    isValidPhone =
        RegExp(r'^7[0|1|3|7|8][0-9]{7}$').hasMatch(phone1) && phone1.length > 8;
    notifyListeners();
  }

  void updatePassword(value) {
    password = value;
    notifyListeners();
  }

  setPage(value) {
    _page = value;
    notifyListeners();
  }

  update() {
    notifyListeners();
  }
}
