// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'final_handover_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndShiftFinalHandoverModel _$EndShiftFinalHandoverModelFromJson(
  Map<String, dynamic> json,
) => EndShiftFinalHandoverModel(
  handoverAmount: (json['handover_amount'] as num?)?.toDouble(),
  status: json['status'] as String?,
  handoverFrom: json['handover_from'] as String?,
  handoverTo: json['handover_to'] as String?,
  handoverDate: json['handover_date'] as String?,
  handoverTime: json['handover_time'] as String?,
  handoverNotes: json['handover_notes'] as String?,
);

Map<String, dynamic> _$EndShiftFinalHandoverModelToJson(
  EndShiftFinalHandoverModel instance,
) => <String, dynamic>{
  'handover_amount': instance.handoverAmount,
  'status': instance.status,
  'handover_from': instance.handoverFrom,
  'handover_to': instance.handoverTo,
  'handover_date': instance.handoverDate,
  'handover_time': instance.handoverTime,
  'handover_notes': instance.handoverNotes,
};
