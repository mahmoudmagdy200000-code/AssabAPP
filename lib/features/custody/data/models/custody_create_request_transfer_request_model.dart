class CustodyCreateRequestTransferRequestModel {
  final double transferAmount;

  CustodyCreateRequestTransferRequestModel({required this.transferAmount});

  Map<String, dynamic> toJson() {
    return {'transferAmount': transferAmount};
  }
}
