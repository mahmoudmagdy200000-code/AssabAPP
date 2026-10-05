import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/strategies/fixed_assets_condition_strategy.dart';
import '../../domain/strategies/fixed_assets_requests_status_strategy.dart';
import '../../domain/strategies/fixed_assets_transfer_types_strategy.dart';

class FixedAssetsTransfersRequestsResponse {
  final List<FixedAssetsTransfersRequestsItem> items;
  final MetaModel meta;

  FixedAssetsTransfersRequestsResponse({
    required this.items,
    required this.meta,
  });

  factory FixedAssetsTransfersRequestsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return FixedAssetsTransfersRequestsResponse(
      items: (data['data'] as List<dynamic>)
          .map(
            (item) => FixedAssetsTransfersRequestsItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      meta: MetaModel.fromJson(data['meta'] as Map<String, dynamic>),
    );
  }
}

class FixedAssetsTransfersRequestsItem {
  final String id;
  final String assetName;
  final FixedAssetsRequestsStatusStrategy status;
  final FixedAssetsConditionStrategy condition;
  final String dateAndTime;
  final FixedAssetsTransferTypesStrategy type;

  FixedAssetsTransfersRequestsItem({
    required this.id,
    required this.assetName,
    required this.status,
    required this.condition,
    required this.dateAndTime,
    required this.type,
  });

  factory FixedAssetsTransfersRequestsItem.fromJson(Map<String, dynamic> json) {
    return FixedAssetsTransfersRequestsItem(
      id: json['id'] as String,
      assetName: json['asset_name'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        json['status'] as String,
      ),
      condition: FixedAssetsConditionStrategy.fromCondition(
        json['condition'] as String,
      ),
      dateAndTime: DateFormatter.timeAgo(
        DateTime.tryParse((json['date_and_time'] as String?) ?? ''),
      ),
      type: FixedAssetsTransferTypesStrategy.fromTransferType(
        json['type'] as String,
      ),
    );
  }
}
