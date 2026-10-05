import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/generated/l10n.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CashierStatusFilter extends Equatable {
  const CashierStatusFilter();

  String get label;
  String get apiValue;
  Color get cardColor;
  Color get textColor;

  @override
  List<Object?> get props => [apiValue];
}

class ActiveCashierStatus extends CashierStatusFilter {
  const ActiveCashierStatus();

  @override
  String get label => S.current.active;

  @override
  String get apiValue => 'active';

  @override
  Color get cardColor => Colors.white;

  @override
  Color get textColor => AppColors.green;
}

class PendingCashierStatus extends CashierStatusFilter {
  const PendingCashierStatus();

  @override
  String get label => S.current.pending;

  @override
  String get apiValue => 'pending';

  @override
  Color get cardColor => AppColors.lightGray;

  @override
  Color get textColor => AppColors.sBlack;
}

class DeactivatedCashierStatus extends CashierStatusFilter {
  const DeactivatedCashierStatus();

  @override
  String get label => S.current.deactivated;

  @override
  String get apiValue => 'deactivated';

  @override
  Color get cardColor => AppColors.lightGray;

  @override
  Color get textColor => Colors.red;
}
