import 'package:equatable/equatable.dart';

import '../../../../../core/enums/purchasing_officer_processing_time_enum.dart';

class PurchasingOfficerSelectProcessingTimeState extends Equatable {
  final PurchasingOfficerProcessingTimeEnum selectedProcessingTime;

  const PurchasingOfficerSelectProcessingTimeState({
    this.selectedProcessingTime = PurchasingOfficerProcessingTimeEnum.non,
  });

  PurchasingOfficerSelectProcessingTimeState copyWith({
    PurchasingOfficerProcessingTimeEnum? selectedProcessingTime,
  }) {
    return PurchasingOfficerSelectProcessingTimeState(
      selectedProcessingTime:
          selectedProcessingTime ?? this.selectedProcessingTime,
    );
  }

  @override
  List<Object> get props => [selectedProcessingTime];
}
