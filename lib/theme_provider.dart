import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Holds the current theme mode; defaults to light mode
  ThemeMode _themeMode = ThemeMode.light;

  // Getter to access the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Method to toggle between light and dark themes
  void toggleTheme() {
    // Switch between light and dark theme modes
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // Notify all listeners about the theme change
    notifyListeners();
  }
}
