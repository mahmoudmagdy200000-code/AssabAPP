// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_invoice_previous_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleInvoicePreviousResponseModel _$SingleInvoicePreviousResponseModelFromJson(
  Map<String, dynamic> json,
) => SingleInvoicePreviousResponseModel(
  data: (json['data'] as List<dynamic>)
      .map((e) => SingleInvoiceDataModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>),
);
