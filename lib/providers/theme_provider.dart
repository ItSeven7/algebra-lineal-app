import 'package:flutter/material.dart';
import '../models/color_themes.dart';

//import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
//import 'package:cloud_firestore/cloud_firestore.dart';

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
