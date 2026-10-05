import 'dart:io';
import 'package:dio/dio.dart';

class CreateReturnRequest {
  final String purchaseOrderId;
  final String requiredAction;
  final String? additionalNotes;
  final List<ReturnItem> items;

  CreateReturnRequest({
    required this.purchaseOrderId,
    required this.requiredAction,
    this.additionalNotes,
    required this.items,
  });
}

class ReturnItem {
  final String purchaseOrderItemId;
  final double returnQuantity;
  final String qualityReason;
  final List<File> files;

  ReturnItem({
    required this.purchaseOrderItemId,
    required this.returnQuantity,
    required this.qualityReason,
    required this.files,
  });
}

extension CreateReturnRequestForm on CreateReturnRequest {
  FormData toFormData() {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('purchase_order_id', purchaseOrderId),
      MapEntry('required_action', requiredAction),
    ]);

    if (additionalNotes != null) {
      formData.fields.add(MapEntry('additional_notes', additionalNotes!));
    }

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      formData.fields.addAll([
        MapEntry('items[$i][purchase_order_item_id]', item.purchaseOrderItemId),
        MapEntry('items[$i][return_quantity]', item.returnQuantity.toString()),
        MapEntry('items[$i][quality_reason]', item.qualityReason),
      ]);

      for (final file in item.files) {
        formData.files.add(
          MapEntry(
            'items[$i][files][]',
            MultipartFile.fromFileSync(
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
