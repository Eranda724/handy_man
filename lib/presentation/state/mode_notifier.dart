import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeNotifier extends ChangeNotifier {
  final SharedPreferences _prefs;
  late bool _isProviderMode;
  late bool _isDarkMode;

  ModeNotifier(this._prefs) {
    _isProviderMode = _prefs.getBool('isProviderMode') ?? false;
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
  }

  bool get isProviderMode => _isProviderMode;
  bool get isDarkMode => _isDarkMode;

  void toggleMode() {
    _isProviderMode = !_isProviderMode;
    _prefs.setBool('isProviderMode', _isProviderMode);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
