import 'package:equatable/equatable.dart';

import '../../../../../core/enums/select_branch_manager_delivery_time_enum.dart';

class SelectBranchManagerDeliveryTimeState extends Equatable {
  final SelectBranchManagerDeliveryTimeEnum selectedDeliveryTime;

  const SelectBranchManagerDeliveryTimeState({
    this.selectedDeliveryTime = SelectBranchManagerDeliveryTimeEnum.non,
  });

  SelectBranchManagerDeliveryTimeState copyWith({
    SelectBranchManagerDeliveryTimeEnum? selectedDeliveryTime,
  }) {
    return SelectBranchManagerDeliveryTimeState(
      selectedDeliveryTime: selectedDeliveryTime ?? this.selectedDeliveryTime,
    );
  }

  @override
  List<Object> get props => [selectedDeliveryTime];
}
