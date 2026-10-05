import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_condition_strategy.dart';
import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../../fixed_assets/domain/enums/fixed_assets_transfers_and_disposal_enum.dart';

class BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse {
  final String id;
  final FixedAssetsRequestsStatusStrategy status;
  final String branchName;
  final String? approvedOn;
  final String submittedByBranchName;
  final String submittedByManagerName;
  final String submittedOn;
  final FixedAssetsTransfersAndDisposalEnum type;
  final CancelReasonResponse? cancelReasonResponse;
  final BrandOwnerFixedAssetsDisposalAsset asset;
  final TimeLineResponse timelines;

  const BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse({
    required this.id,
    required this.status,
    required this.branchName,
    required this.approvedOn,
    required this.submittedByBranchName,
    required this.submittedByManagerName,
    required this.submittedOn,
    required this.cancelReasonResponse,
    required this.type,
    required this.asset,
    required this.timelines,
  });

  factory BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse(
      id: data['id'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        data['status'] as String,
      ),
      branchName: data['branch_name'] as String,
      approvedOn: data['approved_on'] as String?,
      submittedByBranchName: data['submitted_by_branch_name'] as String,
      submittedByManagerName: data['submitted_by_manager_name'] as String,
      cancelReasonResponse: data['cancellation'] == null
          ? null
          : CancelReasonInOrderResponse.fromJson(
              data['cancellation'] as Map<String, dynamic>,
            ).toCancelReasonResponse(),
      asset: BrandOwnerFixedAssetsDisposalAsset.fromJson(
        data['asset'] as Map<String, dynamic>,
      ),
      type: FixedAssetsTransfersAndDisposalEnum.fromString(
        data['type'] as String,
      ),
      submittedOn: data['submitted_on'] as String,
      timelines: TimeLineResponse.fromJson(data),
    );
  }

  BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse copyWith({
    FixedAssetsRequestsStatusStrategy? status,
    String? branchName,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
    bool clearApprovedOn = false,
    bool clearCancelReasonResponse = false,
    FixedAssetsTransfersAndDisposalEnum? type,
    String? submittedByBranchName,
    String? submittedByManagerName,
    String? submittedOn,
    BrandOwnerFixedAssetsDisposalAsset? asset,
    TimeLineResponse? timelines,
  }) {
    return BrandOwnerFixedAssetsDisposalAndExternalTransferDetailsResponse(
      id: id,
      status: status ?? this.status,
      branchName: branchName ?? this.branchName,
      approvedOn: clearApprovedOn ? null : approvedOn ?? this.approvedOn,
      cancelReasonResponse: clearCancelReasonResponse
          ? null
          : cancelReasonResponse ?? this.cancelReasonResponse,
      type: type ?? this.type,
      asset: asset ?? this.asset,
      timelines: timelines ?? this.timelines,
      submittedByBranchName:
          submittedByBranchName ?? this.submittedByBranchName,
      submittedByManagerName:
          submittedByManagerName ?? this.submittedByManagerName,
      submittedOn: submittedOn ?? this.submittedOn,
    );
  }
}

class BrandOwnerFixedAssetsDisposalAsset {
  final String imageUrl;
  final String name;
  final String code;
  final String reasonForDisposal;
  final String zoneName;
  final FixedAssetsConditionStrategy condition;
  final String affectedValue;
  final String evidenceImageUrl;
  final String additionalNotes;

  const BrandOwnerFixedAssetsDisposalAsset({
    required this.imageUrl,
    required this.name,
    required this.code,
    required this.reasonForDisposal,
    required this.zoneName,
    required this.condition,
    required this.affectedValue,
    required this.evidenceImageUrl,
    required this.additionalNotes,
  });

  factory BrandOwnerFixedAssetsDisposalAsset.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsDisposalAsset(
      imageUrl: json['image_url'] as String? ?? '',
      name: json['name'] as String,
      code: json['code'] as String,
      zoneName: json['zone_name'] as String? ?? '-',
      reasonForDisposal: json['reason_for_disposal'] as String? ?? '-',
      condition: FixedAssetsConditionStrategy.fromCondition(
        json['condition'] as String,
      ),
      affectedValue: json['affected_value'] as String? ?? '-',
      evidenceImageUrl: json['evidence_image_url'] as String? ?? '',
      additionalNotes: json['additional_notes'] as String? ?? '-',
    );
  }
}
