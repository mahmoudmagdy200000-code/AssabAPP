import 'package:assab/shared/models/meta_model/meta_model.dart';

import '../../../../core/enums/wasted_problem_type_enum.dart';
import '../../../inventory/domain/enums/inventory_status_enum.dart';
import '../../../inventory/domain/strategies/daily_inventory_status_strategy.dart';
import 'brand_owner_daily_inventory_requests_response.dart';

class BrandOwnerWastAndDamageRequestsResponse {
  final List<BrandOwnerWastAndDamageRequest> data;
  final MetaModel meta;

  BrandOwnerWastAndDamageRequestsResponse({
    required this.data,
    required this.meta,
  });

  factory BrandOwnerWastAndDamageRequestsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final requestsJson = json['data'] as List<dynamic>;
    final requestsList = requestsJson
        .map(
          (e) => BrandOwnerWastAndDamageRequest.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();

    final metaJson = json['meta'] as Map<String, dynamic>;
    final meta = MetaModel.fromJson(metaJson);

    return BrandOwnerWastAndDamageRequestsResponse(
      data: requestsList,
      meta: meta,
    );
  }
}

class BrandOwnerWastAndDamageRequest {
  final String id;
  final WastedProblemTypeEnum reportType;
  final DailyInventoryStatusStrategy status;
  final String submissionDate;
  final int itemsCount;
  final BrandOwnerInventoryBranch branch;

  BrandOwnerWastAndDamageRequest({
    required this.id,
    required this.reportType,
    required this.status,
    required this.submissionDate,
    required this.itemsCount,
    required this.branch,
  });

  factory BrandOwnerWastAndDamageRequest.fromJson(Map<String, dynamic> json) {
    return BrandOwnerWastAndDamageRequest(
      id: json['id'] as String,
      reportType: WastedProblemTypeEnum.fromString(
        json['report_type'] as String,
      ),
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(json['status'] as String),
      ),
      submissionDate: json['submission_date'] as String,
      itemsCount: json['items_count'] as int,
      branch: BrandOwnerInventoryBranch.fromJson(
        json['branch'] as Map<String, dynamic>,
      ),
    );
  }
}
