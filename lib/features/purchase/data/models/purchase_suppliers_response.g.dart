// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_suppliers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseSuppliersResponse _$PurchaseSuppliersResponseFromJson(
  Map<String, dynamic> json,
) => PurchaseSuppliersResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => PurchaseSuppliersData.fromJson(e as Map<String, dynamic>))
      .toList(),
);
