import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';

class BrandOwnerFixedAssetsModificationRequestModel {
  final String id;
  final String branchName;
  final String assetName;
  final FixedAssetsRequestsStatusStrategy status;
  final DateTime? createdAt;

  const BrandOwnerFixedAssetsModificationRequestModel({
    required this.id,
    required this.branchName,
    required this.assetName,
    required this.status,
    this.createdAt,
  });

  factory BrandOwnerFixedAssetsModificationRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsModificationRequestModel(
      id: json['id'] as String,
      branchName: json['branch_name'] as String,
      assetName: json['asset_name'] as String,
      status: FixedAssetsRequestsStatusStrategy.fromStatus(
        json['status'] as String,
      ),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }
}
