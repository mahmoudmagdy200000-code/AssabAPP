// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_quick_cash_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateQuickCashRequestModel _$CreateQuickCashRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateQuickCashRequestModel(
  expenseDate: json['expense_date'] as String,
  expenseName: json['expense_name'] as String,
  totalAmount: json['total_amount'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => QuickCashItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  paymentMethod: json['payment_method'] as String,
  paymentSupplierId: json['payment_supplier_id'] as String?,
  isDraft: json['is_draft'] as bool,
);

Map<String, dynamic> _$CreateQuickCashRequestModelToJson(
  CreateQuickCashRequestModel instance,
) => <String, dynamic>{
  'expense_date': instance.expenseDate,
  'expense_name': instance.expenseName,
  'total_amount': instance.totalAmount,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'payment_method': instance.paymentMethod,
  'payment_supplier_id': instance.paymentSupplierId,
  'is_draft': instance.isDraft,
};
