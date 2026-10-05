import '../../domain/enums/fixed_assets_handover_enum.dart';
import '../../domain/strategies/fixed_assets_handover_strategy.dart';
import 'fixed_assets_active_handover_session_signature_response.dart';

class FixedAssetsActiveHandoverSessionSummaryResponse {
  final String sessionId;
  final FixedAssetsHandoverStrategy status;
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

  FixedAssetsActiveHandoverSessionSummaryResponse({
    required this.sessionId,
    required this.status,
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
    required this.receiver,
    required this.senderSignedAt,
    required this.receiverSignedAt,
  });

  factory FixedAssetsActiveHandoverSessionSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final discrepanciesList = data['recordedDiscrepancies'] as List;
    final recordedDiscrepanciesList = discrepanciesList
        .map(
          (discrepancyJson) =>
              FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies.fromJson(
                discrepancyJson,
              ),
        )
        .toList();

    return FixedAssetsActiveHandoverSessionSummaryResponse(
      sessionId: data['sessionId'] as String,
      status: FixedAssetsHandoverStrategy.getStrategy(
        FixedAssetsHandoverEnum.fromString(data['status'] as String),
      ),
      date: data['date'] as String,
      duration: data['duration'] as String,
      assetsCount: data['assetsCount'] as int,
      value: (data['value'] as num).toDouble(),
      acceptedCount: data['acceptedCount'] as int,
      acceptedPercentage: (data['acceptedPercentage'] as num).toDouble(),
      noteCount: data['noteCount'] as int,
      rejectedCount: data['rejectedCount'] as int,
      photoTakenCount: data['photoTakenCount'] as int,
      recordedDiscrepancies: recordedDiscrepanciesList,
      sender: FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
        data['sender'] as Map<String, dynamic>,
      ),
      receiver: FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
        data['receiver'] as Map<String, dynamic>,
      ),
      senderSignedAt: data['senderSignedAt'] as String,
      receiverSignedAt: data['receiverSignedAt'] as String,
    );
  }
}

class FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies {
  final String assetId;
  final String assetName;
  final String assetCode;
  final String assetImageUrl;
  final String zoneName;

  FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies({
    required this.assetId,
    required this.assetName,
    required this.assetCode,
    required this.assetImageUrl,
    required this.zoneName,
  });

  factory FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsActiveHandoverSessionSummaryRecordedDiscrepancies(
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      assetCode: json['assetCode'] as String,
      assetImageUrl: json['assetImageUrl'] as String,
      zoneName: json['zoneName'] as String,
    );
  }
}
