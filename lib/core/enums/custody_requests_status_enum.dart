import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

enum CustodyRequestsStatusEnum {
  non('Non'),
  all('All'),
  pending('Pending'),
  approved('Approved'),
  rejected('Rejected');

  final String _value;

  const CustodyRequestsStatusEnum(this._value);

  String get value => _value;

  static CustodyRequestsStatusEnum fromValue(String value) {
    return CustodyRequestsStatusEnum.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => CustodyRequestsStatusEnum.pending,
    );
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case CustodyRequestsStatusEnum.non:
        return context.tr.all;
      case CustodyRequestsStatusEnum.all:
        return context.tr.all;
      case CustodyRequestsStatusEnum.pending:
        return context.tr.pending;
      case CustodyRequestsStatusEnum.approved:
        return context.tr.approved;
      case CustodyRequestsStatusEnum.rejected:
        return context.tr.rejected;
    }
  }

  Color getLabelColor(BuildContext context) {
    switch (this) {
      case CustodyRequestsStatusEnum.non:
        return AppColors.orange;
      case CustodyRequestsStatusEnum.all:
        return AppColors.orange;
      case CustodyRequestsStatusEnum.pending:
        return AppColors.orange;
      case CustodyRequestsStatusEnum.approved:
        return AppColors.lightGreen;
      case CustodyRequestsStatusEnum.rejected:
        return context.customColor.error;
    }
  }
}
