import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/inventory/data/models/inventory_employee_response.dart';
import 'package:equatable/equatable.dart';

sealed class GetInventoryEmployeeState extends Equatable {
  const GetInventoryEmployeeState();

  @override
  List<Object> get props => [];
}

final class GetInventoryEmployeeInit extends GetInventoryEmployeeState {
  const GetInventoryEmployeeInit();
}

final class GetInventoryEmployeeLoading extends GetInventoryEmployeeState {
  const GetInventoryEmployeeLoading();
}

final class GetInventoryEmployeeSuccess extends GetInventoryEmployeeState {
  final List<InventoryEmployee> employees;

  const GetInventoryEmployeeSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

final class GetInventoryEmployeeFailure extends GetInventoryEmployeeState {
  final ApiFailure failure;

  const GetInventoryEmployeeFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
