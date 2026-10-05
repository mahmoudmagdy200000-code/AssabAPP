import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../domain/enums/fixed_assets_handover_enum.dart';
import '../../domain/enums/fixed_assets_handover_type_enum.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';
import '../../domain/strategies/fixed_assets_handover_type_strategy.dart';

class FixedAssetsHandoversRequestsResponse {
  final List<FixedAssetsHandoverRequestsItem> items;
  final MetaModel meta;

  FixedAssetsHandoversRequestsResponse({
    required this.items,
    required this.meta,
  });

  factory FixedAssetsHandoversRequestsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return FixedAssetsHandoversRequestsResponse(
      items: (data['data'] as List<dynamic>)
          .map(
            (item) => FixedAssetsHandoverRequestsItem.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      meta: MetaModel.fromJson(data['meta'] as Map<String, dynamic>),
    );
  }
}

class FixedAssetsHandoverRequestsItem {
  final String id;
  final FixedAssetsHandoverTypeStrategy type;
  final FixedAssetsHandoverStrategy status;
  final String createdAt;
  final String? updatedAt;

  FixedAssetsHandoverRequestsItem({
    required this.id,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FixedAssetsHandoverRequestsItem.fromJson(Map<String, dynamic> json) {
    return FixedAssetsHandoverRequestsItem(
      id: json['id'] as String,
      type: FixedAssetsHandoverTypeStrategy.getStrategy(
        FixedAssetsHandoverTypeEnum.fromString(json['type'] as String),
      ),
      status: FixedAssetsHandoverStrategy.getStrategy(
        FixedAssetsHandoverEnum.fromString(json['status'] as String),
      ),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
