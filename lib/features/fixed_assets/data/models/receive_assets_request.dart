import 'dart:io';

import 'package:dio/dio.dart';

class ReceiveAssetsRequest {
  final String requestId;
  final List<ReceiveAssetsDataRequest> items;
  final String type;

  ReceiveAssetsRequest({
    required this.requestId,
    required this.items,
    required this.type,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('type', type));

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      formData.fields.addAll([
        MapEntry('items[${item.assetId}][assetId]', item.assetId),
        MapEntry('items[${item.assetId}][assignedZoneId]', item.assignedZoneId),
        MapEntry('items[${item.assetId}][assetTypeId]', item.assetTypeId),
        MapEntry(
          'items[${item.assetId}][assetCount]',
          item.assetCount.toString(),
        ),
        MapEntry(
          'items[${item.assetId}][excellentCount]',
          item.excellentCount.toString(),
        ),
        MapEntry(
          'items[${item.assetId}][needAttentionCount]',
          item.needAttentionCount.toString(),
        ),
        MapEntry(
          'items[${item.assetId}][problemCount]',
          item.problemCount.toString(),
        ),
      ]);

      formData.files.add(
        MapEntry(
          'items[${item.assetId}][image]',
          MultipartFile.fromFileSync(
            item.image.path,
            filename: item.image.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}

class ReceiveAssetsDataRequest {
  final String assetId;
  final String assignedZoneId;
  final String assetTypeId;
  final int assetCount;
  final int excellentCount;
  final int needAttentionCount;
  final int problemCount;
  final File image;

  ReceiveAssetsDataRequest({
    required this.assetId,
    required this.assignedZoneId,
    required this.assetTypeId,
    required this.assetCount,
    required this.excellentCount,
    required this.needAttentionCount,
    required this.problemCount,
    required this.image,
  });
}
