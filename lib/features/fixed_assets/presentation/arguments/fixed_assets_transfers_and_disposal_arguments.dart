import 'package:assab/core/cubits/validation/validation_cubit.dart';

import '../../data/models/fixed_assets_search_response.dart';
import '../../domain/enums/fixed_assets_transfers_and_disposal_enum.dart';
import '../../domain/strategies/fixed_assets_transfers_and_disposal_strategy.dart';

class FixedAssetsTransfersAndDisposalArguments {
  final FixedAssetsTransfersAndDisposalStrategy? strategy;
  final List<FixedAssetsSearchItem> assets;

  const FixedAssetsTransfersAndDisposalArguments({
    this.strategy,
    this.assets = const [],
  });

  factory FixedAssetsTransfersAndDisposalArguments.from(Object? args) {
    if (args is FixedAssetsTransfersAndDisposalArguments) {
      return args;
    }

    if (args is Map<String, dynamic>) {
      final strategy =
          args['strategy'] as FixedAssetsTransfersAndDisposalStrategy?;
      final assetsValue = args['assets'];

      if (assetsValue is FixedAssetsSearchItem) {
        return FixedAssetsTransfersAndDisposalArguments(
          strategy: strategy,
          assets: [assetsValue],
        );
      }

      return FixedAssetsTransfersAndDisposalArguments(
        strategy: strategy,
        assets: assetsValue is List<FixedAssetsSearchItem>
            ? assetsValue
            : const [],
      );
    }

    return const FixedAssetsTransfersAndDisposalArguments();
  }

  void applyTo(ValidationCubit validationCubit) {
    if (strategy != null) {
      validationCubit
          .validateFieldAndStoreTypedValue<FixedAssetsTransfersAndDisposalEnum>(
            fieldName: 'requestType',
            value: strategy!.type,
            isValid: true,
          );
    }

    if (assets.isEmpty) {
      return;
    }

    final assetsById = <String, FixedAssetsSearchItem>{
      for (final asset in assets) asset.id: asset,
    };

    validationCubit.addDynamicFields({
      for (final assetId in assetsById.keys) 'asset_$assetId',
    });

    for (final asset in assetsById.values) {
      validationCubit.validateFieldAndStoreTypedValue<FixedAssetsSearchItem>(
        fieldName: 'asset_${asset.id}',
        value: asset,
        isValid: true,
      );
    }
  }
}
