import 'package:flutter/material.dart';

class AppTextStyles {
  final ThemeData theme;

  AppTextStyles(this.theme);

  /// `
  /// Size: 36,
  /// Color: Primary Color,
  /// Opacity: 100%,
  /// Font: Poppins
  /// `
  TextStyle get header1 => TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
        fontFamily: 'Poppins',
      );
  
  /// `
  /// Size: 20,
  /// Color: Primary Color,
  /// Opacity: 100%,
  /// Font: Poppins
  /// `
  TextStyle get header2 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
        fontFamily: 'Poppins',
      );

  /// `
  /// Size: 20,
  /// Color: White 242,
  /// Opacity: 100%,
  /// Font: Poppins
  /// `
  static const TextStyle header3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(242, 242, 242, 1),
    fontFamily: 'Poppins',
  );

  /// `
  /// Size: 18,
  /// Color: White 242,
  /// Opacity: 90%,
  /// Weight; SemiBold,
  /// Font: Poppins
  /// `
  static const TextStyle header4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(242, 242, 242, 0.90),
    fontFamily: 'Poppins',
  );

  /// `
  /// Size: 18,
  /// Color: Black 36,
  /// Opacity: 100%,
  /// Weight: SemiBold,
  /// Font: Poppins
  /// `
  static const TextStyle bodyTitleBlack = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(36, 36, 36, 1),
    fontFamily: 'Poppins',
  );

  /// `
  /// Size: 16,
  /// Color: Black 63,
  /// Opacity: 80%,
  /// Weight: Normal,
  /// Font: Roboto
  /// `
  static const TextStyle bodyBlack = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontFamily: 'Roboto',
  );

  // static const TextStyle bodyTitleWhite = TextStyle(
  //   fontSize: 15,
  //   fontWeight: FontWeight.bold,
  //   color: Color.fromRGBO(242, 242, 242, 1),
  //   fontFamily: 'Roboto',
  // );

  // static const TextStyle bodyWhite = TextStyle(
  //   fontSize: 15,
  //   fontWeight: FontWeight.normal,
  //   color: Color.fromRGBO(242, 242, 242, 1),
  //   fontFamily: 'Roboto',
  // );

  TextStyle get bodyColor => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: theme.primaryColor,
        fontFamily: 'Roboto',
      );

  // static const TextStyle titleBlackDialog = TextStyle(
  //   fontSize: 19,
  //   fontWeight: FontWeight.normal,
  //   color: Color.fromRGBO(63, 63, 63, 1),
  //   fontFamily: 'Poppins',
  // );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color.fromRGBO(36, 36, 36, 1),
    fontFamily: 'Poppins',
  );

  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(63, 63, 63, 0.8),
    fontFamily: 'Roboto',
  );

  static const TextStyle cardTrailing = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color.fromRGBO(63, 63, 63, 1),
    fontFamily: 'Poppins',
  );

  // static const TextStyle progressCardSubtitle = TextStyle(
  //   fontSize: 13,
  //   fontWeight: FontWeight.w600,
  //   color: Color.fromRGBO(63, 63, 63, 0.7),
  //   fontFamily: 'Roboto',
  // );
}
