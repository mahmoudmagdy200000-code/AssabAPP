import 'package:dio/dio.dart';

class FixedAssetsActiveHandoverApproveZoneRequest {
  final String sessionId;
  final String zoneId;
  final List<FixedAssetsActiveHandoverApproveZoneAssetRequest> assets;

  const FixedAssetsActiveHandoverApproveZoneRequest({
    required this.sessionId,
    required this.zoneId,
    required this.assets,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('sessionId', sessionId),
      MapEntry('zoneId', zoneId),
    ]);

    for (final asset in assets) {
      formData.fields.addAll(asset.toFieldEntries());

      final photo = asset.recipientPhotoPath;
      if (photo != null && photo.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'items[${asset.assetId}][photo]',
            MultipartFile.fromFileSync(photo, filename: photo.split('/').last),
          ),
        );
      }
    }

    return formData;
  }
}

class FixedAssetsActiveHandoverApproveZoneAssetRequest {
  final String assetId;
  final String recipientInspection;
  final String? recipientNote;
  final String? recipientPhotoPath;
  final int? newQty;

  const FixedAssetsActiveHandoverApproveZoneAssetRequest({
    required this.assetId,
    required this.recipientInspection,
    this.recipientNote,
    this.recipientPhotoPath,
    this.newQty,
  });

  List<MapEntry<String, String>> toFieldEntries() {
    final entries = <MapEntry<String, String>>[
      MapEntry('items[$assetId][assetId]', assetId),
      MapEntry('items[$assetId][recipientInspection]', recipientInspection),
    ];

    if (recipientNote != null && recipientNote!.isNotEmpty) {
      entries.add(MapEntry('items[$assetId][recipientNote]', recipientNote!));
    }

    if (newQty != null) {
      entries.add(MapEntry('items[$assetId][newQty]', newQty!.toString()));
    }

    return entries;
  }
}
