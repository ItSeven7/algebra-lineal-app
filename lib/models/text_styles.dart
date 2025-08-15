import 'package:flutter/material.dart';

class AppTextStyles {
  final ThemeData theme;

  AppTextStyles(this.theme);

  TextStyle get header10 => TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
        fontFamily: 'Poppins',
      );

  TextStyle get header => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
        fontFamily: 'Poppins',
      );

  static const TextStyle subHeader = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(242, 242, 242, 1),
    fontFamily: 'Poppins',
  );

  static const TextStyle subHeaderWithOpacity = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(242, 242, 242, 0.90),
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyTitleBlack = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyBlack = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyTitleWhite = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(242, 242, 242, 1),
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyWhite = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(242, 242, 242, 1),
    fontFamily: 'Roboto',
  );

  TextStyle get bodyColor => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: theme.primaryColor,
        fontFamily: 'Roboto',
      );

  static const TextStyle titleBlackDialog = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontFamily: 'Poppins',
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontFamily: 'Roboto',
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(63, 63, 63, 0.8),
    fontFamily: 'Roboto',
  );

  static const TextStyle cardTrailing = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(63, 63, 63, 0.7),
    fontFamily: 'Roboto',
  );

  static const TextStyle progressCardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(63, 63, 63, 0.7),
    fontFamily: 'Roboto',
  );
}
