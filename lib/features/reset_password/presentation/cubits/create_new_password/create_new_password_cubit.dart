import 'package:assab/features/reset_password/data/repository/reset_password_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/reset_password_model.dart';
import 'create_new_password_state.dart';

@injectable
class CreateNewPasswordCubit extends SafeCubit<CreateNewPasswordState> {
  final ResetPasswordRepository _resetPasswordRepository;

  CreateNewPasswordCubit(this._resetPasswordRepository)
    : super(const CreateNewPasswordInit());

  Future<void> branchManagerResetPassword({
    required ResetPasswordModel request,
  }) async {
    emit(const CreateNewPasswordLoading());

    final result = await _resetPasswordRepository.branchManagerResetPassword(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(CreateNewPasswordFailure(failure)),
      success: (_) => emit(const CreateNewPasswordSuccess()),
    );
  }

  Future<void> supplierResetPassword({
    required ResetPasswordModel request,
  }) async {
    emit(const CreateNewPasswordLoading());

    final result = await _resetPasswordRepository.supplierResetPassword(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(CreateNewPasswordFailure(failure)),
      success: (_) => emit(const CreateNewPasswordSuccess()),
    );
  }

  Future<void> cashierResetPassword({
    required ResetPasswordModel request,
  }) async {
    emit(const CreateNewPasswordLoading());

    final result = await _resetPasswordRepository.cashierResetPassword(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(CreateNewPasswordFailure(failure)),
      success: (_) => emit(const CreateNewPasswordSuccess()),
    );
  }

  Future<void> brandOwnerResetPassword({
    required ResetPasswordModel request,
  }) async {
    emit(const CreateNewPasswordLoading());

    final result = await _resetPasswordRepository.brandOwnerResetPassword(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(CreateNewPasswordFailure(failure)),
      success: (_) => emit(const CreateNewPasswordSuccess()),
    );
  }
}
