import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import 'light_theme.dart';
import 'custom_colors.dart';

class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'Cairo';

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textSelectionTheme: LightTheme.textSelectionThemeData,
    textTheme: LightTheme.textTheme,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.primaryLight,
    colorScheme: LightTheme.colorScheme,
    extensions: LightTheme.extension,
    fontFamily: _fontFamily,
    inputDecorationTheme: LightTheme.inputDecorationTheme,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF10121C),
    primaryColor: AppColors.primaryLight,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFAD83FF),
      surface: Color(0xFF10121C),
      onSurface: Colors.white,
    ),
    textTheme: LightTheme.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    extensions: const <ThemeExtension<CustomColors>>[
      CustomColors(
        text1: Colors.white,
        text2: Color(0xFF222431),
        text3: Color(0xFFB9BBC6),
        text4: Color(0xFFD2D3DA),
        text5: Color(0xFFE7E8EC),
        text6: Colors.white,
        reversedTextColor: Color(0xFF191B27),
        error: Color(0xFFFF6A72),
        border: Color(0xFF484B5A),
        dark: Colors.white,
      ),
    ],
    fontFamily: _fontFamily,
  );
}
