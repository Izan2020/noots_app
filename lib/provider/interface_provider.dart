import 'package:flutter/material.dart';

class InterfaceProvider extends ChangeNotifier {
  bool _isDeleteMode = false;
  bool get isDeleteMode => _isDeleteMode;

  void setDeleteMode() {
    _isDeleteMode = !_isDeleteMode;
    notifyListeners();
  }

  void clearDeleteMode() {
    _isDeleteMode = false;
    notifyListeners();
  }
}
