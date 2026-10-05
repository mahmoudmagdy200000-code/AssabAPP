part of 'cashier_shifts_management_cubit.dart';

class CashierShiftsManagementState {
  final CashierShiftTabState pending;
  final CashierShiftTabState inProgress;
  final CashierShiftTabState completed;
  final CashierShiftTabState reassigned;
  final CashierShiftTabState filter;

  const CashierShiftsManagementState({
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.reassigned,
    required this.filter,
  });

  factory CashierShiftsManagementState.initial() {
    return const CashierShiftsManagementState(
      pending: CashierShiftTabState(),
      inProgress: CashierShiftTabState(),
      completed: CashierShiftTabState(),
      reassigned: CashierShiftTabState(),
      filter: CashierShiftTabState(),
    );
  }

  CashierShiftsManagementState copyWith({
    CashierShiftTabState? pending,
    CashierShiftTabState? inProgress,
    CashierShiftTabState? completed,
    CashierShiftTabState? reassigned,
    CashierShiftTabState? filter,
  }) {
    return CashierShiftsManagementState(
      pending: pending ?? this.pending,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      reassigned: reassigned ?? this.reassigned,
      filter: filter ?? this.filter,
    );
  }
}

//
// @immutable
// abstract class CashierShiftsManagementState {
//   final ShiftStatus? status;
//   const CashierShiftsManagementState({this.status});
// }
//
// class ShiftManagementBranchInitial extends CashierShiftsManagementState {}
//
// class ShiftManagementBranchLoading extends CashierShiftsManagementState {
//   const ShiftManagementBranchLoading() : super();
// }
//
//
// class FetchShiftsAgain extends CashierShiftsManagementState {
//
//   const FetchShiftsAgain({required ShiftStatus status,}) : super(status: status);
// }
//
// class TabChangedState extends CashierShiftsManagementState {
//   final int index;
//
//   const TabChangedState(this.index);
// }
//
// class ShiftButtonLoading extends CashierShiftsManagementState {
//
//   final String loadingShiftId;
//
//   const ShiftButtonLoading(this.loadingShiftId);
// }
// class ShiftButtonFailure extends CashierShiftsManagementState {
//  final ApiFailure failure;
//   const ShiftButtonFailure(this.failure);
// }
//
//
// class ShiftManagementBranchLoaded extends CashierShiftsManagementState {
//   final List<ShiftEntity> shifts;
//   const ShiftManagementBranchLoaded({
//     required this.shifts,
//     required ShiftStatus status,
//   }) : super(status: status);
// }
//
// class ShiftManagementBranchEmpty extends CashierShiftsManagementState {
//   final ShiftEntity? nextShift;
//   const ShiftManagementBranchEmpty(ShiftStatus status,{this.nextShift}) : super(status: status);
// }
//
// class ShiftManagementBranchFailure extends CashierShiftsManagementState {
//   final ApiFailure failure;
//   const ShiftManagementBranchFailure(this.failure, ShiftStatus status)
//       : super(status: status);
// }
