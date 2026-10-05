import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/reassigned_shift_item_model.dart';

sealed class GetReassignedShiftsState extends Equatable {
  const GetReassignedShiftsState();

  @override
  List<Object> get props => [];
}

final class GetReassignedShiftsInit extends GetReassignedShiftsState {
  const GetReassignedShiftsInit();
}

final class GetReassignedShiftsLoading extends GetReassignedShiftsState {
  const GetReassignedShiftsLoading();
}

final class GetReassignedShiftsSuccess extends GetReassignedShiftsState {
  final List<ReassignedShiftItemModel> shifts;

  const GetReassignedShiftsSuccess(this.shifts);

  @override
  List<Object> get props => [shifts];
}

final class GetReassignedShiftsFailure extends GetReassignedShiftsState {
  final ApiFailure failure;

  const GetReassignedShiftsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
