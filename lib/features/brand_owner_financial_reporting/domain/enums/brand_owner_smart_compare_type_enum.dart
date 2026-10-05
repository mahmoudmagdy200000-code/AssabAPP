import 'package:flutter/cupertino.dart';

import '../../../../generated/l10n.dart';

enum BrandOwnerSmartCompareTypeEnum {
  month('month'),
  branch('branch');

  final String _value;

  const BrandOwnerSmartCompareTypeEnum(this._value);

  String get value => _value;

  static BrandOwnerSmartCompareTypeEnum fromValue(String value) {
    return BrandOwnerSmartCompareTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid value: $value'),
    );
  }

  String label(BuildContext context) {
    return switch (this) {
      BrandOwnerSmartCompareTypeEnum.month => S.of(context).monthlyComparison,
      BrandOwnerSmartCompareTypeEnum.branch => S.of(context).branchComparison,
    };
  }

  String reportType(BuildContext context) {
    return switch (this) {
      BrandOwnerSmartCompareTypeEnum.month =>
        S.of(context).smartMonthlyComparisons,
      BrandOwnerSmartCompareTypeEnum.branch =>
        S.of(context).smartBranchComparisons,
    };
  }
}
