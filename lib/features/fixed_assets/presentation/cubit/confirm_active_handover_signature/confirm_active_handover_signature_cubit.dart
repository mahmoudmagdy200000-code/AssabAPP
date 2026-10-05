import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../domain/use_cases/confirm_active_handover_signature_receiver_use_case.dart';
import '../../../domain/use_cases/confirm_active_handover_signature_sender_use_case.dart';
import 'confirm_active_handover_signature_state.dart';

@injectable
class ConfirmActiveHandoverSignatureCubit
    extends SafeCubit<ConfirmActiveHandoverSignatureState> {
  final ConfirmActiveHandoverSignatureReceiverUseCase _useCase;
  final ConfirmActiveHandoverSignatureSenderUseCase _senderUseCase;

  ConfirmActiveHandoverSignatureCubit(this._useCase, this._senderUseCase)
    : super(const ConfirmActiveHandoverSignatureInit());

  Future<void> confirmActiveHandoverSessionSignatureReceiver({
    required String sessionId,
  }) async {
    emit(const ConfirmActiveHandoverSignatureLoading());

    final result = await _useCase(sessionId: sessionId);

    handle(
      result,
      success: (response) =>
          emit(const ConfirmActiveHandoverSignatureSuccess()),
      failure: (failure) =>
          emit(ConfirmActiveHandoverSignatureFailure(failure)),
    );
  }

  Future<void> confirmActiveHandoverSessionSignatureSender({
    required String sessionId,
  }) async {
    emit(const ConfirmActiveHandoverSignatureLoading());

    final result = await _senderUseCase(sessionId: sessionId);

    handle(
      result,
      success: (response) =>
          emit(const ConfirmActiveHandoverSignatureSuccess()),
      failure: (failure) =>
          emit(ConfirmActiveHandoverSignatureFailure(failure)),
    );
  }
}
