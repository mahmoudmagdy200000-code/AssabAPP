import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/profit_vs_cash_reconciliation_entity.dart';

sealed class ProfitVsCashReconciliationState extends Equatable {
  const ProfitVsCashReconciliationState();

  @override
  List<Object> get props => [];
}

final class ProfitVsCashReconciliationInitial
    extends ProfitVsCashReconciliationState {
  const ProfitVsCashReconciliationInitial();
}

final class ProfitVsCashReconciliationLoading
    extends ProfitVsCashReconciliationState {
  const ProfitVsCashReconciliationLoading();
}

final class ProfitVsCashReconciliationSuccess
    extends ProfitVsCashReconciliationState {
  final ProfitVsCashReconciliationEntity data;

  const ProfitVsCashReconciliationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class ProfitVsCashReconciliationFailure
    extends ProfitVsCashReconciliationState {
  final ApiFailure failure;

  const ProfitVsCashReconciliationFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
