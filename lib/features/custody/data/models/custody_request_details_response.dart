import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/custody_requests_status_enum.dart';
import '../../../../shared/models/rejection_record.dart';

class CustodyRequestDetailsResponse {
  final CustodyRequestDetailsData data;

  CustodyRequestDetailsResponse({required this.data});

  factory CustodyRequestDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CustodyRequestDetailsResponse(
      data: CustodyRequestDetailsData.fromJson(json['data']),
    );
  }
}

class CustodyRequestDetailsData {
  final String requestId;
  final CustodyRequestsStatusEnum status;
  final CustodyRequestDetailsInfo details;
  final TimeLineResponse timeline;
  final RejectionRecord? rejection;
  final CustodyRequestDetailsApproval? approval;
  final bool canConfirmReceipt;
  final bool canResubmit;
  final String? resubmissionBlockReason;
  final bool cashHandoverAvailable;
  final String? cashHandoverBlockReason;

  CustodyRequestDetailsData({
    required this.requestId,
    required this.status,
    required this.details,
    required this.timeline,
    required this.approval,
    required this.rejection,
    required this.canConfirmReceipt,
    this.canResubmit = false,
    this.resubmissionBlockReason,
    this.cashHandoverAvailable = false,
    this.cashHandoverBlockReason,
  });

  factory CustodyRequestDetailsData.fromJson(Map<String, dynamic> json) {
    return CustodyRequestDetailsData(
      requestId: json['requestId'],
      status: CustodyRequestsStatusEnum.fromValue(json['status']),
      details: CustodyRequestDetailsInfo.fromJson(json['details']),
      timeline: TimeLineResponse.fromJson(json),
      approval: json['approval'] == null
          ? null
          : CustodyRequestDetailsApproval.fromJson(json['approval']),
      canConfirmReceipt: json['canConfirmReceipt'] == true,
      canResubmit: json['canResubmit'] == true,
      resubmissionBlockReason: json['resubmissionBlockReason'] as String?,
      cashHandoverAvailable: json['cashHandoverAvailable'] == true,
      cashHandoverBlockReason: json['cashHandoverBlockReason'] as String?,
      rejection: RejectionRecord.fromEnvelope(json),
    );
  }
}

class CustodyRequestDetailsApproval {
  final CustodyRequestsStatusEnum status;
  final String approvedBy;
  final String? profileImage;
  final String approvedAt;
  final String dateTime;
  final String? rejectedReason;

  CustodyRequestDetailsApproval({
    required this.status,
    required this.approvedBy,
    this.profileImage,
    required this.approvedAt,
    required this.dateTime,
    this.rejectedReason,
  });

  factory CustodyRequestDetailsApproval.fromJson(Map<String, dynamic> json) {
    return CustodyRequestDetailsApproval(
      status: CustodyRequestsStatusEnum.fromValue(json['status']),
      approvedBy: json['approvedBy'],
      profileImage: json['profileImage'],
      approvedAt: json['approvedAt'],
      dateTime: json['dateTime'],
      rejectedReason: json['rejectedReason'],
    );
  }
}

class CustodyRequestDetailsInfo {
  final double requestedAmount;
  final String purpose;
  final String preferredReceiptMethod;
  final List<CustodyRequestDetailsAttachment> attachments;
  final String? additionalNotes;

  CustodyRequestDetailsInfo({
    required this.requestedAmount,
    required this.purpose,
    required this.preferredReceiptMethod,
    required this.attachments,
    required this.additionalNotes,
  });

  factory CustodyRequestDetailsInfo.fromJson(Map<String, dynamic> json) {
    return CustodyRequestDetailsInfo(
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      purpose: json['purpose'],
      preferredReceiptMethod: json['preferredReceiptMethod'],
      attachments: (json['attachments'] as List)
          .map((e) => CustodyRequestDetailsAttachment.fromJson(e))
          .toList(),
      additionalNotes: json['additionalNotes'],
    );
  }
}

class CustodyRequestDetailsAttachment {
  final String filename;
  final String url;
  final String uploadedAt;

  CustodyRequestDetailsAttachment({
    required this.filename,
    required this.url,
    required this.uploadedAt,
  });

  factory CustodyRequestDetailsAttachment.fromJson(Map<String, dynamic> json) {
    return CustodyRequestDetailsAttachment(
      filename: json['filename'],
      url: json['url'],
      uploadedAt: json['uploadedAt'],
    );
  }
}
