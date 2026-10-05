class RejectAllOrderRequest {
  final String reason;

  RejectAllOrderRequest({required this.reason});

  Map<String, dynamic> toJson() {
    return {'reason': reason};
  }
}
