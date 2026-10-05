import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';

part 'create_expense_previous_request_state.dart';

@injectable
class CreateExpensePreviousRequestCubit
    extends SafeCubit<CreateExpensePreviousRequestState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  CreateExpensePreviousRequestCubit(this._branchManagerExpensesRepository)
    : super(const CreateExpensePreviousRequestInitial());

  void createPreviousPreApproval({required String id}) async {
    emit(const CreateExpensePreviousRequestLoading());

    final result = await _branchManagerExpensesRepository
        .createPreviousPreApproval(id: id);

    handle(
      result,
      failure: (failure) => emit(CreateExpensePreviousRequestFailure(failure)),
      success: (_) => emit(const CreateExpensePreviousRequestSuccess()),
    );
  }

  void createPreviousSingleInvoice({required String id}) async {
    emit(const CreateExpensePreviousRequestLoading());

    final result = await _branchManagerExpensesRepository
        .createPreviousSingleInvoice(id: id);

    handle(
      result,
      failure: (failure) => emit(CreateExpensePreviousRequestFailure(failure)),
      success: (_) => emit(const CreateExpensePreviousRequestSuccess()),
    );
  }
}
