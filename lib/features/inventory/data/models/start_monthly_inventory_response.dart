class StartMonthlyInventoryResponse {
  final String sessionId;

  StartMonthlyInventoryResponse({required this.sessionId});

  factory StartMonthlyInventoryResponse.fromJson(Map<String, dynamic> json) =>
      StartMonthlyInventoryResponse(sessionId: json['data']['id']);
}
