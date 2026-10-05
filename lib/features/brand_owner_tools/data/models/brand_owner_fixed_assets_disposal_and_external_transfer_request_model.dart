import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';

class BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel {
  final String id;
  final String branchName;
  final String assetName;
  final FixedAssetsRequestsStatusStrategy status;
  final DateTime? createdAt;

  const BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel({
    required this.id,
    required this.branchName,
    required this.assetName,
    required this.status,
    this.createdAt,
  });

  factory BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsDisposalAndExternalTransferRequestModel(
      id: json['id'],
      branchName: json['branch_name'],
      assetName: json['asset_name'],
      status: FixedAssetsRequestsStatusStrategy.fromStatus(json['status']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
