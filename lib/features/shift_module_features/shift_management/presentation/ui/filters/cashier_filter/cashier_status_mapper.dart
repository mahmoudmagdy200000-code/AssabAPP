import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';
import 'package:assab/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/styles/app_colors.dart';

extension CashierStatusUIMapper on CashierStatus {
  String get label {
    switch (this) {
      case CashierStatus.active:
        return S.current.active;
      case CashierStatus.pending:
        return S.current.pending;
      case CashierStatus.deactivated:
        return S.current.deactivated;
    }
  }

  Color get cardColor {
    switch (this) {
      case CashierStatus.active:
        return Colors.white;
      case CashierStatus.pending:
      case CashierStatus.deactivated:
        return AppColors.lightGray;
    }
  }

  Color get textColor {
    switch (this) {
      case CashierStatus.active:
        return AppColors.green;
      case CashierStatus.pending:
        return AppColors.sBlack;
      case CashierStatus.deactivated:
        return Colors.red;
    }
  }
}
