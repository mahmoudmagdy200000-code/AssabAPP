enum BrandOwnerReportSettingMonthlyReportEnum {
  assetStatus('asset_status'),
  branchPerformance('branch_performance'),
  overallInvestment('overall_investment');

  final String _value;

  const BrandOwnerReportSettingMonthlyReportEnum(this._value);

  String get value => _value;

  String get label {
    switch (this) {
      case BrandOwnerReportSettingMonthlyReportEnum.assetStatus:
        return 'Asset Status';
      case BrandOwnerReportSettingMonthlyReportEnum.branchPerformance:
        return 'Branch Performance';
      case BrandOwnerReportSettingMonthlyReportEnum.overallInvestment:
        return 'Overall Investment';
    }
  }

  static BrandOwnerReportSettingMonthlyReportEnum fromValue(String value) {
    return BrandOwnerReportSettingMonthlyReportEnum.values.firstWhere(
      (item) => item.value == value,
      orElse: () => BrandOwnerReportSettingMonthlyReportEnum.assetStatus,
    );
  }
}
