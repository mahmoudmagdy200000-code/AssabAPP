import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/single_invoice_previous_response.dart';
import '../../../domain/entities/single_invoice_entity.dart';

sealed class SingleExpenseState extends Equatable {
  const SingleExpenseState();

  @override
  List<Object> get props => [];
}

final class SingleExpenseInit extends SingleExpenseState {
  const SingleExpenseInit();
}

final class SingleExpenseLoading extends SingleExpenseState {
  const SingleExpenseLoading();
}

final class GetPreviousSingleExpenseLoading extends SingleExpenseState {
  const GetPreviousSingleExpenseLoading();
}

final class SingleExpenseSuccess extends SingleExpenseState {
  final SingleInvoiceEntity response;

  const SingleExpenseSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GetPreviousSingleExpenseSuccess extends SingleExpenseState {
  final SingleInvoicePreviousResponseModel response;

  const GetPreviousSingleExpenseSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class SingleExpenseFailure extends SingleExpenseState {
  final ApiFailure failure;

  const SingleExpenseFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class GetPreviousSingleExpenseFailure extends SingleExpenseState {
  final ApiFailure failure;

  const GetPreviousSingleExpenseFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
