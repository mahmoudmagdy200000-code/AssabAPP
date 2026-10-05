part of 'create_expense_previous_request_cubit.dart';

sealed class CreateExpensePreviousRequestState extends Equatable {
  const CreateExpensePreviousRequestState();

  @override
  List<Object> get props => [];
}

final class CreateExpensePreviousRequestInitial
    extends CreateExpensePreviousRequestState {
  const CreateExpensePreviousRequestInitial();
}

final class CreateExpensePreviousRequestLoading
    extends CreateExpensePreviousRequestState {
  const CreateExpensePreviousRequestLoading();
}

final class CreateExpensePreviousRequestSuccess
    extends CreateExpensePreviousRequestState {
  const CreateExpensePreviousRequestSuccess();
}

final class CreateExpensePreviousRequestFailure
    extends CreateExpensePreviousRequestState {
  final ApiFailure failure;

  const CreateExpensePreviousRequestFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
