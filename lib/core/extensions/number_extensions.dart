import 'package:flutter/material.dart';

import '../responsive/app_responsive.dart';

extension NumberExtensions on num {
  double get w => AppResponsive.w(toDouble());

  double get h => AppResponsive.h(toDouble());

  double get f => AppResponsive.f(toDouble());

  double get r => AppResponsive.r(toDouble());

  SizedBox get horizontalSpace => SizedBox(width: toDouble().w);

  SizedBox get verticalSpace => SizedBox(height: toDouble().h);
}
