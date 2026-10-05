import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/quick_cash_entity.dart';

sealed class QuickCashState extends Equatable {
  const QuickCashState();

  @override
  List<Object> get props => [];
}

class QuickCashInitial extends QuickCashState {
  const QuickCashInitial();

  @override
  List<Object> get props => [];
}

class QuickCashLoading extends QuickCashState {
  const QuickCashLoading();

  @override
  List<Object> get props => [];
}

class QuickCashSuccess extends QuickCashState {
  final QuickCashEntity response;

  const QuickCashSuccess(this.response);

  @override
  List<Object> get props => [response];
}

class UpdateDraftQuickCashSuccess extends QuickCashState {
  const UpdateDraftQuickCashSuccess();
}

class QuickCashFailure extends QuickCashState {
  final ApiFailure failure;

  const QuickCashFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
