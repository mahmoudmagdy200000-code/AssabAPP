import 'dart:io';

import 'package:assab/core/enums/payment_method.dart';
import 'package:assab/features/branch_manager_expenses/data/models/quick_cash_item_model.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_quick_cash_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateQuickCashRequestModel {
  @JsonKey(name: 'expense_date')
  final String expenseDate;

  @JsonKey(name: 'expense_name')
  final String expenseName;

  @JsonKey(name: 'total_amount')
  final String totalAmount;

  final List<QuickCashItemModel> items;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<File>? invoiceReceipt;

  @JsonKey(name: 'payment_supplier_id')
  final String? paymentSupplierId;

  @JsonKey(name: 'is_draft')
  final bool isDraft;

  CreateQuickCashRequestModel({
    required this.expenseDate,
    required this.expenseName,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    this.invoiceReceipt,
    this.paymentSupplierId,
    required this.isDraft,
  });

  factory CreateQuickCashRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateQuickCashRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateQuickCashRequestModelToJson(this);

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields
      ..add(MapEntry('expense_date', expenseDate))
      ..add(MapEntry('expense_name', expenseName))
      ..add(MapEntry('total_amount', totalAmount.toString()))
      ..add(MapEntry('payment_method', paymentMethod))
      ..add(MapEntry('is_draft', isDraft ? '1' : '0'));

    if (paymentSupplierId != null &&
        paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      formData.fields.add(
        MapEntry('payment_supplier_id', paymentSupplierId.toString()),
      );
    }

    for (var i = 0; i < items.length; i++) {
      formData.fields.add(
        MapEntry('items[$i][title]', items[i].title.toString()),
      );
      formData.fields.add(
        MapEntry('items[$i][amount]', items[i].amount.toString()),
      );
    }

    if (invoiceReceipt != null) {
      for (var file in invoiceReceipt!) {
        formData.files.add(
          MapEntry(
            'invoice_receipt[]',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }
    }

    return formData;
  }
}
