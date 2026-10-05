part of 'grouped_invoice_cubit.dart';

sealed class GroupedInvoiceState extends Equatable {
  const GroupedInvoiceState();

  @override
  List<Object> get props => [];
}

final class GroupedInvoiceInitial extends GroupedInvoiceState {
  const GroupedInvoiceInitial();
}

final class GroupedInvoiceLoading extends GroupedInvoiceState {
  const GroupedInvoiceLoading();
}

final class GroupedInvoiceSuccess extends GroupedInvoiceState {
  final GroupedInvoiceEntity response;

  const GroupedInvoiceSuccess(this.response);

  @override
  List<Object> get props => [response];
}

final class GroupedInvoiceFailure extends GroupedInvoiceState {
  final ApiFailure failure;

  const GroupedInvoiceFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
