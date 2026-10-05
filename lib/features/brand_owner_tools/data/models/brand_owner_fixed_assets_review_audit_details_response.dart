import 'package:assab/features/fixed_assets/domain/enums/fixed_assets_condition_enum.dart';
import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

class BrandOwnerFixedAssetsReviewAuditDetailsResponse {
  final String id;
  final FixedAssetsRequestsStatusStrategy status;
  final String branchName;
  final String? approvedOn;
  final CancelReasonResponse? cancelReasonResponse;
  final BrandOwnerFixedAssetsReviewAuditSummary summary;
  final BrandOwnerFixedAssetsReviewAuditAsset asset;
  final TimeLineResponse timelines;

  const BrandOwnerFixedAssetsReviewAuditDetailsResponse({
    required this.id,
    required this.status,
    required this.branchName,
    required this.approvedOn,
    required this.cancelReasonResponse,
    required this.summary,
    required this.asset,
    required this.timelines,
  });

  factory BrandOwnerFixedAssetsReviewAuditDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerFixedAssetsReviewAuditDetailsResponse(
      id: data['id'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        data['status'] as String,
      ),
      branchName: data['branch_name'] as String,
      approvedOn: data['approved_on'] as String?,
      cancelReasonResponse: data['cancellation'] == null
          ? null
          : CancelReasonInOrderResponse.fromJson(
              data['cancellation'] as Map<String, dynamic>,
            ).toCancelReasonResponse(),
      summary: BrandOwnerFixedAssetsReviewAuditSummary.fromJson(
        data['summary'] as Map<String, dynamic>,
      ),
      asset: BrandOwnerFixedAssetsReviewAuditAsset.fromJson(
        data['asset'] as Map<String, dynamic>,
      ),
      timelines: TimeLineResponse.fromJson(data),
    );
  }

  BrandOwnerFixedAssetsReviewAuditDetailsResponse copyWith({
    FixedAssetsRequestsStatusStrategy? status,
    String? branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
    bool clearApprovedOn = false,
    bool clearCancelReasonResponse = false,
    BrandOwnerFixedAssetsReviewAuditSummary? summary,
    BrandOwnerFixedAssetsReviewAuditAsset? asset,
    TimeLineResponse? timelines,
  }) {
    return BrandOwnerFixedAssetsReviewAuditDetailsResponse(
      id: id,
      status: status ?? this.status,
      branchName: branchName ?? this.branchName,
      approvedOn: clearApprovedOn ? null : approvedOn ?? this.approvedOn,
      cancelReasonResponse: clearCancelReasonResponse
          ? null
          : cancelReasonResponse ?? this.cancelReasonResponse,
      summary: summary ?? this.summary,
      asset: asset ?? this.asset,
      timelines: timelines ?? this.timelines,
    );
  }
}

class BrandOwnerFixedAssetsReviewAuditSummary {
  final String managerName;
  final String zoneName;
  final String value;
  final String totalAssets;
  final String auditDate;

  const BrandOwnerFixedAssetsReviewAuditSummary({
    required this.managerName,
    required this.zoneName,
    required this.value,
    required this.totalAssets,
    required this.auditDate,
  });

  factory BrandOwnerFixedAssetsReviewAuditSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsReviewAuditSummary(
      managerName: json['manager_name'] as String,
      zoneName: json['zone_name'] as String,
      value: json['value'] as String,
      totalAssets: json['total_assets'] as String,
      auditDate: json['audit_date'] as String,
    );
  }
}

class BrandOwnerFixedAssetsReviewAuditAsset {
  final String imageUrl;
  final String name;
  final String code;
  final String type;
  final String zone;
  final List<BrandOwnerFixedAssetsReviewAuditConditionCount> conditions;
  final String value;
  final String additionalNotes;

  const BrandOwnerFixedAssetsReviewAuditAsset({
    required this.imageUrl,
    required this.name,
    required this.code,
    required this.type,
    required this.zone,
    required this.conditions,
    required this.value,
    required this.additionalNotes,
  });

  factory BrandOwnerFixedAssetsReviewAuditAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsReviewAuditAsset(
      imageUrl: json['image_url'] as String? ?? '',
      name: json['name'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      zone: json['zone'] as String,
      conditions:
          (json['conditions'] as List? ?? [])
              .map(
                (e) => BrandOwnerFixedAssetsReviewAuditConditionCount.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
      value: json['value'] as String,
      additionalNotes: json['additional_notes'] as String? ?? '-',
    );
  }
}

class BrandOwnerFixedAssetsReviewAuditConditionCount {
  final FixedAssetsConditionEnum condition;
  final int count;

  const BrandOwnerFixedAssetsReviewAuditConditionCount({
    required this.condition,
    required this.count,
  });

  factory BrandOwnerFixedAssetsReviewAuditConditionCount.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsReviewAuditConditionCount(
      condition: FixedAssetsConditionEnum.fromString(
        json['condition'] as String,
      ),
      count: json['count'] as int,
    );
  }
}