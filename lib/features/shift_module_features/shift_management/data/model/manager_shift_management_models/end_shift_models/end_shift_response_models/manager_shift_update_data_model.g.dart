// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_shift_update_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerShiftUpdateResponseModel _$ManagerShiftUpdateResponseModelFromJson(
  Map<String, dynamic> json,
) => ManagerShiftUpdateResponseModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: ManagerShiftUpdateDataModel.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ManagerShiftUpdateResponseModelToJson(
  ManagerShiftUpdateResponseModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.toJson(),
};

ManagerShiftUpdateDataModel _$ManagerShiftUpdateDataModelFromJson(
  Map<String, dynamic> json,
) => ManagerShiftUpdateDataModel(
  shift: ManagerHandoverShiftModel.fromJson(
    json['shift'] as Map<String, dynamic>,
  ),
  dailyTotals: DailyTotalsModel.fromJson(
    json['daily_totals'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ManagerShiftUpdateDataModelToJson(
  ManagerShiftUpdateDataModel instance,
) => <String, dynamic>{
  'shift': instance.shift.toJson(),
  'daily_totals': instance.dailyTotals.toJson(),
};

ManagerHandoverShiftModel _$ManagerHandoverShiftModelFromJson(
  Map<String, dynamic> json,
) => ManagerHandoverShiftModel(
  finalHandover: EndShiftFinalHandoverModel.fromJson(
    json['final_handover'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ManagerHandoverShiftModelToJson(
  ManagerHandoverShiftModel instance,
) => <String, dynamic>{'final_handover': instance.finalHandover};
