import 'package:flutter/material.dart';

import '../../core/extensions/number_extensions.dart';
import '../styles/app_colors.dart';
import '../styles/app_styles.dart';
import 'custom_colors.dart';

class LightTheme {
  LightTheme._();

  static TextTheme get textTheme => TextTheme(
    bodySmall: AppStyles.s12W400,
    bodyMedium: AppStyles.s14W400,
    labelSmall: AppStyles.s12W500,
    titleLarge: AppStyles.s20W500,
    titleMedium: AppStyles.s18W500,
    titleSmall: AppStyles.s16W600,
    bodyLarge: AppStyles.s20W400,
    labelLarge: AppStyles.s20W500,
  );

  static TextSelectionThemeData get textSelectionThemeData =>
      TextSelectionThemeData(
        cursorColor: AppColors.primaryLight,
        selectionColor: AppColors.primaryLight.withValues(alpha: 0.4),
        selectionHandleColor: AppColors.primaryLight,
      );

  static const ColorScheme colorScheme = ColorScheme.light(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.lightBackground,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.lightBackground,
    surface: AppColors.lightBackground,
    onSurface: AppColors.lightText,
    error: AppColors.errorLight,
    onError: AppColors.lightBackground,
  );

  static Iterable<ThemeExtension<CustomColors>> get extension =>
      <ThemeExtension<CustomColors>>[
        const CustomColors(
          text1: AppColors.lightText,
          text2: AppColors.lightGray,
          text3: AppColors.gray,
          text4: AppColors.darkGray,
          text5: AppColors.sGray,
          text6: AppColors.sBlack,
          reversedTextColor: Colors.white,
          border: AppColors.lightBorder,
          error: AppColors.errorLight,
          dark: Colors.black,
        ),
      ];

  static final double _textFieldBorderValue = 10.r;

  static OutlineInputBorder _buildBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(_textFieldBorderValue),
    borderSide: BorderSide(color: color),
  );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: 14.r, horizontal: 16.r),
    hintStyle: AppStyles.s14W400.copyWith(color: AppColors.gray),
    border: _buildBorder(AppColors.lightBorder),
    enabledBorder: _buildBorder(AppColors.lightBorder),
    focusedBorder: _buildBorder(AppColors.primaryLight),
    errorBorder: _buildBorder(AppColors.errorLight),
    focusedErrorBorder: _buildBorder(AppColors.errorLight),
    disabledBorder: _buildBorder(AppColors.lightBorder),
  );
}
