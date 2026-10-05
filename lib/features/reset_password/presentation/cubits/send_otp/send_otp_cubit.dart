import 'package:assab/features/reset_password/data/repository/reset_password_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/send_otp_request_model.dart';
import 'send_otp_state.dart';

@injectable
class SendOtpCubit extends SafeCubit<SendOtpState> {
  final ResetPasswordRepository _resetPasswordRepository;
  SendOtpCubit(this._resetPasswordRepository) : super(const SendOtpInit());

  Future<void> branchManagerSendOtp({
    required SendOtpRequestModel request,
  }) async {
    emit(const SendOtpLoading());

    final result = await _resetPasswordRepository.branchManagerSendOtp(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(SendOtpFailure(failure)),
      success: (_) => emit(const SendOtpSuccess()),
    );
  }

  Future<void> supplierSendOtp({required SendOtpRequestModel request}) async {
    emit(const SendOtpLoading());

    final result = await _resetPasswordRepository.supplierSendOtp(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(SendOtpFailure(failure)),
      success: (_) => emit(const SendOtpSuccess()),
    );
  }

  Future<void> cashierSendOtp({required SendOtpRequestModel request}) async {
    emit(const SendOtpLoading());

    final result = await _resetPasswordRepository.cashierSendOtp(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(SendOtpFailure(failure)),
      success: (_) => emit(const SendOtpSuccess()),
    );
  }

  Future<void> brandOwnerSendOtp({required SendOtpRequestModel request}) async {
    emit(const SendOtpLoading());

    final result = await _resetPasswordRepository.brandOwnerSendOtp(
      request: request,
    );

    handle(
      result,
      failure: (failure) => emit(SendOtpFailure(failure)),
      success: (_) => emit(const SendOtpSuccess()),
    );
  }
}
