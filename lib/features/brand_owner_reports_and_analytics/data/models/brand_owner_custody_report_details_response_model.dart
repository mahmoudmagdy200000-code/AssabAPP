import '../../domain/entities/brand_owner_custody_report_details_entity.dart';

class CustodyReportBranchModel {
  final String imageUrl;
  final String name;
  final String branch;
  final double currentBalance;
  final CustodyReportAmountModel amounts;

  const CustodyReportBranchModel({
    required this.imageUrl,
    required this.name,
    required this.branch,
    required this.currentBalance,
    required this.amounts,
  });

  factory CustodyReportBranchModel.fromJson(Map<String, dynamic> json) {
    return CustodyReportBranchModel(
      imageUrl: json['image_url']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      currentBalance: (json['current_balance'] as num?)?.toDouble() ?? 0.0,
      amounts: CustodyReportAmountModel.fromJson(
        json['amounts'] as Map<String, dynamic>,
      ),
    );
  }

  CustodyReportBranchEntity toEntity() {
    return CustodyReportBranchEntity(
      imageUrl: imageUrl,
      name: name,
      branch: branch,
      currentBalance: currentBalance,
      amounts: amounts.toEntity(),
    );
  }
}

class CustodyReportAmountModel {
  final String monthName;
  final double monthOpeningBalance;
  final double totalCashIn;
  final double totalCashOut;
  final double currentBalance;

  const CustodyReportAmountModel({
    required this.monthName,
    required this.monthOpeningBalance,
    required this.totalCashIn,
    required this.totalCashOut,
    required this.currentBalance,
  });

  factory CustodyReportAmountModel.fromJson(Map<String, dynamic> json) {
    return CustodyReportAmountModel(
      monthName: json['month_name']?.toString() ?? '',
      monthOpeningBalance:
          (json['month_opening_balance'] as num?)?.toDouble() ?? 0.0,
      totalCashIn: (json['total_cash_in'] as num?)?.toDouble() ?? 0.0,
      totalCashOut: (json['total_cash_out'] as num?)?.toDouble() ?? 0.0,
      currentBalance: (json['current_balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  CustodyReportAmountEntity toEntity() {
    return CustodyReportAmountEntity(
      monthName: monthName,
      monthOpeningBalance: monthOpeningBalance,
      totalCashIn: totalCashIn,
      totalCashOut: totalCashOut,
      currentBalance: currentBalance,
    );
  }
}

class BrandOwnerCustodyReportDetailsResponseModel {
  final String periodLabel;
  final List<CustodyReportBranchModel> branches;

  const BrandOwnerCustodyReportDetailsResponseModel({
    required this.periodLabel,
    required this.branches,
  });

  factory BrandOwnerCustodyReportDetailsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? {};
    final branchesJson = dataJson['branches'] as List<dynamic>? ?? [];

    return BrandOwnerCustodyReportDetailsResponseModel(
      periodLabel: dataJson['period_label']?.toString() ?? '',
      branches: branchesJson
          .map(
            (item) =>
                CustodyReportBranchModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  BrandOwnerCustodyReportDetailsEntity toEntity() {
    return BrandOwnerCustodyReportDetailsEntity(
      periodLabel: periodLabel,
      branches: branches.map((branch) => branch.toEntity()).toList(),
    );
  }
}
