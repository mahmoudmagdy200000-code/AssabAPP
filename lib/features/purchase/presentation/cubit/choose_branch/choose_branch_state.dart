import 'package:equatable/equatable.dart';

class ChooseBranchState extends Equatable {
  final String? selectedBranchId;

  const ChooseBranchState({this.selectedBranchId});

  @override
  List<Object?> get props => [selectedBranchId];
}
