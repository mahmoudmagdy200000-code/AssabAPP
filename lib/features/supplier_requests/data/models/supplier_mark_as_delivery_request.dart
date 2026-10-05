import 'dart:io';

import 'package:dio/dio.dart';

class SupplierMarkAsDeliveryRequest {
  final String driverName;
  final String deliveryAddress;
  final String vehicleNumber;
  final String expectedDeliveryAt;
  final File? driverPhoto;
  final String? notes;

  const SupplierMarkAsDeliveryRequest({
    required this.driverName,
    required this.deliveryAddress,
    required this.vehicleNumber,
    required this.expectedDeliveryAt,
    this.driverPhoto,
    this.notes,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('driver_name', driverName),
      MapEntry('vehicle_number', vehicleNumber),
      MapEntry('expected_delivery_at', expectedDeliveryAt),
      MapEntry('delivery_address', deliveryAddress),
    ]);

    if (notes != null && notes!.isNotEmpty) {
      formData.fields.add(MapEntry('notes', notes!));
    }

    if (driverPhoto != null) {
      formData.files.add(
        MapEntry(
          'driver_photo',
          MultipartFile.fromFileSync(
            driverPhoto!.path,
            filename: driverPhoto!.path.split('/').last,
          ),
        ),
      );
    }

    return formData;
  }
}
