import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/cashier_tasks_response.dart';

sealed class GetTasksState extends Equatable {
  const GetTasksState();

  @override
  List<Object> get props => [];
}

final class GetTasksInit extends GetTasksState {
  const GetTasksInit();
}

final class GetTasksLoading extends GetTasksState {
  const GetTasksLoading();
}

final class GetTasksSuccess extends GetTasksState {
  final CashierTasksResponse response;

  const GetTasksSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetTasksFailure extends GetTasksState {
  final ApiFailure failure;

  const GetTasksFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
