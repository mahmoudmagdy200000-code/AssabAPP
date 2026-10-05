import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/wasted_problem_type_enum.dart';
import '../../../inventory/domain/enums/inventory_status_enum.dart';
import '../../../inventory/domain/strategies/daily_inventory_status_strategy.dart';

class BrandOwnerWastAndDamageDetailsResponse {
  final String id;
  final WastedProblemTypeEnum reportType;
  final DailyInventoryStatusStrategy status;
  final String branchName;
  final String branchOpenHours;
  final String submissionDate;
  final String branchImageUrl;
  final String reporterName;
  final String? reporterImageUrl;
  final WastAndDamageExecutiveSummary summary;
  final List<BrandOwnerWastAndDamageItem> items;
  final List<TimeLineItem> timelines;

  const BrandOwnerWastAndDamageDetailsResponse({
    required this.id,
    required this.reportType,
    required this.status,
    required this.branchName,
    required this.branchOpenHours,
    required this.submissionDate,
    required this.branchImageUrl,
    required this.reporterName,
    required this.reporterImageUrl,
    required this.summary,
    required this.items,
    required this.timelines,
  });

  factory BrandOwnerWastAndDamageDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataJson = json['data'] as Map<String, dynamic>;
    return BrandOwnerWastAndDamageDetailsResponse(
      id: dataJson['id'] as String,
      reportType: WastedProblemTypeEnum.fromString(
        dataJson['report_type'] as String,
      ),
      status: DailyInventoryStatusStrategy.getStrategy(
        InventoryStatusEnum.fromString(dataJson['status'] as String),
      ),
      branchName: dataJson['branch_name'] as String,
      branchOpenHours: dataJson['branch_open_hours'] as String,
      submissionDate: dataJson['submission_date'] as String,
      branchImageUrl: dataJson['branch_image_url'] as String,
      reporterName: dataJson['reporter_name'] as String,
      reporterImageUrl: dataJson['reporter_image_url'] as String?,
      summary: WastAndDamageExecutiveSummary.fromJson(
        dataJson['summary'] as Map<String, dynamic>,
      ),
      items: (dataJson['items'] as List)
          .map(
            (e) =>
                BrandOwnerWastAndDamageItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      timelines: TimeLineResponse.fromJson(dataJson).timelines,
    );
  }
}

class WastAndDamageExecutiveSummary {
  final String recordedBy;
  final String assignedBy;
  final String recordingTime;
  final String numberOfItems;
  final String matchingProducts;
  final String totalValue;
  final String warning;

  const WastAndDamageExecutiveSummary({
    required this.recordedBy,
    required this.assignedBy,
    required this.recordingTime,
    required this.numberOfItems,
    required this.matchingProducts,
    required this.totalValue,
    required this.warning,
  });

  factory WastAndDamageExecutiveSummary.fromJson(Map<String, dynamic> json) {
    return WastAndDamageExecutiveSummary(
      recordedBy: json['recorded_by'] as String,
      assignedBy: json['assigned_by'] as String,
      recordingTime: json['recording_time'] as String,
      numberOfItems: json['number_of_items'] as String,
      matchingProducts: json['matching_products'] as String,
      totalValue: json['total_value'] as String,
      warning: json['warning'] as String? ?? '-',
    );
  }
}

class BrandOwnerWastAndDamageItem {
  final String productName;
  final String problemType;
  final String quantity;
  final String reason;
  final String totalValue;
  final String? justificationNote;
  final String? explanatoryPhotoUrl;
  final String? imageUrl;

  const BrandOwnerWastAndDamageItem({
    required this.productName,
    required this.problemType,
    required this.quantity,
    required this.reason,
    required this.totalValue,
    required this.justificationNote,
    required this.explanatoryPhotoUrl,
    required this.imageUrl,
  });

  factory BrandOwnerWastAndDamageItem.fromJson(Map<String, dynamic> json) {
    return BrandOwnerWastAndDamageItem(
      productName: json['product_name'] as String,
      problemType: json['problem_type'] as String,
      quantity: json['quantity'] as String,
      reason: json['reason'] as String,
      totalValue: json['total_value'] as String,
      justificationNote: json['justification_note'] as String?,
      explanatoryPhotoUrl: json['explanatory_photo_url'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}
