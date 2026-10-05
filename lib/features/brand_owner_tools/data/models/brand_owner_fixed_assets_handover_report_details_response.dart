import 'package:assab/features/brand_owner_tools/domain/stragegies/brand_owner_fixed_assets_handover_reports_status_strategy.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:assab/shared/models/time_line_response.dart';

class BrandOwnerFixedAssetsHandoverReportDetailsResponse {
  final String id;
  final BrandOwnerFixedAssetsHandoverReportsStatusStrategy status;
  final BrandOwnerFixedAssetsHandoverReportRouteDetails routeDetails;
  final List<BrandOwnerFixedAssetsHandoverReportAssetDetails> assets;
  final BrandOwnerFixedAssetsHandoverReportSignatureDetails signatureDetails;
  final BrandOwnerFixedAssetsHandoverReportFinancialAnalysis financialAnalysis;
  final String? employeeResponsible;
  final String? warningNote;
  final String? salaryDeductionAmount;
  final String? salaryDeductionReason;
  final String? approvedOn;
  final CancelReasonResponse? cancelReasonResponse;
  final TimeLineResponse timelines;

  const BrandOwnerFixedAssetsHandoverReportDetailsResponse({
    required this.id,
    required this.status,
    required this.routeDetails,
    required this.assets,
    required this.signatureDetails,
    required this.financialAnalysis,
    required this.employeeResponsible,
    required this.warningNote,
    required this.salaryDeductionAmount,
    required this.salaryDeductionReason,
    required this.approvedOn,
    required this.cancelReasonResponse,
    required this.timelines,
  });

  factory BrandOwnerFixedAssetsHandoverReportDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;

    return BrandOwnerFixedAssetsHandoverReportDetailsResponse(
      id: data['id'] as String,
      status: BrandOwnerFixedAssetsHandoverReportsStatusStrategy.fromStatus(
        data['status'] as String,
      ),
      routeDetails: BrandOwnerFixedAssetsHandoverReportRouteDetails.fromJson(
        data['route_details'] as Map<String, dynamic>,
      ),
      assets: (data['assets'] as List)
          .map(
            (assetJson) =>
                BrandOwnerFixedAssetsHandoverReportAssetDetails.fromJson(
                  assetJson,
                ),
          )
          .toList(),
      signatureDetails:
          BrandOwnerFixedAssetsHandoverReportSignatureDetails.fromJson(
            data['signature_details'] as Map<String, dynamic>,
          ),
      financialAnalysis:
          BrandOwnerFixedAssetsHandoverReportFinancialAnalysis.fromJson(
            data['financial_analysis'] as Map<String, dynamic>,
          ),
      employeeResponsible: data['employee_responsible'] as String?,
      warningNote: data['warning_note'] as String?,
      salaryDeductionAmount: data['salary_deduction_amount'] as String?,
      salaryDeductionReason: data['salary_deduction_reason'] as String?,
      approvedOn: data['approved_on'] as String?,
      cancelReasonResponse: data['cancellation'] == null
          ? null
          : CancelReasonInOrderResponse.fromJson(
              data['cancellation'] as Map<String, dynamic>,
            ).toCancelReasonResponse(),
      timelines: TimeLineResponse.fromJson(data),
    );
  }

  BrandOwnerFixedAssetsHandoverReportDetailsResponse copyWith({
    BrandOwnerFixedAssetsHandoverReportsStatusStrategy? status,
    BrandOwnerFixedAssetsHandoverReportRouteDetails? routeDetails,
    List<BrandOwnerFixedAssetsHandoverReportAssetDetails>? assets,
    BrandOwnerFixedAssetsHandoverReportSignatureDetails? signatureDetails,
    BrandOwnerFixedAssetsHandoverReportFinancialAnalysis? financialAnalysis,
    String? employeeResponsible,
    String? warningNote,
    String? salaryDeductionAmount,
    String? salaryDeductionReason,
    String? approvedOn,
    CancelReasonResponse? cancelReasonResponse,
    bool clearApprovedOn = false,
    bool clearCancelReasonResponse = false,
    bool clearWarningNote = false,
    bool clearSalaryDeductionAmount = false,
    bool clearSalaryDeductionReason = false,
    TimeLineResponse? timelines,
  }) {
    return BrandOwnerFixedAssetsHandoverReportDetailsResponse(
      id: id,
      status: status ?? this.status,
      routeDetails: routeDetails ?? this.routeDetails,
      assets: assets ?? this.assets,
      signatureDetails: signatureDetails ?? this.signatureDetails,
      financialAnalysis: financialAnalysis ?? this.financialAnalysis,
      employeeResponsible: employeeResponsible ?? this.employeeResponsible,
      warningNote: clearWarningNote ? null : warningNote ?? this.warningNote,
      salaryDeductionAmount: clearSalaryDeductionAmount
          ? null
          : salaryDeductionAmount ?? this.salaryDeductionAmount,
      salaryDeductionReason: clearSalaryDeductionReason
          ? null
          : salaryDeductionReason ?? this.salaryDeductionReason,
      approvedOn: clearApprovedOn ? null : approvedOn ?? this.approvedOn,
      cancelReasonResponse: clearCancelReasonResponse
          ? null
          : cancelReasonResponse ?? this.cancelReasonResponse,
      timelines: timelines ?? this.timelines,
    );
  }
}

class BrandOwnerFixedAssetsHandoverReportRouteDetails {
  final String requestId;
  final String sessionCode;
  final String fromBranchName;
  final String toBranchName;
  final String successRate;
  final String discrepancies;
  final String handoverDate;
  final String sessionDuration;

  const BrandOwnerFixedAssetsHandoverReportRouteDetails({
    required this.requestId,
    required this.sessionCode,
    required this.fromBranchName,
    required this.toBranchName,
    required this.successRate,
    required this.discrepancies,
    required this.handoverDate,
    required this.sessionDuration,
  });

  factory BrandOwnerFixedAssetsHandoverReportRouteDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsHandoverReportRouteDetails(
      requestId: json['request_id'] as String,
      sessionCode: json['session_code'] as String,
      fromBranchName: json['from_branch_name'] as String,
      toBranchName: json['to_branch_name'] as String,
      successRate: json['success_rate'] as String,
      discrepancies: json['discrepancies'] as String,
      handoverDate: json['handover_date'] as String,
      sessionDuration: json['session_duration'] as String,
    );
  }
}

class BrandOwnerFixedAssetsHandoverReportAssetDetails {
  final String imageUrl;
  final String name;
  final String subtitle;
  final String affectedValue;
  final String evidenceCaption;
  final String evidenceImageUrl;

  const BrandOwnerFixedAssetsHandoverReportAssetDetails({
    required this.imageUrl,
    required this.name,
    required this.subtitle,
    required this.affectedValue,
    required this.evidenceCaption,
    required this.evidenceImageUrl,
  });

  factory BrandOwnerFixedAssetsHandoverReportAssetDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsHandoverReportAssetDetails(
      imageUrl: json['image_url'] as String? ?? '',
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      affectedValue: json['affected_value'] as String,
      evidenceCaption: json['evidence_caption'] as String,
      evidenceImageUrl: json['evidence_image_url'] as String? ?? '',
    );
  }
}

class BrandOwnerFixedAssetsHandoverReportSignatureDetails {
  final BrandOwnerFixedAssetsHandoverReportSignatureItem sender;
  final BrandOwnerFixedAssetsHandoverReportSignatureItem receiver;

  const BrandOwnerFixedAssetsHandoverReportSignatureDetails({
    required this.sender,
    required this.receiver,
  });

  factory BrandOwnerFixedAssetsHandoverReportSignatureDetails.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsHandoverReportSignatureDetails(
      sender: BrandOwnerFixedAssetsHandoverReportSignatureItem.fromJson(
        json['sender'] as Map<String, dynamic>,
      ),
      receiver: BrandOwnerFixedAssetsHandoverReportSignatureItem.fromJson(
        json['receiver'] as Map<String, dynamic>,
      ),
    );
  }
}

class BrandOwnerFixedAssetsHandoverReportSignatureItem {
  final String name;
  final String roleLabel;
  final String signedAt;
  final String note;
  final String imageUrl;

  const BrandOwnerFixedAssetsHandoverReportSignatureItem({
    required this.name,
    required this.roleLabel,
    required this.signedAt,
    required this.note,
    required this.imageUrl,
  });

  factory BrandOwnerFixedAssetsHandoverReportSignatureItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsHandoverReportSignatureItem(
      name: json['name'] as String,
      roleLabel: json['role_label'] as String,
      signedAt: json['signed_at'] as String,
      note: json['note'] as String,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}

class BrandOwnerFixedAssetsHandoverReportFinancialAnalysis {
  final String totalAffectedValue;
  final String impactRatio;
  final String employeeRecord;

  const BrandOwnerFixedAssetsHandoverReportFinancialAnalysis({
    required this.totalAffectedValue,
    required this.impactRatio,
    required this.employeeRecord,
  });

  factory BrandOwnerFixedAssetsHandoverReportFinancialAnalysis.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsHandoverReportFinancialAnalysis(
      totalAffectedValue: json['total_affected_value'] as String,
      impactRatio: json['impact_ratio'] as String,
      employeeRecord: json['employee_record'] as String,
    );
  }
}
