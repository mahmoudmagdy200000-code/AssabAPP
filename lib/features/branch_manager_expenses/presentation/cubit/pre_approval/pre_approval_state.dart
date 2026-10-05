import 'package:assab/features/branch_manager_expenses/domain/entities/pre_approval_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/api_failure.dart';
import '../../../data/models/pre_approval_previous_response.dart';

sealed class PreApprovalState extends Equatable {
  const PreApprovalState();

  @override
  List<Object> get props => [];
}

final class PreApprovalInitial extends PreApprovalState {
  const PreApprovalInitial();
}

final class PreApprovalLoading extends PreApprovalState {
  const PreApprovalLoading();
}

final class GetPreviousPreApprovalLoading extends PreApprovalState {
  const GetPreviousPreApprovalLoading();
}

final class PreApprovalSuccess extends PreApprovalState {
  final PreApprovalEntity response;

  const PreApprovalSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetPreviousPreApprovalSuccess extends PreApprovalState {
  final PreApprovalPreviousResponse response;

  const GetPreviousPreApprovalSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class PreApprovalFailure extends PreApprovalState {
  final ApiFailure failure;

  const PreApprovalFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class GetPreviousPreApprovalFailure extends PreApprovalState {
  final ApiFailure failure;

  const GetPreviousPreApprovalFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
