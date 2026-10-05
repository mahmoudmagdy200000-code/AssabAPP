import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../core/enums/shift_status/shift_status_type.dart';
import '../../../../../../generated/l10n.dart';

class CashierShiftsAllShiftsStatus extends ShiftStatus {
  @override
  ShiftStatusType get type => ShiftStatusType.all;

  @override
  String get name => S.current.allShifts;
  @override
  String get icon => AppAssets.noShiftsFoundSvg;
  @override
  String get title => S.current.noShiftsAvailable;
  @override
  String get desc => S.current.noShiftsAreCurrentlyRecorded;

  @override
  void get(BuildContext context, {bool loadMore = false}) {
    // context.read<CashierShiftsManagementCubit>().getAllCashierShifts(loadMore: loadMore);
  }
}

class CashierShiftsFilterShiftsStatus extends ShiftStatus {
  @override
  ShiftStatusType get type => ShiftStatusType.all;

  @override
  String get name => S.current.allShifts;
  @override
  String get icon => AppAssets.noShiftsFoundSvg;
  @override
  String get title => S.current.noShiftsAvailable;
  @override
  String get desc => S.current.noShiftsAreCurrentlyRecorded;

  @override
  void get(BuildContext context, {bool loadMore = false}) {
    // context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(loadMore: loadMore);
  }
}

class CashierShiftsPendingStatus extends ShiftStatus {
  @override
  ShiftStatusType get type => ShiftStatusType.pending;

  @override
  String get name => S.current.pending;
  @override
  String get icon => AppAssets.noShiftsFoundSvg;
  @override
  String get title => S.current.noPendingShifts;
  @override
  String get desc => S.current.allShiftHaveBeenReviewedOrReassigned;

  @override
  void get(BuildContext context, {bool loadMore = false}) {
    context.read<CashierShiftsManagementCubit>().getPendingShifts(
      loadMore: loadMore,
    );
  }
}

class CashierShiftsInProgressStatus extends ShiftStatus {
  @override
  ShiftStatusType get type => ShiftStatusType.inProgress;

  @override
  String get name => S.current.inProgress;
  @override
  String get icon => AppAssets.noShiftsFoundSvg;
  @override
  String get title => S.current.noShiftsInProgress;
  @override
  String get desc => S.current.noShiftsAreCurrentlyInProgress;

  @override
  void get(BuildContext context, {bool loadMore = false}) {
    context.read<CashierShiftsManagementCubit>().getInProgressShifts(
      loadMore: loadMore,
    );
  }
}

class CashierShiftsCompletedStatus extends ShiftStatus {
  @override
  ShiftStatusType get type => ShiftStatusType.completed;

  @override
  String get name => S.current.completed_name;
  @override
  String get icon => AppAssets.noShiftsFoundSvg;
  @override
  String get title => S.current.noCompletedShifts;
  @override
  String get desc => S.current.thereAreNoCompletedShiftsYet;

  @override
  void get(BuildContext context, {bool loadMore = false}) {
    context.read<CashierShiftsManagementCubit>().getCompletedShifts(
      loadMore: loadMore,
    );
  }
}
