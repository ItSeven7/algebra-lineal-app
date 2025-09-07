import 'package:flutter/material.dart';

enum AppColorTheme {
  rojo,
  indigo,
  purpura,
  azulMarino,
  verdeTeal,
  purpuraOscuro,
  marron,
  grisCarbon,
  magenta,
  lavandaAzul,
}

final Map<AppColorTheme, Color> appThemeColors = {
  AppColorTheme.rojo: const Color(0xFFE4484B),
  AppColorTheme.indigo: const Color(0xFF3F51B5),
  AppColorTheme.purpura: const Color(0xFF7E57C2),
  AppColorTheme.azulMarino: const Color(0xFF2E3B55),
  AppColorTheme.verdeTeal: const Color(0xFF00897B),
  AppColorTheme.purpuraOscuro: const Color(0xFF5E35B1),
  AppColorTheme.marron: const Color(0xFF6D4C41),
  AppColorTheme.grisCarbon: const Color(0xFF37474F),
  AppColorTheme.magenta: const Color(0xFFD81B60),
  AppColorTheme.lavandaAzul: const Color(0xFF7986CB),
};

class ColorsUI {
  static const backgroundColor = Color(0xFFEEEEEE);
  static const selectedIcon = Color(0xFFEEEEEE);
  static const unSelectedIcon = Color.fromRGBO(238, 238, 238, 0.7);
}
