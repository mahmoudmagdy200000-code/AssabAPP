// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_cashiers_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableCashiersResponse _$AvailableCashiersResponseFromJson(
  Map<String, dynamic> json,
) => AvailableCashiersResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => AvailableCashier.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AvailableCashiersResponseToJson(
  AvailableCashiersResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};

AvailableCashier _$AvailableCashierFromJson(Map<String, dynamic> json) =>
    AvailableCashier(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      image: json['image'] as String?,
      isAvailable: json['is_available'] as bool,
      reasonDisabled: json['reason_disabled'] as String?,
    );

Map<String, dynamic> _$AvailableCashierToJson(AvailableCashier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'image': instance.image,
      'is_available': instance.isAvailable,
      'reason_disabled': instance.reasonDisabled,
    };
