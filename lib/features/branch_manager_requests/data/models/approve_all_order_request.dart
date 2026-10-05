class ApproveAllOrderRequest {
  String? readyTime;

  ApproveAllOrderRequest({this.readyTime});

  Map<String, dynamic> toJson() {
    return {'ready_time': readyTime};
  }

  void updateReadyTime(String readyTime) {
    this.readyTime = readyTime;
  }
}
