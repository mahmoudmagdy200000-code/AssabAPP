import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../domain/strategies/fixed_assets_requests_status_strategy.dart';

class FixedAssetsModificationRequestsResponse {
  final List<FixedAssetsModificationRequestsItem> items;
  final MetaModel meta;

  FixedAssetsModificationRequestsResponse({
    required this.items,
    required this.meta,
  });

  factory FixedAssetsModificationRequestsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return FixedAssetsModificationRequestsResponse(
      items: (data['data'] as List<dynamic>)
          .map(
            (item) => FixedAssetsModificationRequestsItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      meta: MetaModel.fromJson(data['meta'] as Map<String, dynamic>),
    );
  }
}

class FixedAssetsModificationRequestsItem {
  final String id;
  final String assetName;
  final FixedAssetsRequestsStatusStrategy status;

  FixedAssetsModificationRequestsItem({
    required this.id,
    required this.assetName,
    required this.status,
  });

  factory FixedAssetsModificationRequestsItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsModificationRequestsItem(
      id: json['id'] as String,
      assetName: json['asset_name'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        json['status'] as String,
      ),
    );
  }
}
