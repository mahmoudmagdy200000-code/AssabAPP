import 'package:assab/shared/models/time_line_response.dart';

import '../../../../core/enums/purchasing_officer_notification_enum.dart';
import '../../domain/enums/fixed_assets_handover_enum.dart';
import '../../domain/enums/fixed_assets_handover_type_enum.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';
import '../../domain/strategies/fixed_assets_handover_type_strategy.dart';
import 'fixed_assets_active_handover_session_signature_response.dart';
import 'fixed_assets_active_handover_session_summary_response.dart';

class FixedAssetsHandoverDetailsResponse {
  final String handoverId;
  final FixedAssetsHandoverStrategy status;
  final FixedAssetsHandoverTypeStrategy type;
  final FixedAssetsHandoverDetailsInitiated initiatedDetails;
  final String recipientName;

  // if status pending or completed
  final FixedAssetsHandoverDetailsCompleted? completedDetails;
  final bool isDeduction;
  final FixedAssetsHandoverDetailsCompletedDeduction? deductionDetails;
  final TimeLineResponse timeLine;

  FixedAssetsHandoverDetailsResponse({
    required this.handoverId,
    required this.status,
    required this.type,
    required this.initiatedDetails,
    required this.recipientName,
    required this.completedDetails,
    required this.isDeduction,
    required this.deductionDetails,
    required this.timeLine,
  });

  factory FixedAssetsHandoverDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return FixedAssetsHandoverDetailsResponse(
      handoverId: data['handoverId'] as String,
      status: FixedAssetsHandoverStrategy.getStrategy(
        FixedAssetsHandoverEnum.fromString(data['status'] as String),
      ),
      type: FixedAssetsHandoverTypeStrategy.getStrategy(
        FixedAssetsHandoverTypeEnum.fromString(data['type'] as String),
      ),
      initiatedDetails: FixedAssetsHandoverDetailsInitiated.fromJson(
        data['initiatedDetails'],
      ),
      recipientName: data['recipientName'] as String,
      completedDetails: data['completedDetails'] != null
          ? FixedAssetsHandoverDetailsCompleted.fromJson(
              data['completedDetails'],
            )
          : null,
      isDeduction: data['isDeduction'] as bool? ?? false,
      deductionDetails: data['deductionDetails'] != null
          ? FixedAssetsHandoverDetailsCompletedDeduction.fromJson(
              data['deductionDetails'],
            )
          : null,
      timeLine: TimeLineResponse.fromJson(data),
    );
  }
}

class FixedAssetsHandoverDetailsInitiated {
  final String qrCodeImageUrl;
  final String sessionCode;
  final FixedAssetsHandoverDetailsInitiatedReceiver receiver;
  final List<FixedAssetsHandoverDetailsInitiatedZones> zones;
  final String note;
  final List<PurchasingOfficerNotificationEnum> notifications;

  FixedAssetsHandoverDetailsInitiated({
    required this.qrCodeImageUrl,
    required this.sessionCode,
    required this.receiver,
    required this.zones,
    required this.note,
    required this.notifications,
  });

  factory FixedAssetsHandoverDetailsInitiated.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsHandoverDetailsInitiated(
      qrCodeImageUrl: json['qrCodeImageUrl'] as String,
      sessionCode: json['sessionCode'] as String,
      receiver: FixedAssetsHandoverDetailsInitiatedReceiver.fromJson(
        json['receiver'],
      ),
      zones: List<FixedAssetsHandoverDetailsInitiatedZones>.from(
        (json['zones'] as List<dynamic>? ?? []).map(
          (e) => FixedAssetsHandoverDetailsInitiatedZones.fromJson(
            e as Map<String, dynamic>,
          ),
        ),
      ),
      note: json['note'] as String,
      notifications: List<PurchasingOfficerNotificationEnum>.from(
        (json['notifications'] as List<dynamic>? ?? []).map(
          (e) => PurchasingOfficerNotificationEnum.fromString(e as String),
        ),
      ),
    );
  }
}

class FixedAssetsHandoverDetailsInitiatedReceiver {
  final String receiverName;
  final String receiverImageUrl;
  final String receiverNumber;

  FixedAssetsHandoverDetailsInitiatedReceiver({
    required this.receiverName,
    required this.receiverImageUrl,
    required this.receiverNumber,
  });

  factory FixedAssetsHandoverDetailsInitiatedReceiver.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsHandoverDetailsInitiatedReceiver(
      receiverName: json['receiverName'] as String,
      receiverImageUrl: json['receiverImageUrl'] as String,
      receiverNumber: json['receiverNumber'] as String,
    );
  }
}

class FixedAssetsHandoverDetailsInitiatedZones {
  final String zoneName;
  final int assetsCountHandedOver;

  FixedAssetsHandoverDetailsInitiatedZones({
    required this.zoneName,
    required this.assetsCountHandedOver,
  });

  factory FixedAssetsHandoverDetailsInitiatedZones.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsHandoverDetailsInitiatedZones(
      zoneName: json['zoneName'] as String,
      assetsCountHandedOver: (json['assetsCountHandedOver'] as num).toInt(),
    );
  }
}

class FixedAssetsHandoverDetailsCompleted {
  final String date;
  final String duration;
  final int assetsCount;
  final double value;
  final int acceptedCount;
  final double acceptedPercentage;
  final int noteCount;
  final int rejectedCount;
  final int photoTakenCount;
  final List<FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies>
  recordedDiscrepancies;
  final FixedAssetsActiveHandoverSessionSignatureItem sender;
  final String senderSignedAt;
  final FixedAssetsActiveHandoverSessionSignatureItem receiver;
  final String receiverSignedAt;

  FixedAssetsHandoverDetailsCompleted({
    required this.date,
    required this.duration,
    required this.assetsCount,
    required this.value,
    required this.acceptedCount,
    required this.acceptedPercentage,
    required this.noteCount,
    required this.rejectedCount,
    required this.photoTakenCount,
    required this.recordedDiscrepancies,
    required this.sender,
    required this.senderSignedAt,
    required this.receiver,
    required this.receiverSignedAt,
  });

  factory FixedAssetsHandoverDetailsCompleted.fromJson(
    Map<String, dynamic> json,
  ) {
    final discrepanciesList = json['recordedDiscrepancies'] as List;
    final recordedDiscrepanciesList = discrepanciesList
        .map(
          (discrepancyJson) =>
              FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies.fromJson(
                discrepancyJson,
              ),
        )
        .toList();

    return FixedAssetsHandoverDetailsCompleted(
      date: json['date'] as String,
      duration: json['duration'] as String,
      assetsCount: json['assetsCount'] as int,
      value: (json['value'] as num).toDouble(),
      acceptedCount: json['acceptedCount'] as int,
      acceptedPercentage: (json['acceptedPercentage'] as num).toDouble(),
      noteCount: json['noteCount'] as int,
      rejectedCount: json['rejectedCount'] as int,
      photoTakenCount: json['photoTakenCount'] as int,
      recordedDiscrepancies: recordedDiscrepanciesList,
      sender: FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
        json['sender'],
      ),
      senderSignedAt: json['senderSignedAt'] as String? ?? '',
      receiver: FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
        json['receiver'],
      ),
      receiverSignedAt: json['receiverSignedAt'] as String? ?? '',
    );
  }
}

class FixedAssetsHandoverDetailsCompletedDeduction {
  final String employeeName;
  final double amount;
  final String reason;

  FixedAssetsHandoverDetailsCompletedDeduction({
    required this.employeeName,
    required this.amount,
    required this.reason,
  });

  factory FixedAssetsHandoverDetailsCompletedDeduction.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsHandoverDetailsCompletedDeduction(
      employeeName: json['employee_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String,
    );
  }
}
