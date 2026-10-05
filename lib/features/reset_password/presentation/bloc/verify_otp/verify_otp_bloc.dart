import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/reset_password_repository.dart';
import 'verify_otp_event.dart';
import 'verify_otp_state.dart';

@injectable
class VerifyOtpBloc extends Bloc<VerifyOtpEvent, VerifyOtpState> {
  final ResetPasswordRepository _repository;
  static const int _initialSeconds = 30;

  VerifyOtpBloc(this._repository) : super(const VerifyOtpInit()) {
    on<BranchVerifyOtpStarted>(_onBranchVerifyOtp, transformer: droppable());
    on<SupplierVerifyOtpStarted>(
      _onSupplierVerifyOtp,
      transformer: droppable(),
    );
    on<CashierVerifyOtpStarted>(_onCashierVerifyOtp, transformer: droppable());
    on<BrandOwnerVerifyOtpStarted>(
      _onBrandOwnerVerifyOtp,
      transformer: droppable(),
    );
    on<VerifyOtpTicked>(_onTicked, transformer: restartable());
    on<VerifyOtpResend>(_onResend, transformer: sequential());
  }

  Future<void> _onBranchVerifyOtp(
    BranchVerifyOtpStarted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());

    final result = await _repository.branchManagerVerifyOtp(
      request: event.request,
    );

    result.when(
      failure: (failure) => emit(VerifyOtpFailure(failure)),
      success: (_) => emit(const VerifyOtpSuccess()),
    );
  }

  Future<void> _onSupplierVerifyOtp(
    SupplierVerifyOtpStarted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());

    final result = await _repository.supplierVerifyOtp(request: event.request);

    result.when(
      failure: (failure) => emit(VerifyOtpFailure(failure)),
      success: (_) => emit(const VerifyOtpSuccess()),
    );
  }

  Future<void> _onCashierVerifyOtp(
    CashierVerifyOtpStarted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());

    final result = await _repository.cashierVerifyOtp(request: event.request);

    result.when(
      failure: (failure) => emit(VerifyOtpFailure(failure)),
      success: (_) => emit(const VerifyOtpSuccess()),
    );
  }

  Future<void> _onBrandOwnerVerifyOtp(
    BrandOwnerVerifyOtpStarted event,
    Emitter<VerifyOtpState> emit,
  ) async {
    emit(const VerifyOtpLoading());

    final result = await _repository.brandOwnerVerifyOtp(
      request: event.request,
    );

    result.when(
      failure: (failure) => emit(VerifyOtpFailure(failure)),
      success: (_) => emit(const VerifyOtpSuccess()),
    );
  }

  Future<void> _onTicked(
    VerifyOtpTicked event,
    Emitter<VerifyOtpState> emit,
  ) async {
    for (int i = _initialSeconds; i > 0; i--) {
      emit(VerifyOtpRunning(i));
      await Future.delayed(const Duration(seconds: 1));
    }

    emit(const VerifyOtpCanResend());
  }

  void _onResend(VerifyOtpResend event, Emitter<VerifyOtpState> emit) {
    emit(const VerifyOtpRunning(_initialSeconds));
    add(VerifyOtpTicked());
  }
}
