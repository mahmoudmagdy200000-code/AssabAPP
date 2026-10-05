import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';

class BrandOwnerFixedAssetsTransferRequestModel {
  final String id;
  final String fromBranchName;
  final String toBranchName;
  final String assetName;
  final FixedAssetsRequestsStatusStrategy status;
  final DateTime? createdAt;

  const BrandOwnerFixedAssetsTransferRequestModel({
    required this.id,
    required this.fromBranchName,
    required this.toBranchName,
    required this.assetName,
    required this.status,
    this.createdAt,
  });

  factory BrandOwnerFixedAssetsTransferRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsTransferRequestModel(
      id: json['id'],
      fromBranchName: json['from_branch_name'],
      toBranchName: json['to_branch_name'],
      assetName: json['asset_name'],
      status: FixedAssetsRequestsStatusStrategy.fromStatus(json['status']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
