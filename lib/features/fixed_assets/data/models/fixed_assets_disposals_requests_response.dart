import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../domain/strategies/fixed_assets_requests_status_strategy.dart';

class FixedAssetsDisposalsRequestsResponse {
  final List<FixedAssetsDisposalsRequestsItem> items;
  final MetaModel meta;

  FixedAssetsDisposalsRequestsResponse({
    required this.items,
    required this.meta,
  });

  factory FixedAssetsDisposalsRequestsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return FixedAssetsDisposalsRequestsResponse(
      items: (data['data'] as List<dynamic>)
          .map(
            (item) => FixedAssetsDisposalsRequestsItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      meta: MetaModel.fromJson(data['meta'] as Map<String, dynamic>),
    );
  }
}

class FixedAssetsDisposalsRequestsItem {
  final String id;
  final String assetName;
  final FixedAssetsRequestsStatusStrategy status;
  final String dateAndTime;

  FixedAssetsDisposalsRequestsItem({
    required this.id,
    required this.assetName,
    required this.status,
    required this.dateAndTime,
  });

  factory FixedAssetsDisposalsRequestsItem.fromJson(Map<String, dynamic> json) {
    return FixedAssetsDisposalsRequestsItem(
      id: json['id'] as String,
      assetName: json['asset_name'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        json['status'] as String,
      ),
      dateAndTime:
          DateFormatter.formatDateMDY(
            DateTime.tryParse((json['date_and_time'] as String?) ?? ''),
          ) ??
          '-',
    );
  }
}
