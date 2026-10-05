import 'dart:io';

import 'package:dio/dio.dart';

class FixedAssetsSearchSettingRequest {
  final String assetId;
  final String newZoneId;
  final File? newImage;

  FixedAssetsSearchSettingRequest({
    required this.assetId,
    required this.newZoneId,
    required this.newImage,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('new_zone_id', newZoneId));

    if (newImage != null) {
      formData.files.add(
        MapEntry(
          'new_image',
          MultipartFile.fromFileSync(
            newImage!.path,
            filename: newImage!.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }

    return formData;
  }
}
