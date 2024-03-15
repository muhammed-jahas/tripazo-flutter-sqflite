import 'package:flutter/material.dart';

class CustomColors {
  static const MaterialColor primaryColor = const MaterialColor(
    _primaryValue,
    const <int, Color>{
      50: const Color(0xFFFFE4D5),
      100: const Color(0xFFFFC8AB),
      200: const Color(0xFFFFAC80),
      300: const Color(0xFFFF914F),
      400: const Color(0xFFFF7625),
      500: const Color(_primaryValue),
      600: const Color(0xFFFF3C00),
      700: const Color(0xFFE73500),
      800: const Color(0xFFD22E00),
      900: const Color(0xFFB52800),
    },
  );

  static const int _primaryValue = 0xFFFF4D00;

  static const Color alertColor = Color(0xFFE01B1B);
  // static const Color accentColor = Color(0xFF9C27B0);
  // static const Color textColor = Color(0xFF333333);
}
