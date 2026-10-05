import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/profit_and_loss_statement_entity.dart';

sealed class ProfitAndLossStatementState extends Equatable {
  const ProfitAndLossStatementState();

  @override
  List<Object> get props => [];
}

final class ProfitAndLossStatementInitial extends ProfitAndLossStatementState {
  const ProfitAndLossStatementInitial();
}

final class ProfitAndLossStatementLoading extends ProfitAndLossStatementState {
  const ProfitAndLossStatementLoading();
}

final class ProfitAndLossStatementSuccess extends ProfitAndLossStatementState {
  final ProfitAndLossStatementEntity data;

  const ProfitAndLossStatementSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

final class ProfitAndLossStatementFailure extends ProfitAndLossStatementState {
  final ApiFailure failure;

  const ProfitAndLossStatementFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
