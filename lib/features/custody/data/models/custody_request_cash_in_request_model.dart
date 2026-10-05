import 'dart:io';
import 'package:dio/dio.dart';

class CustodyRequestCashInRequestModel {
  final double requestedAmount;
  final String purpose;
  final String preferredReceiptMethod;
  final String? additionalNotes;
  final List<File>? attachments;

  CustodyRequestCashInRequestModel({
    required this.requestedAmount,
    required this.purpose,
    required this.preferredReceiptMethod,
    this.additionalNotes,
    this.attachments,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'requestedAmount': requestedAmount.toStringAsFixed(2),
      'purpose': purpose,
      'preferredReceiptMethod': preferredReceiptMethod,
      if (additionalNotes != null) 'additionalNotes': additionalNotes,
      if (attachments != null && attachments!.isNotEmpty)
        'attachments[]': attachments!
            .map(
              (file) => MultipartFile.fromFileSync(
                file.path,
                filename: file.path.split('/').last,
              ),
            )
            .toList(),
    });
  }
}
