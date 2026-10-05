import 'package:flutter/material.dart';

import 'variance_strategy_widgets.dart';

class VarianceStrategyFactory {
  static VarianceUiStrategy create(String type) {
    switch (type) {
      case 'self':
        return IWasResponsibleVarianceStrategyUi();
      case 'self_and_others':
        return MeAndOrVarianceStrategyUi();
      case 'other_factors':
        return OtherFactorVarianceStrategyUi();
      case 'mixed':
        return MixedFactorVarianceStrategyUi();
      default:
        throw Exception('Unknown variance type: $type');
    }
  }
}

abstract class VarianceUiStrategy {
  Widget buildUI(BuildContext context);
}
