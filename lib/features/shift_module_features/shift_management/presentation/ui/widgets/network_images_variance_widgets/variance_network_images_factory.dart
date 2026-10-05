import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/network_images_variance_widgets/variance_network_images_strategy_widgets.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/entity/shift/variance_details/variance_other_cashier_entity.dart';

class VarianceNetworkImagesFactory {
  static VarianceNetworkImagesUiStrategy create(
    String type, {
    required List<String> supportingFiles,
    required String? reason,
    required List<VarianceOtherCashierEntity> otherCashiers,
  }) {
    switch (type) {
      case 'self':
        return IWasResponsibleVarianceNetworkImageStrategyUi();
      case 'self_and_others':
        return MeAndOrOtherVarianceNetworkImageStrategyUi(
          otherCashiers: otherCashiers,
        );
      case 'other_factors':
        return OtherFactorVarianceNetworkImageStrategyUi(
          otherCashiers: otherCashiers,
          reason: reason,
          supportingFiles: supportingFiles,
        );
      case 'mixed':
        return MixedFactorVarianceNetworkImageStrategyUi(
          otherCashiers: otherCashiers,
          reason: reason,
          supportingFiles: supportingFiles,
        );
      default:
        throw Exception('Unknown variance type: $type');
    }
  }
}

abstract class VarianceNetworkImagesUiStrategy {
  Widget buildUI(BuildContext context);
}
