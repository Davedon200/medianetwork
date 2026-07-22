import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const _storageKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.dark;
  bool _initialized = false;

  ThemeMode get mode => _mode;
  bool get isInitialized => _initialized;
  bool get isDark => _mode == ThemeMode.dark;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);
    _mode = switch (stored) {
      'light' => ThemeMode.light,
      _ => ThemeMode.dark,
    };
    _initialized = true;
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }

  Future<void> toggle() {
    return setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
