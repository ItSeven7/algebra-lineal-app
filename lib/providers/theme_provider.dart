import 'package:flutter/material.dart';
import '../models/color_themes.dart';

String colorTema = '';

class ThemeNotifier extends ChangeNotifier {
  AppColorTheme _currentTheme;

  ThemeNotifier(this._currentTheme);

  AppColorTheme get currentTheme => _currentTheme;

  void updateTheme(AppColorTheme newTheme) {
    _currentTheme = newTheme;
    notifyListeners();
  }
}
