import 'package:flutter/material.dart';

class AppFont {
  static TextStyle _textStyle({
    required FontWeight fontWeight,
    Color color = Colors.black,
    double fontSize = 14.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontWeight: fontWeight,
      color: color,
      fontSize: fontSize,
      height: height,
    );
  }

  static TextStyle get light => _textStyle(fontWeight: FontWeight.w300);
  static TextStyle get regular => _textStyle(fontWeight: FontWeight.w400);
  static TextStyle get medium => _textStyle(fontWeight: FontWeight.w500);
  static TextStyle get bold => _textStyle(fontWeight: FontWeight.w700);
  static TextStyle get semiBold => _textStyle(fontWeight: FontWeight.w600);
}
