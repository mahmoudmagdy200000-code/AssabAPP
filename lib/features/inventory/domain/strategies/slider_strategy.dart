import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

abstract class SliderStrategy {
  String get image;
  double get width;
  double get height;

  String label(BuildContext context);
}

class BottlesSliderStrategy extends SliderStrategy {
  @override
  String get image => AppAssets.bottlePng;

  @override
  double get width => 106.w;

  @override
  double get height => 282.h;

  @override
  String label(BuildContext context) {
    return context.tr.bottles;
  }
}

class GallonsSliderStrategy extends SliderStrategy {
  @override
  String get image => AppAssets.gallonPng;

  @override
  double get width => 131.w;

  @override
  double get height => 183.h;

  @override
  String label(BuildContext context) {
    return context.tr.gallons;
  }
}

class BarrelsSliderStrategy extends SliderStrategy {
  @override
  String get image => AppAssets.barrelPng;

  @override
  double get width => 131.w;

  @override
  double get height => 183.h;

  @override
  String label(BuildContext context) {
    return context.tr.barrels;
  }
}

class PacksSliderStrategy extends SliderStrategy {
  @override
  String get image => AppAssets.packPng;

  @override
  double get width => 131.w;

  @override
  double get height => 183.h;

  @override
  String label(BuildContext context) {
    return context.tr.packs;
  }
}
