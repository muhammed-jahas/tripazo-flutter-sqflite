import 'package:flutter/material.dart';

class CustomColors {
  static const MaterialColor primaryColor = const MaterialColor(
    _primaryValue,
    const <int, Color>{
      50: const Color(0xFFFFF0D5),
      100: const Color(0xFFFFE0AB),
      200: const Color(0xFFFFCE80),
      300: const Color(0xFFFFBD56),
      400: const Color(0xFFFFAD2C),
      500: const Color(_primaryValue),
      600: const Color(0xFFFF961D),
      700: const Color(0xFFFF851B),
      800: const Color(0xFFFF7418),
      900: const Color(0xFFFF6215),
    },
  );

  static const int _primaryValue = 0xFFFF974C;
  static const Color alertColor = Color(0xFFE01B1B);
  // static const Color accentColor = Color(0xFF9C27B0);
  // static const Color textColor = Color(0xFF333333);
}
