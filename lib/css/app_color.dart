// ignore: file_names
import 'package:flutter/material.dart';

class AppColor {
  AppColor._();
  static const Color blueColor = Color(0xFF2F39C5);
  static const Color mainColor = Color(0xFF2F467B);
  static const Color putih = Colors.white;
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xffff9a9e),
      Color(0xfffad0c4),
      Color(0xfffad0c4),
    ],
  );

  static const Gradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      mainColor,
      Colors.blue,
    ],
  );
}
