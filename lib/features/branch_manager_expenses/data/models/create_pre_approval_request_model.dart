import 'dart:io';

import 'package:assab/core/enums/payment_method.dart';
import 'package:dio/dio.dart';

class CreatePreApprovalRequestModel {
  final String purpose;
  final String estimatedAmount;
  final String supplierId;
  final String paymentMethod;
  final String paymentSupplierId;
  final List<File> invoiceReceipt;
  final String priority;
  final List<ItemPreApprovalModel> items;
  final List<ExpensePreApprovalModel> expenses;
  final bool isDraft;

  CreatePreApprovalRequestModel({
    required this.purpose,
    required this.estimatedAmount,
    required this.supplierId,
    required this.paymentMethod,
    required this.paymentSupplierId,
    required this.invoiceReceipt,
    required this.priority,
    required this.items,
    required this.expenses,
    required this.isDraft,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(MapEntry('purpose', purpose));
    formData.fields.add(MapEntry('estimated_amount', estimatedAmount));
    formData.fields.add(MapEntry('payment_method', paymentMethod));
    formData.fields.add(MapEntry('priority', priority));

    if (supplierId.isNotEmpty) {
      formData.fields.add(MapEntry('supplier_id', supplierId.toString()));
    }

    if (paymentSupplierId.isNotEmpty &&
        paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      formData.fields.add(
        MapEntry('payment_supplier_id', paymentSupplierId.toString()),
      );
    }

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      formData.fields.add(MapEntry('items[$i][category_id]', item.categoryId));
      formData.fields.add(MapEntry('items[$i][description]', item.name));
      formData.fields.add(MapEntry('items[$i][quantity]', item.quantity));
      formData.fields.add(MapEntry('items[$i][rate]', item.unitPrice));
    }

    for (var i = 0; i < expenses.length; i++) {
      final expense = expenses[i];

      formData.fields.add(
        MapEntry('expenses[$i][category_id]', expense.categoryId),
      );
      formData.fields.add(MapEntry('expenses[$i][description]', expense.name));
      formData.fields.add(MapEntry('expenses[$i][price]', expense.price));
    }

    for (var i = 0; i < invoiceReceipt.length; i++) {
      final file = invoiceReceipt[i];

      formData.files.add(
        MapEntry(
          'attachments[$i]',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    formData.fields.add(MapEntry('is_draft', isDraft ? '1' : '0'));

    return formData;
  }
}

class ItemPreApprovalModel {
  final String categoryId;
  final String name;
  final String quantity;
  final String unitPrice;

  ItemPreApprovalModel({
    required this.categoryId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
}

class ExpensePreApprovalModel {
  final String categoryId;
  final String name;
  final String price;

  ExpensePreApprovalModel({
    required this.categoryId,
    required this.name,
    required this.price,
  });
}
