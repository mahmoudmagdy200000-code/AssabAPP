import 'package:assab/features/fixed_assets/domain/strategies/fixed_assets_requests_status_strategy.dart';

import '../../domain/stragegies/brand_owner_fixed_assets_handover_reports_status_strategy.dart';

class BrandOwnerFixedAssetsHandoverReportRequestModel {
  final String id;
  final String branchName;
  final String assetName;
  final BrandOwnerFixedAssetsHandoverReportsStatusStrategy status;
  final DateTime? createdAt;

  const BrandOwnerFixedAssetsHandoverReportRequestModel({
    required this.id,
    required this.branchName,
    required this.assetName,
    required this.status,
    this.createdAt,
  });

  factory BrandOwnerFixedAssetsHandoverReportRequestModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BrandOwnerFixedAssetsHandoverReportRequestModel(
      id: json['id'],
      branchName: json['branch_name'],
      assetName: json['asset_name'],
      status: BrandOwnerFixedAssetsHandoverReportsStatusStrategy.fromStatus(
        json['status'],
      ),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
