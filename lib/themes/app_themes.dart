import 'package:flutter/material.dart';


class AppThemes {
  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF0F1317), colorScheme: const ColorScheme.light().copyWith(background: const Color(0xFFE5E5E5)),
  );

  static final darkTheme = ThemeData(
    primaryColor: Colors.grey, colorScheme: const ColorScheme.dark().copyWith(background: Colors.blue),
  );
}

extension CustomColorScheme on ColorScheme {
  Color get lightGrey => const Color(0xFFACACAC);
}