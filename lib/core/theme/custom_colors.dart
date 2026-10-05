import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color text1;
  final Color text2;
  final Color text3;
  final Color text4;
  final Color text5;
  final Color text6;
  final Color reversedTextColor;
  final Color error;
  final Color border;
  final Color dark;

  const CustomColors({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.text6,
    required this.reversedTextColor,
    required this.error,
    required this.border,
    required this.dark,
  });

  @override
  CustomColors copyWith({
    Color? text1,
    Color? text2,
    Color? text3,
    Color? text4,
    Color? text5,
    Color? text6,
    Color? reversedTextColor,
    Color? error,
    Color? border,
    Color? dark,
  }) {
    return CustomColors(
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      text4: text4 ?? this.text4,
      text5: text5 ?? this.text5,
      text6: text6 ?? this.text6,
      reversedTextColor: reversedTextColor ?? this.reversedTextColor,
      error: error ?? this.error,
      border: border ?? this.border,
      dark: dark ?? this.dark,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      text1: Color.lerp(text1, other.text1, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      text3: Color.lerp(text3, other.text3, t)!,
      text4: Color.lerp(text4, other.text4, t)!,
      text5: Color.lerp(text5, other.text5, t)!,
      text6: Color.lerp(text6, other.text6, t)!,
      reversedTextColor: Color.lerp(
        reversedTextColor,
        other.reversedTextColor,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!,
      dark: Color.lerp(dark, other.dark, t)!,
    );
  }
}
