class FixedAssetsStartHandoverResponse {
  final String sessionId;
  final String sessionCode;

  const FixedAssetsStartHandoverResponse({
    required this.sessionId,
    required this.sessionCode,
  });

  factory FixedAssetsStartHandoverResponse.fromJson(Map<String, dynamic> json) {
    return FixedAssetsStartHandoverResponse(
      sessionId: json['sessionId'] as String,
      sessionCode: json['sessionCode'] as String,
    );
  }
}
