import 'package:json_annotation/json_annotation.dart';

import '../../../../core/enums/custody_requests_status_enum.dart';

part 'custody_requests_response.g.dart';

@JsonSerializable()
class CustodyRequestsResponse {
  final CustodyRequestsData data;

  CustodyRequestsResponse({required this.data});

  factory CustodyRequestsResponse.fromJson(Map<String, dynamic> json) =>
      _$CustodyRequestsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustodyRequestsResponseToJson(this);
}

@JsonSerializable()
class CustodyRequestsData {
  final List<CustodyRequestItem> requests;

  CustodyRequestsData({required this.requests});

  factory CustodyRequestsData.fromJson(Map<String, dynamic> json) =>
      _$CustodyRequestsDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustodyRequestsDataToJson(this);
}

@JsonSerializable()
class CustodyRequestItem {
  final String id;
  final String type;
  final String submittedBy;
  final String dateTime;
  final CustodyRequestsStatusEnum status;
  final num amount;
  final String preferredReceiptMethod;
  final String purpose;

  CustodyRequestItem({
    required this.id,
    required this.type,
    required this.submittedBy,
    required this.dateTime,
    required this.status,
    required this.amount,
    required this.preferredReceiptMethod,
    required this.purpose,
  });

  factory CustodyRequestItem.fromJson(Map<String, dynamic> json) {
    return CustodyRequestItem(
      id: json['id'] as String,
      type: json['type'] as String,
      submittedBy: json['submittedBy'] as String,
      dateTime: json['dateTime'] as String,
      status: CustodyRequestsStatusEnum.fromValue(json['status'] as String),
      amount: json['amount'] as num,
      preferredReceiptMethod: json['preferredReceiptMethod'] as String? ?? '-',
      purpose: json['purpose'] as String? ?? '-',
    );
  }

  Map<String, dynamic> toJson() => _$CustodyRequestItemToJson(this);
}
