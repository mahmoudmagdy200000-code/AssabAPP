import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/services/realtime_service/realtime_event.dart';
import '../../../../../core/utils/api_result.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import '../../../domain/constants/fixed_assets_handover_realtime_events.dart';
import 'fixed_assets_handover_session_realtime_state.dart';

@injectable
class FixedAssetsHandoverSessionRealtimeCubit
    extends SafeCubit<FixedAssetsHandoverSessionRealtimeState> {
  final FixedAssetsRepository _repository;

  FixedAssetsHandoverSessionRealtimeCubit(this._repository)
    : super(const FixedAssetsHandoverSessionRealtimeIdle());

  StreamSubscription? _subscription;
  String? _listeningSessionId;
  bool _isListening = false;

  @override
  Future<void> close() async {
    await _cancelListener();
    return super.close();
  }

  Future<void> subscribe({required String sessionId}) async {
    if (_isListening && _listeningSessionId == sessionId) {
      return;
    }

    await _cancelListener();

    _listeningSessionId = sessionId;
    _isListening = true;

    _subscription = _repository
        .subscribeToHandoverSession(sessionId: sessionId)
        .listen(_onRealtimeEvent);
  }

  Future<void> unsubscribe({required String sessionId}) async {
    await Future.wait([
      _cancelListener(),
      _repository.unsubscribeToHandoverSession(sessionId: sessionId),
    ]);
  }

  Future<void> _cancelListener() async {
    await _subscription?.cancel();
    _subscription = null;
    _listeningSessionId = null;
    _isListening = false;
  }

  void acknowledgeEvent() {
    if (state is! FixedAssetsHandoverSessionRealtimeIdle) {
      emit(const FixedAssetsHandoverSessionRealtimeIdle());
    }
  }

  void _onRealtimeEvent(ApiResult<RealtimeEvent<void>> result) {
    handle(
      result,
      failure: (_) {
        AppLogger.log(
          'Handover session realtime error (non-fatal)',
          tag: 'FixedAssetsHandoverSessionRealtimeCubit',
        );
      },
      success: (event) {
        switch (event.event) {
          case FixedAssetsHandoverRealtimeEvents.statusStarted:
            emit(const FixedAssetsHandoverSessionRealtimeStarted());
          case FixedAssetsHandoverRealtimeEvents.signatureReceiver:
            emit(const FixedAssetsHandoverSessionRealtimeReceiverSigned());
          case FixedAssetsHandoverRealtimeEvents.signatureSender:
            emit(const FixedAssetsHandoverSessionRealtimeSenderSigned());
          case FixedAssetsHandoverRealtimeEvents.statusChanged:
            emit(const FixedAssetsHandoverSessionRealtimeStatusChanged());
          default:
            break;
        }
      },
    );
  }
}
