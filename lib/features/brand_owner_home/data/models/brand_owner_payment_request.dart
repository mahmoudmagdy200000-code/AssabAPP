import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/enums/custody_preferred_receipt_method.dart';

class BrandOwnerPaymentRequest {
  final String branchId;
  final double amount;
  final String paymentMethod;
  final String? transferDate;
  final String? purpose;
  final String? handoverDate;
  final File? receiptImage;
  final String? note;

  BrandOwnerPaymentRequest({
    required this.branchId,
    required this.amount,
    required this.paymentMethod,
    required this.transferDate,
    required this.purpose,
    required this.handoverDate,
    required this.receiptImage,
    required this.note,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('recipientEmployeeId', branchId));
    formData.fields.add(MapEntry('amount', amount.toString()));
    formData.fields.add(MapEntry('preferredReceiptMethod', paymentMethod));
    if (transferDate != null &&
        transferDate!.isNotEmpty &&
        paymentMethod == CustodyPreferredReceiptMethod.bankTransfer.value) {
      formData.fields.add(MapEntry('transferDate', transferDate!));
    }
    if (purpose != null &&
        purpose!.isNotEmpty &&
        paymentMethod == CustodyPreferredReceiptMethod.bankTransfer.value) {
      formData.fields.add(MapEntry('purpose', purpose!));
    }
    if (handoverDate != null &&
        handoverDate!.isNotEmpty &&
        paymentMethod == CustodyPreferredReceiptMethod.cashHandover.value) {
      formData.fields.add(MapEntry('handoverDate', handoverDate!));
    }
    if (note != null && note!.isNotEmpty) {
      formData.fields.add(MapEntry('note', note!));
    }
    if (receiptImage != null) {
      formData.files.add(
        MapEntry(
          'receiptImage',
          MultipartFile.fromFileSync(
            receiptImage!.path,
            filename: receiptImage!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
