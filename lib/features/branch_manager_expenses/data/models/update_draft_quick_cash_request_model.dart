import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/features/branch_manager_expenses/data/models/quick_cash_item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_draft_quick_cash_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateDraftQuickCashRequestModel {
  @JsonKey(name: 'expense_date')
  final String expenseDate;

  @JsonKey(name: 'expense_name')
  final String expenseName;

  @JsonKey(name: 'total_amount')
  final String totalAmount;

  final List<QuickCashItemModel> items;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'delete_attachments')
  final List<String>? deleteAttachments;

  @JsonKey(name: 'payment_supplier_id')
  final String? paymentSupplierId;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  UpdateDraftQuickCashRequestModel({
    required this.expenseDate,
    required this.expenseName,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    this.deleteAttachments,
    this.paymentSupplierId,
    required this.isDraft,
  });

  factory UpdateDraftQuickCashRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateDraftQuickCashRequestModelFromJson(json);

  Map<String, dynamic> toJson() {
    final json = {
      'expense_date': expenseDate,
      'expense_name': expenseName,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'delete_attachments': deleteAttachments,
      'is_draft': isDraft ? 1 : 0,
    };

    final itemsList = items.map((item) => item.toJson()).toList();

    if (itemsList.isNotEmpty) {
      json['items'] = itemsList;
    }

    if (paymentSupplierId != null &&
        paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      json['payment_supplier_id'] = paymentSupplierId;
    }

    return json;
  }
}
