import 'package:assab/shared/models/time_line_response.dart';

import '../../../inventory/domain/enums/inventory_status_enum.dart';
import '../../../inventory/domain/strategies/daily_inventory_status_strategy.dart';
import 'brand_owner_daily_inventory_requests_response.dart';

class BrandOwnerDailyInventoryDetailsResponse {
  final String id;
  final String branchName;
  final String branchOpenHours;
  final String inventoryDate;
  final String branchImageUrl;
  final String reporterName;
  final String? reporterImageUrl;
  final DailyInventoryStatusStrategy status;
  final DailyInventoryExecutiveSummary summary;
  final List<BrandOwnerDailyInventoryItem> items;
  final List<TimeLineItem> timelines;

  const BrandOwnerDailyInventoryDetailsResponse({
    required this.id,
    required this.branchName,
    required this.branchOpenHours,
    required this.inventoryDate,
    required this.branchImageUrl,
    required this.reporterName,
    required this.reporterImageUrl,
    required this.status,
    required this.summary,
    required this.items,
    required this.timelines,
  });

  factory BrandOwnerDailyInventoryDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataJson = json['data'] as Map<String, dynamic>;
    return BrandOwnerDailyInventoryDetailsResponse(
      id: dataJson['id'] as String,
      branchName: dataJson['branch_name'] as String,
      branchOpenHours: dataJson['branch_open_hours'] as String,
      inventoryDate: dataJson['inventory_date'] as String,
      branchImageUrl: dataJson['branch_image_url'] as String,
      reporterName: dataJson['reporter_name'] as String,
      reporterImageUrl: dataJson['reporter_image_url'] as String?,
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(dataJson['status'] as String),
      ),
      summary: DailyInventoryExecutiveSummary.fromJson(
        dataJson['summary'] as Map<String, dynamic>,
      ),
      items: (dataJson['items'] as List)
          .map(
            (e) => BrandOwnerDailyInventoryItem.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      timelines: TimeLineResponse.fromJson(dataJson).timelines,
    );
  }
}

class DailyInventoryExecutiveSummary {
  final String productsInventoried;
  final String productsWithDiscrepancies;
  final String matchingProducts;
  final String totalDiscrepancyValue;
  final String discrepancyType;

  const DailyInventoryExecutiveSummary({
    required this.productsInventoried,
    required this.productsWithDiscrepancies,
    required this.matchingProducts,
    required this.totalDiscrepancyValue,
    required this.discrepancyType,
  });

  factory DailyInventoryExecutiveSummary.fromJson(Map<String, dynamic> json) {
    return DailyInventoryExecutiveSummary(
      productsInventoried: json['products_inventoried'] as String,
      productsWithDiscrepancies: json['products_with_discrepancies'] as String,
      matchingProducts: json['matching_products'] as String,
      totalDiscrepancyValue: json['total_discrepancy_value'] as String,
      discrepancyType: json['discrepancy_type'] as String,
    );
  }
}

class BrandOwnerDailyInventoryItem {
  final String productName;
  final String expectedBalance;
  final String actualBalance;
  final String difference;
  final String? justificationNote;
  final String? explanatoryPhotoUrl;
  final String? explanatoryPhotoName;
  final String? imageUrl;

  const BrandOwnerDailyInventoryItem({
    required this.productName,
    required this.expectedBalance,
    required this.actualBalance,
    required this.difference,
    required this.justificationNote,
    required this.explanatoryPhotoUrl,
    required this.explanatoryPhotoName,
    required this.imageUrl,
  });

  factory BrandOwnerDailyInventoryItem.fromJson(Map<String, dynamic> json) {
    return BrandOwnerDailyInventoryItem(
      productName: json['product_name'] as String,
      expectedBalance: json['expected_balance'] as String,
      actualBalance: json['actual_balance'] as String,
      difference: json['difference'] as String,
      justificationNote: json['justification_note'] as String?,
      explanatoryPhotoUrl: json['explanatory_photo_url'] as String?,
      explanatoryPhotoName: json['explanatory_photo_name'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
