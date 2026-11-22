// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_cash_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickCashResponseModel _$QuickCashResponseModelFromJson(
  Map<String, dynamic> json,
) => QuickCashResponseModel(
  data: json['data'] == null
      ? null
      : QuickCashDataModel.fromJson(json['data'] as Map<String, dynamic>),
);

QuickCashDetailsModel _$QuickCashDetailsModelFromJson(
  Map<String, dynamic> json,
) => QuickCashDetailsModel(
  expenseDate: json['expense_date'] as String?,
  expenseName: json['expense_name'] as String?,
  invoiceNumber: json['invoice_number'] as String?,
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => ExpenseItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);
