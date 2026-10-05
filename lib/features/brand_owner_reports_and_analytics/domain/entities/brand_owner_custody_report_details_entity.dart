class CustodyReportBranchEntity {
  final String imageUrl;
  final String name;
  final String branch;
  final double currentBalance;
  final CustodyReportAmountEntity amounts;

  const CustodyReportBranchEntity({
    required this.imageUrl,
    required this.name,
    required this.branch,
    required this.currentBalance,
    required this.amounts,
  });
}

class CustodyReportAmountEntity {
  final String monthName;
  final double monthOpeningBalance;
  final double totalCashIn;
  final double totalCashOut;
  final double currentBalance;

  const CustodyReportAmountEntity({
    required this.monthName,
    required this.monthOpeningBalance,
    required this.totalCashIn,
    required this.totalCashOut,
    required this.currentBalance,
  });
}

class BrandOwnerCustodyReportDetailsEntity {
  final String periodLabel;
  final List<CustodyReportBranchEntity> branches;

  const BrandOwnerCustodyReportDetailsEntity({
    required this.periodLabel,
    required this.branches,
  });
}
