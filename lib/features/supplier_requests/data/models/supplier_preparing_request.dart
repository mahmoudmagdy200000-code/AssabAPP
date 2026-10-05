import 'dart:io';

import 'package:dio/dio.dart';

class SupplierPreparingRequest {
  final String orderId;
  final List<SupplierPreparingItem> items;

  const SupplierPreparingRequest({required this.orderId, required this.items});

  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('order_id', orderId));

    for (var i = 0; i < items.length; i++) {
      final item = items[i];

      formData.fields.add(MapEntry('items[$i][id]', item.id));

      formData.files.add(
        MapEntry(
          'items[$i][file]',
          MultipartFile.fromFileSync(
            item.file.path,
            filename: item.file.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}

class SupplierPreparingItem {
  final String id;
  final File file;

  const SupplierPreparingItem({required this.id, required this.file});
}
