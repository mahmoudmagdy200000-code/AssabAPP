import 'package:assab/core/enums/filter_purchase_history_type_enum.dart';
import 'package:assab/core/enums/time_keys.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/enums/request_perspective_enum.dart';

class SelectFilterPurchaseHistoryState extends Equatable {
  final RequestPerspectiveEnum selectedPerspective;
  final FilterPurchaseHistoryTypeEnum selectedType;
  final TimeKeys selectedTime;

  const SelectFilterPurchaseHistoryState({
    this.selectedPerspective = RequestPerspectiveEnum.non,
    this.selectedType = FilterPurchaseHistoryTypeEnum.non,
    this.selectedTime = TimeKeys.non,
  });

  SelectFilterPurchaseHistoryState copyWith({
    RequestPerspectiveEnum? selectedPerspective,
    FilterPurchaseHistoryTypeEnum? selectedType,
    TimeKeys? selectedTime,
  }) {
    return SelectFilterPurchaseHistoryState(
      selectedPerspective: selectedPerspective ?? this.selectedPerspective,
      selectedType: selectedType ?? this.selectedType,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }

  @override
  List<Object> get props => [selectedPerspective, selectedType, selectedTime];
}
