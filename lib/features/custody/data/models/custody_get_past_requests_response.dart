class CustodyGetPastRequestsResponse {
  final List<CustodyGetPastRequestData> previousRequests;

  CustodyGetPastRequestsResponse({required this.previousRequests});

  factory CustodyGetPastRequestsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return CustodyGetPastRequestsResponse(
      previousRequests: (data['previousRequests'] as List)
          .map((e) => CustodyGetPastRequestData.fromJson(e))
          .toList(),
    );
  }
}

class CustodyGetPastRequestData {
  final String id;
  final double requestedAmount;
  final String purpose;
  final String preferredReceiptMethod;
  final String createdAt;

  CustodyGetPastRequestData({
    required this.id,
    required this.requestedAmount,
    required this.purpose,
    required this.preferredReceiptMethod,
    required this.createdAt,
  });

  factory CustodyGetPastRequestData.fromJson(Map<String, dynamic> json) {
    return CustodyGetPastRequestData(
      id: json['id'] as String,
      requestedAmount: (json['requestedAmount'] as num).toDouble(),
      purpose: json['purpose'] as String,
      preferredReceiptMethod: json['preferredReceiptMethod'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
