import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String _name = "Name";
  String get name => _name;

  void chageName() {
    _name = "Name1";
    notifyListeners();
  }
}
