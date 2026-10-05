import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import 'light_theme.dart';

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
}
