import 'dart:io';

import 'package:dio/dio.dart';

class ReceiveOrderSupplierRequest {
  final List<ReceivedItem> items;
  final String documentType;
  final InvoiceData? invoiceData;
  final VarianceData? variance;

  ReceiveOrderSupplierRequest({
    required this.items,
    required this.documentType,
    this.invoiceData,
    this.variance,
  });
}

class ReceivedItem {
  final String itemId;
  final double quantityReceived;
  final String quality;
  final double temperature;
  final String expirationDate;
  final File? file;
  final String? notes;

  ReceivedItem({
    required this.itemId,
    required this.quantityReceived,
    required this.quality,
    required this.temperature,
    required this.expirationDate,
    this.file,
    this.notes,
  });
}

class InvoiceData {
  final String invoiceNumber;
  final String invoiceDate;
  final String dueDate;
  final String paymentTerms;
  final File file;
  final String? notes;
  final double? taxRate;
  final double? amountBeforeTax;
  final double? taxAmount;
  final double? totalAmount;

  InvoiceData({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.paymentTerms,
    required this.file,
    this.notes,
    this.taxRate,
    this.amountBeforeTax,
    this.taxAmount,
    this.totalAmount,
  });
}

class VarianceData {
  final String action;
  final String? note;
  final File? file;
  final List<VarianceItem> items;

  VarianceData({
    required this.action,
    this.note,
    this.file,
    required this.items,
  });
}

class VarianceItem {
  final String itemId;
  final int quantity;

  VarianceItem({required this.itemId, required this.quantity});
}

extension ReceiveOrderSupplierRequestForm on ReceiveOrderSupplierRequest {
  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('document_type', documentType));

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      formData.fields.addAll([
        MapEntry('items[$i][item_id]', item.itemId),
        MapEntry('items[$i][quantity]', item.quantityReceived.toString()),
        MapEntry(
          'items[$i][quantity_received]',
          item.quantityReceived.toString(),
        ),
        MapEntry('items[$i][quality]', item.quality),
        MapEntry('items[$i][temperature]', item.temperature.toString()),
        MapEntry('items[$i][expiration_date]', item.expirationDate),
      ]);

      if (item.notes != null) {
        formData.fields.add(MapEntry('items[$i][notes]', item.notes!));
      }

      if (item.file != null) {
        formData.files.add(
          MapEntry(
            'items[$i][photo]',
            MultipartFile.fromFileSync(
              item.file!.path,
              filename: item.file!.path.split('/').last,
            ),
          ),
        );
      }
    }

    if (invoiceData != null) {
      formData.fields.addAll([
        MapEntry('invoice_data[invoice_number]', invoiceData!.invoiceNumber),
        MapEntry('invoice_data[invoice_date]', invoiceData!.invoiceDate),
        MapEntry('invoice_data[due_date]', invoiceData!.dueDate),
        MapEntry('invoice_data[payment_terms]', invoiceData!.paymentTerms),
      ]);

      if (invoiceData!.taxRate != null) {
        final rateValue =
            invoiceData!.taxRate! <= 1.0 && invoiceData!.taxRate! > 0.0
                ? (invoiceData!.taxRate! * 100).round()
                : invoiceData!.taxRate!.round();
        formData.fields.addAll([
          MapEntry('invoice_data[tax_rate]', rateValue.toString()),
          MapEntry('invoice_data[vat_rate]', rateValue.toString()),
        ]);
      }

      if (invoiceData!.amountBeforeTax != null) {
        formData.fields.add(
          MapEntry(
            'invoice_data[amount_before_tax]',
            invoiceData!.amountBeforeTax!.toStringAsFixed(2),
          ),
        );
      }

      if (invoiceData!.taxAmount != null) {
        formData.fields.addAll([
          MapEntry(
            'invoice_data[tax_amount]',
            invoiceData!.taxAmount!.toStringAsFixed(2),
          ),
          MapEntry(
            'invoice_data[vat_amount]',
            invoiceData!.taxAmount!.toStringAsFixed(2),
          ),
        ]);
      }

      if (invoiceData!.totalAmount != null) {
        formData.fields.add(
          MapEntry(
            'invoice_data[total_amount]',
            invoiceData!.totalAmount!.toStringAsFixed(2),
          ),
        );
      }

      if (invoiceData!.notes != null) {
        formData.fields.add(
          MapEntry('invoice_data[notes]', invoiceData!.notes!),
        );
      }

      formData.files.add(
        MapEntry(
          'invoice_data[photo]',
          MultipartFile.fromFileSync(
            invoiceData!.file.path,
            filename: invoiceData!.file.path.split('/').last,
          ),
        ),
      );
    }

    if (variance != null) {
      formData.fields.add(MapEntry('variance[action]', variance!.action));

      if (variance!.note != null) {
        formData.fields.add(MapEntry('variance[note]', variance!.note!));
      }

      if (variance!.file != null) {
        formData.files.add(
          MapEntry(
            'variance[photo]',
            MultipartFile.fromFileSync(
              variance!.file!.path,
              filename: variance!.file!.path.split('/').last,
            ),
          ),
        );
      }

      for (int i = 0; i < variance!.items.length; i++) {
        formData.fields.add(
          MapEntry('variance[items][$i][item_id]', variance!.items[i].itemId),
        );
        formData.fields.add(
          MapEntry(
            'variance[items][$i][quantity]',
            variance!.items[i].quantity.toString(),
          ),
        );
      }
    }

    return formData;
  }
}
