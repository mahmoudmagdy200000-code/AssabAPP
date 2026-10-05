class FixedAssetsStartHandoverRequest {
  final String recipientEmployeeId;
  final String note;
  final List<String> includedAssetIds;
  final List<String> sendInvitations;

  FixedAssetsStartHandoverRequest({
    required this.recipientEmployeeId,
    required this.note,
    required this.includedAssetIds,
    required this.sendInvitations,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientEmployeeId': recipientEmployeeId,
      'note': note,
      'includedAssetIds': includedAssetIds,
      'sendInvitations': sendInvitations,
    };
  }
}
