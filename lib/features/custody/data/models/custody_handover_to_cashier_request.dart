class CustodyHandoverToCashierRequest {
  final String recipientId;
  final String recipientType;
  final double handoverAmount;
  final String? additionalNotes;
  final String handoverMethod;
  final String handoverDate;

  CustodyHandoverToCashierRequest({
    required this.recipientId,
    required this.recipientType,
    required this.handoverAmount,
    this.additionalNotes,
    required this.handoverMethod,
    required this.handoverDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
      'recipientType': recipientType,
      'handoverAmount': handoverAmount,
      'additionalNotes': additionalNotes,
      'handoverMethod': handoverMethod,
      'handoverDate': handoverDate,
    };
  }
}
