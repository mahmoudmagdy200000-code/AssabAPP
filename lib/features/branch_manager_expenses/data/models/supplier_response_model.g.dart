// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierResponseModel _$SupplierResponseModelFromJson(
  Map<String, dynamic> json,
) => SupplierResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => SupplierModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SupplierResponseModelToJson(
  SupplierResponseModel instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};
