import 'package:equatable/equatable.dart';

import '../../../../../core/enums/select_filter_item_type.dart';

class SelectFilterItemState extends Equatable {
  final SelectFilterItemType? selectedFilterType;
  final String? selectedId;
  final String? selectedName;

  const SelectFilterItemState({
    this.selectedFilterType,
    this.selectedId,
    this.selectedName,
  });

  SelectFilterItemState copyWith({
    SelectFilterItemType? selectedFilterType,
    String? selectedId,
    String? selectedName,
  }) {
    return SelectFilterItemState(
      selectedFilterType: selectedFilterType ?? this.selectedFilterType,
      selectedId: selectedId ?? this.selectedId,
      selectedName: selectedName ?? this.selectedName,
    );
  }

  @override
  List<Object?> get props => [selectedFilterType, selectedId, selectedName];
}
