import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../inventory/domain/enums/inventory_status_enum.dart';
import '../../../inventory/domain/strategies/daily_inventory_status_strategy.dart';

class BrandOwnerDailyInventoryRequestsResponse {
  final List<BrandOwnerDailyInventoryRequest> data;
  final MetaModel meta;

  BrandOwnerDailyInventoryRequestsResponse({
    required this.data,
    required this.meta,
  });

  factory BrandOwnerDailyInventoryRequestsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final requestsJson = json['data'] as List<dynamic>;
    final requestsList = requestsJson
        .map(
          (e) => BrandOwnerDailyInventoryRequest.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>;
    final meta = MetaModel.fromJson(metaJson);

    return BrandOwnerDailyInventoryRequestsResponse(
      data: requestsList,
      meta: meta,
    );
  }
}

class BrandOwnerDailyInventoryRequest {
  final String id;
  final DailyInventoryStatusStrategy status;
  final String inventoryDate;
  final String startTime;
  final BrandOwnerInventoryBranch branch;

  BrandOwnerDailyInventoryRequest({
    required this.id,
    required this.status,
    required this.inventoryDate,
    required this.startTime,
    required this.branch,
  });

  factory BrandOwnerDailyInventoryRequest.fromJson(Map<String, dynamic> json) {
    return BrandOwnerDailyInventoryRequest(
      id: json['id'] as String,
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(json['status'] as String),
      ),
      inventoryDate: json['inventory_date'] as String? ?? '-',
      startTime: json['start_time'] as String? ?? '-',
      branch: BrandOwnerInventoryBranch.fromJson(
        json['branch'] as Map<String, dynamic>,
      ),
    );
  }
}

class BrandOwnerInventoryBranch {
  final String id;
  final String name;

  BrandOwnerInventoryBranch({required this.id, required this.name});

  factory BrandOwnerInventoryBranch.fromJson(Map<String, dynamic> json) {
    return BrandOwnerInventoryBranch(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
