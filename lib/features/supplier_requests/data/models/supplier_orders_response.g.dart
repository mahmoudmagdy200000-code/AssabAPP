// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_orders_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierOrdersResponse _$SupplierOrdersResponseFromJson(
  Map<String, dynamic> json,
) => SupplierOrdersResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => SupplierOrder.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);
