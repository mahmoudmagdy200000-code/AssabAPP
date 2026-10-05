import 'package:equatable/equatable.dart';

class ChooseItemState extends Equatable {
  final int? selectedIndex;
  final int? selectedSubIndex;
  final int? tempSelectedIndex;

  const ChooseItemState({
    this.selectedIndex,
    this.selectedSubIndex,
    this.tempSelectedIndex,
  });

  ChooseItemState copyWith({
    int? selectedIndex,
    int? selectedSubIndex,
    int? tempSelectedIndex,
  }) {
    return ChooseItemState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedSubIndex: selectedSubIndex ?? this.selectedSubIndex,
      tempSelectedIndex: tempSelectedIndex ?? this.tempSelectedIndex,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    selectedSubIndex,
    tempSelectedIndex,
  ];
}
