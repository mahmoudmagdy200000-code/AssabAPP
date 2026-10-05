import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/enums/fixed_assets_dispose_methods_enum.dart';
import '../../domain/enums/fixed_assets_transfers_and_disposal_enum.dart';

class FixedAssetsTransferAndDisposeRequest {
  final FixedAssetsTransfersAndDisposalEnum type;

  // Transfer specific fields
  final String? branchId;
  final bool? autoApprove;

  // Dispose specific fields
  final String? disposalDate;
  final String? disposalTime;
  final FixedAssetsDisposeMethodsEnum? disposalMethod; // Optional Every time
  final List<FixedAssetsTransferAndDisposeItem> assets; // Required every time

  FixedAssetsTransferAndDisposeRequest({
    required this.type,
    required this.branchId,
    required this.autoApprove,
    required this.disposalDate,
    required this.disposalTime,
    required this.disposalMethod,
    required this.assets,
  });

  FormData toFormData() {
    final formData = FormData();

    formData.fields.add(MapEntry('type', type.value));

    if (type == FixedAssetsTransfersAndDisposalEnum.transferToBranch) {
      if (branchId != null) {
        formData.fields.add(MapEntry('branchId', branchId!));
      }

      if (autoApprove != null) {
        formData.fields.add(MapEntry('autoApprove', autoApprove!.toString()));
      }
    } else if (type == FixedAssetsTransfersAndDisposalEnum.disposal) {
      if (disposalDate != null) {
        formData.fields.add(MapEntry('disposalDate', disposalDate!));
      }

      if (disposalTime != null) {
        formData.fields.add(MapEntry('disposalTime', disposalTime!));
      }

      if (disposalMethod != null) {
        formData.fields.add(MapEntry('disposalMethod', disposalMethod!.value));
      }
    }

    for (var i = 0; i < assets.length; i++) {
      final asset = assets[i];

      formData.fields.add(MapEntry('assets[$i][assetId]', asset.assetId));

      if (type == FixedAssetsTransfersAndDisposalEnum.transferToBranch) {
        if (asset.transferReason != null) {
          formData.fields.add(
            MapEntry('assets[$i][transferReason]', asset.transferReason!),
          );
        }

        if (asset.documentationPhotos != null) {
          formData.files.add(
            MapEntry(
              'assets[$i][documentationPhotos]',
              MultipartFile.fromFileSync(
                asset.documentationPhotos!.path,
                filename: asset.documentationPhotos!.path.split('/').last,
              ),
            ),
          );
        }
      } else if (type == FixedAssetsTransfersAndDisposalEnum.disposal) {
        if (asset.disposalReason != null) {
          formData.fields.add(
            MapEntry('assets[$i][disposalReason]', asset.disposalReason!),
          );
        }

        if (asset.conditionDescription != null) {
          formData.fields.add(
            MapEntry(
              'assets[$i][conditionDescription]',
              asset.conditionDescription!,
            ),
          );
        }

        if (asset.visualEvidence != null) {
          formData.files.add(
            MapEntry(
              'assets[$i][visualEvidence]',
              MultipartFile.fromFileSync(
                asset.visualEvidence!.path,
                filename: asset.visualEvidence!.path.split('/').last,
              ),
            ),
          );
        }
      }
    }

    return formData;
  }
}

class FixedAssetsTransferAndDisposeItem {
  final String assetId;

  // Transfer specific fields
  final String? transferReason;
  final File? documentationPhotos;

  // Dispose specific fields
  final String? disposalReason;
  final String? conditionDescription;
  final File? visualEvidence;

  FixedAssetsTransferAndDisposeItem({
    required this.assetId,
    required this.transferReason,
    required this.documentationPhotos,
    required this.disposalReason,
    required this.conditionDescription,
    required this.visualEvidence,
  });
}
