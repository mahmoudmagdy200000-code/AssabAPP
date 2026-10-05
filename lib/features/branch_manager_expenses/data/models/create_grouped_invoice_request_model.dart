import 'dart:io';

import 'package:assab/core/enums/payment_method.dart';
import 'package:dio/dio.dart';

class GroupedInvoiceRequestModel {
  final String supplierId;
  final String paymentType;
  final String paymentMethod;
  final String paymentSupplierId;
  final String dueDate;
  final bool isDraft;
  final List<GroupedInvoiceInvoiceModel> invoices;

  const GroupedInvoiceRequestModel({
    required this.supplierId,
    required this.paymentType,
    required this.paymentMethod,
    required this.paymentSupplierId,
    required this.dueDate,
    required this.isDraft,
    required this.invoices,
  });

  Future<FormData> toFormData() async {
    final formDataMap = <String, dynamic>{
      'payment_type': paymentType,
      'default_supplier_id': supplierId,
      'is_draft': isDraft ? '1' : '0',
    };

    if (paymentMethod.isNotEmpty) {
      formDataMap['payment_method'] = paymentMethod;
      if (paymentMethod == PaymentMethod.supplier.paymentMethodToString() &&
          paymentSupplierId.isNotEmpty) {
        formDataMap['payment_supplier_id'] = paymentSupplierId;
      }
    }

    if (dueDate.isNotEmpty) {
      formDataMap['due_date'] = dueDate;
    }

    for (var i = 0; i < invoices.length; i++) {
      final invoice = invoices[i];
      formDataMap['invoices[$i][supplier_id]'] = invoice.supplierId;
      formDataMap['invoices[$i][invoice_number]'] = invoice.invoiceNumber;
      formDataMap['invoices[$i][issue_date]'] = invoice.issueDate;
      formDataMap['invoices[$i][is_tax_invoice]'] = invoice.isTaxInvoice
          ? '1'
          : '0';

      if (invoice.isTaxInvoice) {
        formDataMap['invoices[$i][tax_id]'] = invoice.taxId;
        formDataMap['invoices[$i][tax_invoice_details][supplier_name]'] =
            invoice.supplierName;
        formDataMap['invoices[$i][tax_invoice_details][supplier_id]'] =
            invoice.supplierName;
        formDataMap['invoices[$i][tax_invoice_details][net_amount]'] =
            invoice.netAmount;
        formDataMap['invoices[$i][tax_invoice_details][vat_amount]'] =
            invoice.vatAmount;
        formDataMap['invoices[$i][tax_invoice_details][total_amount]'] =
            invoice.totalAmount;
      }

      for (var j = 0; j < invoice.items.length; j++) {
        final item = invoice.items[j];
        formDataMap['invoices[$i][items][$j][category_id]'] = item.categoryId;
        formDataMap['invoices[$i][items][$j][name]'] = item.name;
        formDataMap['invoices[$i][items][$j][quantity]'] = item.quantity;
        formDataMap['invoices[$i][items][$j][unit_price]'] = item.unitPrice;
      }

      for (var k = 0; k < invoice.invoiceReceipts.length; k++) {
        final file = invoice.invoiceReceipts[k];
        final fileName = file.path.split(Platform.pathSeparator).last;
        formDataMap['invoices[$i][invoice_receipts][$k]'] =
            await MultipartFile.fromFile(file.path, filename: fileName);
      }
    }

    return FormData.fromMap(formDataMap);
  }
}

class GroupedInvoiceInvoiceModel {
  final String supplierId;
  final String supplierName;
  final String invoiceNumber;
  final String issueDate;
  final bool isTaxInvoice;
  final String taxId;
  final String netAmount;
  final String vatAmount;
  final String totalAmount;
  final List<GroupedInvoiceItemRequestModel> items;
  final List<File> invoiceReceipts;

  const GroupedInvoiceInvoiceModel({
    required this.supplierId,
    required this.supplierName,
    required this.invoiceNumber,
    required this.issueDate,
    required this.isTaxInvoice,
    required this.taxId,
    required this.netAmount,
    required this.vatAmount,
    required this.totalAmount,
    required this.items,
    required this.invoiceReceipts,
  });
}

class GroupedInvoiceItemRequestModel {
  final String categoryId;
  final String name;
  final String quantity;
  final String unitPrice;

  const GroupedInvoiceItemRequestModel({
    required this.categoryId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });
}
