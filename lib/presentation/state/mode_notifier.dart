import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeNotifier extends ChangeNotifier {
  final SharedPreferences _prefs;
  late bool _isProviderMode;

  ModeNotifier(this._prefs) {
    _isProviderMode = _prefs.getBool('isProviderMode') ?? false;
  }

  bool get isProviderMode => _isProviderMode;

  void toggleMode() {
    _isProviderMode = !_isProviderMode;
    _prefs.setBool('isProviderMode', _isProviderMode);
    notifyListeners();
  }
}