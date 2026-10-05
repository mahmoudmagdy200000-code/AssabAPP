import 'package:assab/features/fixed_assets/domain/enums/fixed_assets_condition_enum.dart';
import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

class BrandOwnerFixedAssetsModificationDetailsResponse {
  final String id;
  final FixedAssetsRequestsStatusStrategy status;
  final String branchName;
  final String? approvedOn;
  final CancelReasonResponse? cancelReasonResponse;
  final BrandOwnerFixedAssetsModificationFinancialImpactAnalysis
  financialImpactAnalysis;
  final BrandOwnerFixedAssetsModificationAsset asset;
  final TimeLineResponse timelines;

  const BrandOwnerFixedAssetsModificationDetailsResponse({
    required this.id,
    required this.status,
    required this.branchName,
    required this.approvedOn,
    required this.cancelReasonResponse,
    required this.financialImpactAnalysis,
    required this.asset,
    required this.timelines,
  });

  factory BrandOwnerFixedAssetsModificationDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerFixedAssetsModificationDetailsResponse(
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
      financialImpactAnalysis:
          BrandOwnerFixedAssetsModificationFinancialImpactAnalysis.fromJson(
            data['financial_impact_analysis'] as Map<String, dynamic>,
          ),
      asset: BrandOwnerFixedAssetsModificationAsset.fromJson(
        data['asset'] as Map<String, dynamic>,
      ),
      timelines: TimeLineResponse.fromJson(data),
    );
  }

  BrandOwnerFixedAssetsModificationDetailsResponse copyWith({
    FixedAssetsRequestsStatusStrategy? status,
    String? branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
    bool clearApprovedOn = false,
    bool clearCancelReasonResponse = false,
    BrandOwnerFixedAssetsModificationFinancialImpactAnalysis?
    financialImpactAnalysis,
    BrandOwnerFixedAssetsModificationAsset? asset,
    TimeLineResponse? timelines,
  }) {
    return BrandOwnerFixedAssetsModificationDetailsResponse(
      id: id,
      status: status ?? this.status,
      branchName: branchName ?? this.branchName,
      approvedOn: clearApprovedOn ? null : approvedOn ?? this.approvedOn,
      cancelReasonResponse: clearCancelReasonResponse
          ? null
          : cancelReasonResponse ?? this.cancelReasonResponse,
      financialImpactAnalysis:
          financialImpactAnalysis ?? this.financialImpactAnalysis,
      asset: asset ?? this.asset,
      timelines: timelines ?? this.timelines,
    );
  }
}

class BrandOwnerFixedAssetsModificationFinancialImpactAnalysis {
  final String financialImpact;
  final String operationalImpact;
  final String criticalAssets;
  final String brandImpactLevel;

  const BrandOwnerFixedAssetsModificationFinancialImpactAnalysis({
    required this.financialImpact,
    required this.operationalImpact,
    required this.criticalAssets,
    required this.brandImpactLevel,
  });

  factory BrandOwnerFixedAssetsModificationFinancialImpactAnalysis.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsModificationFinancialImpactAnalysis(
      financialImpact: json['financial_impact'] as String,
      operationalImpact: json['operational_impact'] as String,
      criticalAssets: json['critical_assets'] as String,
      brandImpactLevel: json['brand_impact_level'] as String,
    );
  }
}

class BrandOwnerFixedAssetsModificationAsset {
  final String imageUrl;
  final String name;
  final String code;
  final String branchName;
  final String managerName;
  final FixedAssetsConditionEnum currentStatus;
  final FixedAssetsConditionEnum newStatus;
  final String reason;
  final String value;
  final bool criticalAsset;
  final String brandImpact;
  final String documentationPhotoUrl;
  final String additionalNotes;

  const BrandOwnerFixedAssetsModificationAsset({
    required this.imageUrl,
    required this.name,
    required this.code,
    required this.branchName,
    required this.managerName,
    required this.currentStatus,
    required this.newStatus,
    required this.reason,
    required this.value,
    required this.criticalAsset,
    required this.brandImpact,
    required this.documentationPhotoUrl,
    required this.additionalNotes,
  });

  factory BrandOwnerFixedAssetsModificationAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsModificationAsset(
      imageUrl: json['image_url'] as String? ?? '',
      name: json['name'] as String,
      code: json['code'] as String,
      branchName: json['branch_name'] as String,
      managerName: json['manager_name'] as String,
      currentStatus: FixedAssetsConditionEnum.fromString(
        json['current_status'] as String,
      ),
      newStatus: FixedAssetsConditionEnum.fromString(
        json['new_status'] as String,
      ),
      reason: json['reason'] as String,
      value: json['value'] as String,
      criticalAsset: json['critical_asset'] as bool? ?? false,
      brandImpact: json['brand_impact'] as String,
      documentationPhotoUrl: json['documentation_photo_url'] as String? ?? '',
      additionalNotes: json['additional_notes'] as String? ?? '-',
    );
  }
}
