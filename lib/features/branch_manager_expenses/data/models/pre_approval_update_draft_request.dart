import 'package:assab/core/enums/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pre_approval_update_draft_request.g.dart';

@JsonSerializable(explicitToJson: true)
class PreApprovalUpdateDraftRequest {
  final String purpose;

  @JsonKey(name: 'estimated_amount')
  final double estimatedAmount;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'payment_supplier_id')
  final String paymentSupplierId;

  @JsonKey(name: 'supplier_id')
  final String supplierId;

  final String priority;

  final List<PreApprovalUpdateDraftRequestItem> items;

  final List<PreApprovalUpdateDraftRequestExpense> expenses;

  @JsonKey(name: 'delete_attachments')
  final List<String> deleteAttachments;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  PreApprovalUpdateDraftRequest({
    required this.purpose,
    required this.estimatedAmount,
    required this.paymentMethod,
    required this.paymentSupplierId,
    required this.supplierId,
    required this.priority,
    required this.items,
    required this.expenses,
    required this.deleteAttachments,
    required this.isDraft,
  });

  factory PreApprovalUpdateDraftRequest.fromJson(Map<String, dynamic> json) =>
      _$PreApprovalUpdateDraftRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = {
      'purpose': purpose,
      'estimated_amount': estimatedAmount,
      'payment_method': paymentMethod,
      'priority': priority,
      'items': items.map((item) => item.toJson()).toList(),
      'expenses': expenses.map((expense) => expense.toJson()).toList(),
      'delete_attachments': deleteAttachments,
      'is_draft': isDraft ? 1 : 0,
    };

    if (supplierId.isNotEmpty) {
      json['supplier_id'] = supplierId;
    }

    if (paymentSupplierId.isNotEmpty &&
        paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      json['payment_supplier_id'] = paymentSupplierId;
    }

    return json;
  }
}

@JsonSerializable()
class PreApprovalUpdateDraftRequestItem {
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String description;
  final double quantity;
  final double rate;

  PreApprovalUpdateDraftRequestItem({
    required this.categoryId,
    required this.description,
    required this.quantity,
    required this.rate,
  });

  factory PreApprovalUpdateDraftRequestItem.fromJson(
    Map<String, dynamic> json,
  ) => _$PreApprovalUpdateDraftRequestItemFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PreApprovalUpdateDraftRequestItemToJson(this);
}

@JsonSerializable()
class PreApprovalUpdateDraftRequestExpense {
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String description;
  final double price;

  PreApprovalUpdateDraftRequestExpense({
    required this.categoryId,
    required this.description,
    required this.price,
  });

  factory PreApprovalUpdateDraftRequestExpense.fromJson(
    Map<String, dynamic> json,
  ) => _$PreApprovalUpdateDraftRequestExpenseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PreApprovalUpdateDraftRequestExpenseToJson(this);
}
