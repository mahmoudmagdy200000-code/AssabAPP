import 'package:equatable/equatable.dart';

import '../../../../../core/strategies/user_type_strategy.dart';

class ChooseUserTypeState extends Equatable {
  final UserType? selectedUserType;

  const ChooseUserTypeState({this.selectedUserType});

  ChooseUserTypeState copyWith({UserType? selectedUserType}) {
    return ChooseUserTypeState(
      selectedUserType: selectedUserType ?? this.selectedUserType,
    );
  }

  @override
  List<Object?> get props => [selectedUserType];
}
