import 'dart:io';

import 'package:assab/core/enums/payment_method.dart';
import 'package:dio/dio.dart';

class CreateSingleInvoiceRequestModel {
  final String supplierId;
  final String invoiceNumber;
  final String totalAmount;
  final String issueDate;
  final bool isTaxInvoice;
  final String? taxId;
  final List<ItemSingleInvoiceModel> items;
  final List<ExpenseSingleInvoiceModel> expenses;
  final String paymentType;
  final String paymentMethod;
  final String paymentSupplierId;
  final String paidAmount;
  final String dueDate;
  final List<File> invoiceReceipt;
  final bool isDraft;
  final String vatSupplierName;
  final String netAmount;
  final String vatAmount;
  final String vatTotalAmount;

  CreateSingleInvoiceRequestModel({
    required this.supplierId,
    required this.paymentSupplierId,
    required this.invoiceNumber,
    required this.issueDate,
    required this.isTaxInvoice,
    required this.totalAmount,
    required this.taxId,
    required this.items,
    required this.expenses,
    required this.paymentType,
    required this.paymentMethod,
    required this.paidAmount,
    required this.dueDate,
    required this.invoiceReceipt,
    required this.isDraft,
    required this.vatSupplierName,
    required this.netAmount,
    required this.vatAmount,
    required this.vatTotalAmount,
  });

  Future<FormData> toFormData() async {
    final formData = FormData();

    formData.fields.add(MapEntry('supplier_id', supplierId.toString()));
    formData.fields.add(MapEntry('invoice_number', invoiceNumber));
    formData.fields.add(MapEntry('issue_date', issueDate));
    formData.fields.add(MapEntry('is_tax_invoice', isTaxInvoice ? '1' : '0'));
    formData.fields.add(MapEntry('total_amount', totalAmount));

    if (paymentSupplierId.isNotEmpty &&
        paymentMethod == PaymentMethod.supplier.paymentMethodToString()) {
      formData.fields.add(MapEntry('payment_supplier_id', paymentSupplierId));
    }

    if (taxId != null) {
      formData.fields.add(MapEntry('tax_id', taxId!));
    }

    if (isTaxInvoice) {
      formData.fields.add(
        MapEntry('tax_invoice_details[supplier_name]', vatSupplierName),
      );
      formData.fields.add(
        MapEntry('tax_invoice_details[net_amount]', netAmount),
      );
      formData.fields.add(
        MapEntry('tax_invoice_details[vat_amount]', vatAmount),
      );
      formData.fields.add(
        MapEntry('tax_invoice_details[total_amount]', vatTotalAmount),
      );
    }

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      formData.fields.add(MapEntry('items[$i][category_id]', item.categoryId));
      formData.fields.add(MapEntry('items[$i][name]', item.name));
      formData.fields.add(MapEntry('items[$i][quantity]', item.quantity));
      formData.fields.add(MapEntry('items[$i][unit_price]', item.unitPrice));
    }

    for (var i = 0; i < expenses.length; i++) {
      final expense = expenses[i];
      formData.fields.add(
        MapEntry('expenses[$i][category_id]', expense.categoryId),
      );
      formData.fields.add(MapEntry('expenses[$i][name]', expense.name));
      formData.fields.add(MapEntry('expenses[$i][price]', expense.price));
    }

    formData.fields.add(MapEntry('payment_type', paymentType));

    if (paymentMethod.isNotEmpty) {
      formData.fields.add(MapEntry('payment_method', paymentMethod));
    }

    if (paidAmount.isNotEmpty) {
      formData.fields.add(MapEntry('paid_amount', paidAmount));
    }

    if (dueDate.isNotEmpty) {
      formData.fields.add(MapEntry('due_date', dueDate));
    }
    formData.fields.add(MapEntry('is_draft', isDraft ? '1' : '0'));

    for (var i = 0; i < invoiceReceipt.length; i++) {
      final file = invoiceReceipt[i];
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

    return formData;
  }
}

class ItemSingleInvoiceModel {
  final String categoryId;
  final String name;
  final String quantity;
  final String unitPrice;

  ItemSingleInvoiceModel({
    required this.categoryId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
}

class ExpenseSingleInvoiceModel {
  final String categoryId;
  final String name;
  final String price;

  ExpenseSingleInvoiceModel({
    required this.categoryId,
    required this.name,
    required this.price,
  });
}
