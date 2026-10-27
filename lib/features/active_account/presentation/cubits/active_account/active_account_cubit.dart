import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/usecases/first_login_usecase.dart';
import '../../../domain/usecases/reset_password_first_login_usecase.dart';
import 'active_account_state.dart';

@injectable
class ActiveAccountCubit extends SafeCubit<ActiveAccountState> {
  final FirstLoginUseCase _firstLoginUseCase;
  final ResetPasswordFirstLoginUseCase _resetPasswordFirstLoginUseCase;

  ActiveAccountCubit(
    this._firstLoginUseCase,
    this._resetPasswordFirstLoginUseCase,
  ) : super(const ActiveAccountInit());

  Future<void> firstLogin({
    required String email,
    required String password,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _firstLoginUseCase(email: email, password: password);

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (firstLoginResponseModel) =>
          emit(ActiveAccountSuccess(firstLoginResponseModel)),
    );
  }

  Future<void> resetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _resetPasswordFirstLoginUseCase(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (success) => emit(const ResetPasswordActiveAccountSuccess()),
    );
  }

  Future<void> supplierFirstLogin({
    required String email,
    required String password,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _firstLoginUseCase.supplier(
      email: email,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (firstLoginResponseModel) =>
          emit(ActiveAccountSuccess(firstLoginResponseModel)),
    );
  }

  Future<void> supplierResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _resetPasswordFirstLoginUseCase.supplier(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (success) => emit(const ResetPasswordActiveAccountSuccess()),
    );
  }

  Future<void> brandOwnerFirstLogin({
    required String email,
    required String password,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _firstLoginUseCase.brandOwner(
      email: email,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (firstLoginResponseModel) =>
          emit(ActiveAccountSuccess(firstLoginResponseModel)),
    );
  }

  Future<void> brandOwnerResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _resetPasswordFirstLoginUseCase.brandOwner(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (success) => emit(const ResetPasswordActiveAccountSuccess()),
    );
  }

  Future<void> cashierFirstLogin({
    required String email,
    required String password,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _firstLoginUseCase.cashier(
      email: email,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (firstLoginResponseModel) =>
          emit(ActiveAccountSuccess(firstLoginResponseModel)),
    );
  }

  Future<void> cashierResetPasswordFirstLogin({
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ActiveAccountLoading());
    final result = await _resetPasswordFirstLoginUseCase.cashier(
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    handle(
      result,
      failure: (failure) => emit(ActiveAccountFailure(failure: failure)),
      success: (success) => emit(const ResetPasswordActiveAccountSuccess()),
    );
  }
}
