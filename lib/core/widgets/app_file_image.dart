import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/extensions/number_extensions.dart';
import 'app_placeholder.dart';

class AppFileImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final double? bottomLeft;
  final double? bottomRight;
  final double? topLeft;
  final double? topRight;

  const AppFileImage({
    super.key,
    required this.image,
    this.width = double.infinity,
    this.height,
    this.fit = BoxFit.cover,
    this.bottomLeft,
    this.bottomRight,
    this.topLeft,
    this.topRight,
    this.borderRadius,
  });

  int _safeToInt(double? value, {int fallback = 200}) {
    if (value == null || value.isInfinite || value.isNaN) return fallback;
    return value.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius resolvedRadius =
        borderRadius ??
        BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeft ?? 16.r),
          bottomRight: Radius.circular(bottomRight ?? 16.r),
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
        );

    return ClipRRect(
      borderRadius: resolvedRadius,
      child: Image.file(
        File(image),
        width: width,
        height: height,
        fit: fit,
        cacheWidth: _safeToInt(width),
        cacheHeight: _safeToInt(height),
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return AppPlaceholder(
              width: width ?? 200.r,
              height: height ?? 200.r,
              borderRadius: resolvedRadius,
            );
          }
          return child;
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: width ?? 200,
          height: height ?? 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: resolvedRadius,
          ),
          child: Icon(
            Icons.error,
            color: Colors.red.shade700,
            size:
                min(
                  _safeToInt(width, fallback: 100),
                  _safeToInt(height, fallback: 100),
                ) *
                0.2,
          ),
        ),
      ),
    );
  }
}
