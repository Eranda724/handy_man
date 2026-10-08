import 'package:flutter/material.dart';

class ModeNotifier extends ChangeNotifier {
  bool _isProviderMode = false;

  bool get isProviderMode => _isProviderMode;

  void toggleMode() {
    _isProviderMode = !_isProviderMode;
    notifyListeners();
  }
}