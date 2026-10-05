part of 'accept_reassigned_shift_cubit.dart';

class AcceptReassignedShiftState {
  final String? loadingShiftId;
  final ApiFailure? failure;
  final bool success;
  final String? errorShiftId;

  const AcceptReassignedShiftState({
    this.loadingShiftId,
    this.errorShiftId,
    this.failure,
    this.success = false,
  });

  AcceptReassignedShiftState copyWith({
    String? loadingShiftId,
    ApiFailure? failure,
    bool? success,
    String? errorShiftId,
  }) {
    return AcceptReassignedShiftState(
      loadingShiftId: loadingShiftId,
      failure: failure,
      success: success ?? this.success,
      errorShiftId: errorShiftId,
    );
  }
}
