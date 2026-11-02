import 'package:assab/generated/l10n.dart';
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
        return S.current.followupAssetStatus;
      case BrandOwnerReportSettingMonthlyReportEnum.branchPerformance:
        return S.current.followupBranchPerformance;
      case BrandOwnerReportSettingMonthlyReportEnum.overallInvestment:
        return S.current.followupOverallInvestment;
    }
  }

  static BrandOwnerReportSettingMonthlyReportEnum fromValue(String value) {
    return BrandOwnerReportSettingMonthlyReportEnum.values.firstWhere(
      (item) => item.value == value,
      orElse: () => BrandOwnerReportSettingMonthlyReportEnum.assetStatus,
    );
  }
}
