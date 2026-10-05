import 'package:flutter/widgets.dart';

abstract class AppResponsive {
  static late Size _size;
  static double _textScaleFactor = 1.0;

  static double? _designWidth;
  static double? _designHeight;

  /// Call once in main widget or App init
  static void init(
    BuildContext context, {
    required double designWidth,
    required double designHeight,
  }) {
    _designWidth = designWidth;
    _designHeight = designHeight;
    _size = MediaQuery.sizeOf(context);
    _textScaleFactor = MediaQuery.textScalerOf(context).scale(1);
  }

  /// Actual screen width & height
  static double get screenWidth => _size.width;

  static double get screenHeight => _size.height;

  /// Scale factors
  static double get scaleWidth => _size.width / _designWidth!;

  static double get scaleHeight => _size.height / _designHeight!;

  /// Average scale
  static double get scale => (scaleWidth + scaleHeight) / 2;

  /// Responsive value for padding, radius, icons
  static double r(double value) => value * scale;

  /// Responsive value for width
  static double w(double value) => value * scaleWidth;

  /// Responsive value for height
  static double h(double value) => value * scaleHeight;

  /// Responsive value for font size (with system scaling)
  static double f(double value) => r(value) * _textScaleFactor;
}
