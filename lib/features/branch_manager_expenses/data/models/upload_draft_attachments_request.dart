import 'dart:io';

import 'package:dio/dio.dart';

sealed class UploadDraftAttachmentsRequest {
  Future<FormData> toFormData();
}

final class UploadDraftAttachmentsDefaultRequest
    extends UploadDraftAttachmentsRequest {
  final List<File> attachments;

  UploadDraftAttachmentsDefaultRequest({required this.attachments});

  @override
  Future<FormData> toFormData() async {
    final formData = FormData();

    for (var file in attachments) {
      formData.files.add(
        MapEntry(
          'attachments[]',
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

final class UploadDraftGroupedInvoiceAttachmentsRequest
    extends UploadDraftAttachmentsRequest {
  final List<Map<String, List<File>>> attachments;

  UploadDraftGroupedInvoiceAttachmentsRequest({required this.attachments});

  @override
  Future<FormData> toFormData() async {
    final formData = FormData();

    for (var attachmentMap in attachments) {
      for (var entry in attachmentMap.entries) {
        final invoiceId = entry.key;
        final files = entry.value;

        for (var i = 0; i < files.length; i++) {
          final file = files[i];

          formData.files.add(
            MapEntry(
              'invoices[$invoiceId][attachments][$i]',
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }
    }

    return formData;
  }
}
