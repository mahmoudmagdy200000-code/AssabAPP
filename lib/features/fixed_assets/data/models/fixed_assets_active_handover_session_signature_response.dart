import 'fixed_assets_active_handover_session_preview_response.dart';

class FixedAssetsActiveHandoverSessionSignatureResponse {
  final List<FixedAssetsActiveHandoverPreviewProgressItem> progressItems;
  final String timeSpent;
  final int remainingPercent;
  final FixedAssetsActiveHandoverSessionSignatureItem sender;
  final FixedAssetsActiveHandoverSessionSignatureItem receiver;

  FixedAssetsActiveHandoverSessionSignatureResponse({
    required this.progressItems,
    required this.timeSpent,
    required this.remainingPercent,
    required this.sender,
    required this.receiver,
  });

  factory FixedAssetsActiveHandoverSessionSignatureResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final progressList = data['progressItems'] as List;
    final progressItemsList = progressList
        .map(
          (itemJson) =>
              FixedAssetsActiveHandoverPreviewProgressItem.fromJson(itemJson),
        )
        .toList();

    return FixedAssetsActiveHandoverSessionSignatureResponse(
      progressItems: progressItemsList,
      timeSpent: data['timeSpent'] as String? ?? '',
      remainingPercent: data['remainingPercent'] as int? ?? 0,
      sender: FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
        data['sender'] as Map<String, dynamic>,
      ),
      receiver: FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
        data['receiver'] as Map<String, dynamic>,
      ),
    );
  }
}

class FixedAssetsActiveHandoverSessionSignatureItem {
  final String name;
  final bool isSigned;

  FixedAssetsActiveHandoverSessionSignatureItem({
    required this.name,
    required this.isSigned,
  });

  factory FixedAssetsActiveHandoverSessionSignatureItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return FixedAssetsActiveHandoverSessionSignatureItem(
      name: json['name'] as String,
      isSigned: json['isSigned'] as bool,
    );
  }
}
