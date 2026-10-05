part of 'end_shift_option_cubit.dart';

class EndShiftOptionState extends Equatable {
  final EndShiftOption? selectedOption;

  const EndShiftOptionState({this.selectedOption});

  factory EndShiftOptionState.initial() => const EndShiftOptionState();

  EndShiftOptionState copyWith({EndShiftOption? selectedOption}) {
    return EndShiftOptionState(
      selectedOption: selectedOption ?? this.selectedOption,
    );
  }

  @override
  List<Object?> get props => [selectedOption];
}
