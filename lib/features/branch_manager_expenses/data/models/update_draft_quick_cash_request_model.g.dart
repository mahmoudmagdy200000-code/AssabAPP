// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_draft_quick_cash_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateDraftQuickCashRequestModel _$UpdateDraftQuickCashRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateDraftQuickCashRequestModel(
  expenseDate: json['expense_date'] as String,
  expenseName: json['expense_name'] as String,
  totalAmount: json['total_amount'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => QuickCashItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  paymentMethod: json['payment_method'] as String,
  deleteAttachments: (json['delete_attachments'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  paymentSupplierId: json['payment_supplier_id'] as String?,
  isDraft: json['is_draft'] as bool,
);

Map<String, dynamic> _$UpdateDraftQuickCashRequestModelToJson(
  UpdateDraftQuickCashRequestModel instance,
) => <String, dynamic>{
  'expense_date': instance.expenseDate,
  'expense_name': instance.expenseName,
  'total_amount': instance.totalAmount,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'payment_method': instance.paymentMethod,
  'delete_attachments': instance.deleteAttachments,
  'payment_supplier_id': instance.paymentSupplierId,
  'is_draft': instance.isDraft,
};
