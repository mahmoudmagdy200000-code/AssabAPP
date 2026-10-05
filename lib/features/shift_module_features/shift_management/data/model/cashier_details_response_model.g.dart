// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashier_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashierResponseModel _$CashierResponseModelFromJson(
  Map<String, dynamic> json,
) => CashierResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: CashierData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashierResponseModelToJson(
  CashierResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

CashierData _$CashierDataFromJson(Map<String, dynamic> json) => CashierData(
  cashier: CashierModel.fromJson(json['cashier'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CashierDataToJson(CashierData instance) =>
    <String, dynamic>{'cashier': instance.cashier};
