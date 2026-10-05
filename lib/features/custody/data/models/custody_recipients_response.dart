class CustodyRecipientsResponse {
  final List<CustodyRecipientData> recipients;

  CustodyRecipientsResponse({required this.recipients});

  factory CustodyRecipientsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return CustodyRecipientsResponse(
      recipients: (data['recipients'] as List)
          .map((e) => CustodyRecipientData.fromJson(e))
          .toList(),
    );
  }
}

class CustodyRecipientData {
  final String id;
  final String type;
  final String name;
  final String email;

  CustodyRecipientData({
    required this.id,
    required this.type,
    required this.name,
    required this.email,
  });

  factory CustodyRecipientData.fromJson(Map<String, dynamic> json) {
    return CustodyRecipientData(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      email: json['email'] as String? ?? '',
    );
  }
}
