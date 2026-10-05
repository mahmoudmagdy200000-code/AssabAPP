part of 'get_branches_cubit.dart';

@immutable
sealed class GetBranchesState {}

final class GetBranchesInitial extends GetBranchesState {}

class GetBranchesLoading extends GetBranchesState {}

class GetBranchesSuccess extends GetBranchesState {
  final List<BranchEntity> branches;

  GetBranchesSuccess(this.branches);
}

class GetBranchesEmpty extends GetBranchesState {}

class GetBranchesFailure extends GetBranchesState {
  final ApiFailure failure;

  GetBranchesFailure(this.failure);
}
