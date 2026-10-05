class SupplierNeedTimeRequest {
  final String reason;
  final String newNeededByDate;

  SupplierNeedTimeRequest({
    required this.reason,
    required this.newNeededByDate,
  });

  Map<String, dynamic> toJson() {
    return {'reason': reason, 'new_delivery_time': newNeededByDate};
  }
}
