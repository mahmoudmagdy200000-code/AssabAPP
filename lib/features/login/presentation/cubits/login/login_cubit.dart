import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:assab/features/login/domain/usecases/branch_manager_login_usecase.dart';
import 'package:assab/features/login/domain/usecases/brand_owner_login_usecase.dart';
import 'package:assab/features/login/domain/usecases/cashier_login_usecase.dart';
import 'package:assab/features/login/domain/usecases/supplier_login_usecase.dart';
import 'package:injectable/injectable.dart';

import 'login_state.dart';

@injectable
class LoginCubit extends SafeCubit<LoginState> {
  final BranchManagerLoginUseCase _branchManagerLoginUseCase;
  final SupplierLoginUseCase _supplierLoginUseCase;
  final CashierLoginUseCase _cashierLoginUseCase;
  final BrandOwnerLoginUseCase _brandOwnerLoginUseCase;

  LoginCubit(
    this._branchManagerLoginUseCase,
    this._supplierLoginUseCase,
    this._cashierLoginUseCase,
    this._brandOwnerLoginUseCase,
  ) : super(const LoginInitial());

  Future<void> branchManagerLogin({
    required String identifier,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _branchManagerLoginUseCase(
      identifier: identifier,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(LoginFailure(failure)),
      success: (entity) => emit(LoginSuccess(entity)),
    );
  }

  Future<void> supplierLogin({
    required String identifier,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _supplierLoginUseCase(
      identifier: identifier,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(LoginFailure(failure)),
      success: (entity) => emit(LoginSuccess(entity)),
    );
  }

  Future<void> cashierLogin({
    required String identifier,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _cashierLoginUseCase(
      identifier: identifier,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(LoginFailure(failure)),
      success: (entity) => emit(LoginSuccess(entity)),
    );
  }

  Future<void> brandOwnerLogin({
    required String identifier,
    required String password,
  }) async {
    emit(const LoginLoading());

    final result = await _brandOwnerLoginUseCase(
      identifier: identifier,
      password: password,
    );

    handle(
      result,
      failure: (failure) => emit(LoginFailure(failure)),
      success: (entity) => emit(LoginSuccess(entity)),
    );
  }
}
