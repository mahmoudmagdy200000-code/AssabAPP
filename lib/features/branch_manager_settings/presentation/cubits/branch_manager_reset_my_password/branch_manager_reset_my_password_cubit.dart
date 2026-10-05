import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/usecases/branch_manager_reset_my_password_usecase.dart';
import 'branch_manager_reset_my_password_state.dart';

@injectable
class BranchManagerResetMyPasswordCubit
    extends SafeCubit<BranchManagerResetMyPasswordState> {
  final BranchManagerResetMyPasswordUseCase _resetMyPasswordUseCase;

  BranchManagerResetMyPasswordCubit(this._resetMyPasswordUseCase)
    : super(const BranchManagerResetMyPasswordInitial());

  Future<void> resetMyPassword({
    required String oldPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const BranchManagerResetMyPasswordLoading());

    final result = await _resetMyPasswordUseCase(
      oldPassword: oldPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    handle(
      result,
      success: (_) => emit(const BranchManagerResetMyPasswordSuccess()),
      failure: (failure) => emit(BranchManagerResetMyPasswordFailure(failure)),
    );
  }
}