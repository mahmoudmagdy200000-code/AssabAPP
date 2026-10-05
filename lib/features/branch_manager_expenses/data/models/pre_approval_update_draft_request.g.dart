// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_approval_update_draft_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreApprovalUpdateDraftRequest _$PreApprovalUpdateDraftRequestFromJson(
  Map<String, dynamic> json,
) => PreApprovalUpdateDraftRequest(
  purpose: json['purpose'] as String,
  estimatedAmount: (json['estimated_amount'] as num).toDouble(),
  paymentMethod: json['payment_method'] as String,
  paymentSupplierId: json['payment_supplier_id'] as String,
  supplierId: json['supplier_id'] as String,
  priority: json['priority'] as String,
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => PreApprovalUpdateDraftRequestItem.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  expenses: (json['expenses'] as List<dynamic>)
      .map(
        (e) => PreApprovalUpdateDraftRequestExpense.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  deleteAttachments: (json['delete_attachments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isDraft: json['is_draft'] as bool,
);

Map<String, dynamic> _$PreApprovalUpdateDraftRequestToJson(
  PreApprovalUpdateDraftRequest instance,
) => <String, dynamic>{
  'purpose': instance.purpose,
  'estimated_amount': instance.estimatedAmount,
  'payment_method': instance.paymentMethod,
  'payment_supplier_id': instance.paymentSupplierId,
  'supplier_id': instance.supplierId,
  'priority': instance.priority,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'expenses': instance.expenses.map((e) => e.toJson()).toList(),
  'delete_attachments': instance.deleteAttachments,
  'is_draft': instance.isDraft,
};

PreApprovalUpdateDraftRequestItem _$PreApprovalUpdateDraftRequestItemFromJson(
  Map<String, dynamic> json,
) => PreApprovalUpdateDraftRequestItem(
  categoryId: json['category_id'] as String,
  description: json['description'] as String,
  quantity: (json['quantity'] as num).toDouble(),
  rate: (json['rate'] as num).toDouble(),
);

Map<String, dynamic> _$PreApprovalUpdateDraftRequestItemToJson(
  PreApprovalUpdateDraftRequestItem instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'description': instance.description,
  'quantity': instance.quantity,
  'rate': instance.rate,
};

PreApprovalUpdateDraftRequestExpense
_$PreApprovalUpdateDraftRequestExpenseFromJson(Map<String, dynamic> json) =>
    PreApprovalUpdateDraftRequestExpense(
      categoryId: json['category_id'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PreApprovalUpdateDraftRequestExpenseToJson(
  PreApprovalUpdateDraftRequestExpense instance,
) => <String, dynamic>{
  'category_id': instance.categoryId,
  'description': instance.description,
  'price': instance.price,
};
