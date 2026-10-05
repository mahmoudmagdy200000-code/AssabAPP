import 'package:equatable/equatable.dart';

import '../../../domain/entity/cashier_entity.dart';

class ChooseEmployeeState extends Equatable {
  final Map<CashierEntity, bool> selectedEmployees;

  const ChooseEmployeeState({this.selectedEmployees = const {}});

  ChooseEmployeeState copyWith({Map<CashierEntity, bool>? selectedEmployees}) {
    return ChooseEmployeeState(
      selectedEmployees: selectedEmployees ?? this.selectedEmployees,
    );
  }

  @override
  List<Object> get props => [selectedEmployees];
}
