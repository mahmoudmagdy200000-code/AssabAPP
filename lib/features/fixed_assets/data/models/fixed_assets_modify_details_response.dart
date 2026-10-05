import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:assab/shared/models/time_line_response.dart';

import '../../domain/enums/fixed_assets_condition_enum.dart';
import '../../domain/enums/fixed_assets_done_enum.dart';
import '../../domain/enums/fixed_assets_next_enum.dart';
import '../../domain/strategies/fixed_assets_requests_status_strategy.dart';
import 'fixed_assets_search_response.dart';

class FixedAssetsModifyDetailsResponse {
  final FixedAssetsRequestsStatusStrategy status;
  final FixedAssetsSearchItem assetDetails;
  final FixedAssetsModificationDetails modificationDetails;
  final FixedAssetsRequiredActions requiredActions;
  final TimeLineResponse timelines;

  FixedAssetsModifyDetailsResponse({
    required this.status,
    required this.assetDetails,
    required this.modificationDetails,
    required this.requiredActions,
    required this.timelines,
  });

  factory FixedAssetsModifyDetailsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return FixedAssetsModifyDetailsResponse(
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        data['status'] as String,
      ),
      assetDetails: FixedAssetsSearchItem.fromJson(
        data['asset_details'] as Map<String, dynamic>,
      ),
      modificationDetails: FixedAssetsModificationDetails.fromJson(
        data['modification_details'] as Map<String, dynamic>,
      ),
      requiredActions: FixedAssetsRequiredActions.fromJson(
        data['required_actions'] as Map<String, dynamic>,
      ),
      timelines: TimeLineResponse.fromJson(data),
    );
  }
}

class FixedAssetsModificationDetails {
  final FixedAssetsConditionEnum newStatus;
  final String reason;
  final AttachmentModel attachment;

  FixedAssetsModificationDetails({
    required this.newStatus,
    required this.reason,
    required this.attachment,
  });

  factory FixedAssetsModificationDetails.fromJson(Map<String, dynamic> json) {
    return FixedAssetsModificationDetails(
      newStatus: FixedAssetsConditionEnum.fromString(
        json['new_status'] as String,
      ),
      reason: json['reason'] as String,
      attachment: AttachmentModel.fromJson(
        json['attachment'] as Map<String, dynamic>,
      ),
    );
  }
}

class FixedAssetsRequiredActions {
  final List<FixedAssetsDoneEnum> doneActions;
  final FixedAssetsNextEnum nextAction;
  final String approvalRequestOwnerNote;

  FixedAssetsRequiredActions({
    required this.doneActions,
    required this.nextAction,
    required this.approvalRequestOwnerNote,
  });

  factory FixedAssetsRequiredActions.fromJson(Map<String, dynamic> json) {
    return FixedAssetsRequiredActions(
      doneActions: List<String>.from(
        json['done_actions'] as List<dynamic>,
      ).map((e) => FixedAssetsDoneEnum.fromValue(e)).toList(),
      nextAction: FixedAssetsNextEnum.fromValue(json['next_action'] as String),
      approvalRequestOwnerNote: json['approval_request_owner_note'] as String,
    );
  }
}
