import 'package:flutter/material.dart';

class AppColor {
  static const Color purple1 = Color(0xff7A68FF);
  static const Color purple2 = Color(0xff35284E);
  static const Color purple3 = Color(0xff2B223E);
  static const Color purple4 = Color(0xff7C63AB);
  static const Color white = Color(0xffFCFCFC);
  static const Color grey1 = Color(0xff6F6C87);
  static const Color red1 = Color(0xffD44D4D);
  static const Color red2 = Color(0xff4E2828);
  static const Color green1 = Color(0xff29DA30);
  static const Color green2 = Color(0xff284E3E);

  static const Gradient gradientColor = LinearGradient(
    colors: [
      Color(0xFF46A0AE),
      Color(0xFF00FFCB),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
