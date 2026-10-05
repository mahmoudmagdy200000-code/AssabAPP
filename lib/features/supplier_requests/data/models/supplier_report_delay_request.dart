import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/enums/supplier_new_expected_delivery_date_type.dart';

class SupplierReportDelayRequest {
  final String message;
  final NewExpectedDeliveryDateType newExpectedDeliveryDateType;
  final String newTime;
  final String? newDate;
  final File? photo;

  const SupplierReportDelayRequest({
    required this.message,
    required this.newExpectedDeliveryDateType,
    required this.newTime,
    this.newDate,
    this.photo,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('message', message),
      MapEntry(
        'new_expected_delivery_date_type',
        newExpectedDeliveryDateType.value,
      ),
      MapEntry('new_time', newTime),
    ]);

    if (newExpectedDeliveryDateType == NewExpectedDeliveryDateType.custom &&
        newDate != null &&
        newDate!.isNotEmpty) {
      formData.fields.add(MapEntry('new_date', newDate!));
    }

    if (photo != null) {
      formData.files.add(
        MapEntry(
          'photo',
          MultipartFile.fromFileSync(
            photo!.path,
            filename: photo!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
