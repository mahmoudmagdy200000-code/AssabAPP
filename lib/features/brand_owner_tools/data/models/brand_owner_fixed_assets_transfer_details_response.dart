import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../fixed_assets/domain/enums/fixed_assets_condition_enum.dart';

class BrandOwnerFixedAssetsTransferDetailsResponse {
  final String id;
  final FixedAssetsRequestsStatusStrategy status;
  final String fromBranchName;
  final String toBranchName;
  final String? approvedOn;
  final String submittedByManagerName;
  final String supportedByManagerName;
  final String submittedOn;
  final CancelReasonResponse? cancelReasonResponse;
  final BrandOwnerFixedAssetsTransferAsset asset;
  final TimeLineResponse timelines;

  const BrandOwnerFixedAssetsTransferDetailsResponse({
    required this.id,
    required this.status,
    required this.fromBranchName,
    required this.toBranchName,
    required this.approvedOn,
    required this.cancelReasonResponse,
    required this.asset,
    required this.timelines,
    required this.submittedByManagerName,
    required this.supportedByManagerName,
    required this.submittedOn,
  });

  factory BrandOwnerFixedAssetsTransferDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerFixedAssetsTransferDetailsResponse(
      id: data['id'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        data['status'] as String,
      ),
      fromBranchName: data['from_branch_name'] as String,
      toBranchName: data['to_branch_name'] as String,
      approvedOn: data['approved_on'] as String?,
      cancelReasonResponse: data['cancellation'] == null
          ? null
          : CancelReasonInOrderResponse.fromJson(
              data['cancellation'] as Map<String, dynamic>,
            ).toCancelReasonResponse(),
      asset: BrandOwnerFixedAssetsTransferAsset.fromJson(
        data['asset'] as Map<String, dynamic>,
      ),
      submittedByManagerName: data['submitted_by_manager_name'] as String,
      supportedByManagerName: data['supported_by_manager_name'] as String,
      submittedOn: data['submitted_on'] as String,
      timelines: TimeLineResponse.fromJson(data),
    );
  }

  BrandOwnerFixedAssetsTransferDetailsResponse copyWith({
    FixedAssetsRequestsStatusStrategy? status,
    String? fromBranchName,
    String? toBranchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
    bool clearApprovedOn = false,
    bool clearCancelReasonResponse = false,
    BrandOwnerFixedAssetsTransferAsset? asset,
    TimeLineResponse? timelines,
    String? submittedByManagerName,
    String? supportedByManagerName,
    String? submittedOn,
  }) {
    return BrandOwnerFixedAssetsTransferDetailsResponse(
      id: id,
      status: status ?? this.status,
      fromBranchName: fromBranchName ?? this.fromBranchName,
      toBranchName: toBranchName ?? this.toBranchName,
      approvedOn: clearApprovedOn ? null : approvedOn ?? this.approvedOn,
      cancelReasonResponse: clearCancelReasonResponse
          ? null
          : cancelReasonResponse ?? this.cancelReasonResponse,
      asset: asset ?? this.asset,
      timelines: timelines ?? this.timelines,
      submittedByManagerName:
          submittedByManagerName ?? this.submittedByManagerName,
      supportedByManagerName:
          supportedByManagerName ?? this.supportedByManagerName,
      submittedOn: submittedOn ?? this.submittedOn,
    );
  }
}

class BrandOwnerFixedAssetsTransferAsset {
  final String imageUrl;
  final String name;
  final String code;
  final FixedAssetsConditionEnum condition;
  final bool isCritical;
  final String affectedValue;
  final String lastService;
  final String brandStandard;

  const BrandOwnerFixedAssetsTransferAsset({
    required this.imageUrl,
    required this.name,
    required this.code,
    required this.condition,
    required this.affectedValue,
    required this.lastService,
    required this.isCritical,
    required this.brandStandard,
  });

  factory BrandOwnerFixedAssetsTransferAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsTransferAsset(
      imageUrl: json['image_url'] as String? ?? '',
      name: json['name'] as String,
      code: json['code'] as String,
      condition: FixedAssetsConditionEnum.fromString(
        json['condition'] as String,
      ),
      affectedValue: json['affected_value'] as String? ?? '-',
      lastService: json['last_service'] as String? ?? '-',
      isCritical: json['is_critical'] as bool? ?? false,
      brandStandard: json['brand_standard'] as String? ?? '-',
    );
  }
}
