import 'package:assab/features/cashier_my_shifts/presentation/cubits/shift_tab_state.dart';
import 'package:flutter/material.dart';

@immutable
class CashierMyShiftsState {
  final ShiftTabState pending;
  final ShiftTabState completed;
  final ShiftTabState reassigned;
  final ShiftTabState inProgress;

  const CashierMyShiftsState({
    required this.pending,
    required this.completed,
    required this.reassigned,
    required this.inProgress,
  });

  factory CashierMyShiftsState.initial() {
    return const CashierMyShiftsState(
      pending: ShiftTabState(),
      completed: ShiftTabState(),
      reassigned: ShiftTabState(),
      inProgress: ShiftTabState(),
    );
  }

  CashierMyShiftsState copyWith({
    ShiftTabState? pending,
    ShiftTabState? completed,
    ShiftTabState? reassigned,
    ShiftTabState? inProgress,
  }) {
    return CashierMyShiftsState(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      reassigned: reassigned ?? this.reassigned,
      inProgress: inProgress ?? this.inProgress,
    );
  }
}
