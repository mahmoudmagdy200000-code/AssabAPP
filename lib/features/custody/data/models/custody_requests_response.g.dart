// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custody_requests_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustodyRequestsResponse _$CustodyRequestsResponseFromJson(
  Map<String, dynamic> json,
) => CustodyRequestsResponse(
  data: CustodyRequestsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustodyRequestsResponseToJson(
  CustodyRequestsResponse instance,
) => <String, dynamic>{'data': instance.data};

CustodyRequestsData _$CustodyRequestsDataFromJson(Map<String, dynamic> json) =>
    CustodyRequestsData(
      requests: (json['requests'] as List<dynamic>)
          .map((e) => CustodyRequestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustodyRequestsDataToJson(
  CustodyRequestsData instance,
) => <String, dynamic>{'requests': instance.requests};

CustodyRequestItem _$CustodyRequestItemFromJson(Map<String, dynamic> json) =>
    CustodyRequestItem(
      id: json['id'] as String,
      type: json['type'] as String,
      submittedBy: json['submittedBy'] as String,
      dateTime: json['dateTime'] as String,
      status: $enumDecode(_$CustodyRequestsStatusEnumEnumMap, json['status']),
      amount: json['amount'] as num,
      preferredReceiptMethod: json['preferredReceiptMethod'] as String,
      purpose: json['purpose'] as String,
    );

Map<String, dynamic> _$CustodyRequestItemToJson(CustodyRequestItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'submittedBy': instance.submittedBy,
      'dateTime': instance.dateTime,
      'status': _$CustodyRequestsStatusEnumEnumMap[instance.status]!,
      'amount': instance.amount,
      'preferredReceiptMethod': instance.preferredReceiptMethod,
      'purpose': instance.purpose,
    };

const _$CustodyRequestsStatusEnumEnumMap = {
  CustodyRequestsStatusEnum.non: 'non',
  CustodyRequestsStatusEnum.all: 'all',
  CustodyRequestsStatusEnum.pending: 'pending',
  CustodyRequestsStatusEnum.approved: 'approved',
  CustodyRequestsStatusEnum.rejected: 'rejected',
};
