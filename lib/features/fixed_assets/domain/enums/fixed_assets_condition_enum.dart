import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../strategies/fixed_assets_condition_strategy.dart';

enum FixedAssetsConditionEnum {
  excellent('excellent'),
  needAttention('need_attention'),
  problem('problem');

  final String _value;

  const FixedAssetsConditionEnum(this._value);

  static FixedAssetsConditionEnum fromString(String value) {
    return FixedAssetsConditionEnum.values.firstWhere(
      (e) => e._value.toLowerCase() == value.toLowerCase(),
      orElse: () => throw ArgumentError('Invalid condition value: $value'),
    );
  }

  String get value => _value;

  FixedAssetsConditionStrategy toStrategy() {
    switch (this) {
      case FixedAssetsConditionEnum.excellent:
        return ExcellentConditionStrategy();
      case FixedAssetsConditionEnum.needAttention:
        return NeedAttentionConditionStrategy();
      case FixedAssetsConditionEnum.problem:
        return ProblemConditionStrategy();
    }
  }

  String label(BuildContext context) {
    switch (this) {
      case FixedAssetsConditionEnum.excellent:
        return context.tr.excellent;
      case FixedAssetsConditionEnum.needAttention:
        return context.tr.needsAttention;
      case FixedAssetsConditionEnum.problem:
        return context.tr.problem;
    }
  }

  Color get color {
    switch (this) {
      case FixedAssetsConditionEnum.excellent:
        return AppColors.lightGreen; // Green
      case FixedAssetsConditionEnum.needAttention:
        return AppColors.orange; // Orange
      case FixedAssetsConditionEnum.problem:
        return AppColors.red; // Red
    }
  }
}
