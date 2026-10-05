import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/fixed_assets_active_handover_approve_zone_request.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'fixd_assets_active_handover_approval_state.dart';

@injectable
class FixdAssetsActiveHandoverApprovalCubit
    extends SafeCubit<FixdAssetsActiveHandoverApprovalState> {
  final FixedAssetsRepository _repository;
  final Set<String> _loadingZoneIds = {};

  FixdAssetsActiveHandoverApprovalCubit(this._repository)
    : super(const FixdAssetsActiveHandoverApprovalInit());

  Future<void> approveAll({required String sessionId}) async {
    _loadingZoneIds.clear();
    emit(const FixdAssetsActiveHandoverApprovalAllLoading());

    final result = await _repository.approveAllActiveHandoverZones(
      sessionId: sessionId,
    );

    handle(
      result,
      success: (_) => emit(const FixdAssetsActiveHandoverApprovalAllSuccess()),
      failure: (failure) =>
          emit(FixdAssetsActiveHandoverApprovalFailure(failure)),
    );
  }

  Future<void> approveZone({
    required FixedAssetsActiveHandoverApproveZoneRequest request,
  }) async {
    _loadingZoneIds.add(request.zoneId);
    emit(
      FixdAssetsActiveHandoverApprovalZoneLoading(
        Set<String>.from(_loadingZoneIds),
      ),
    );

    final result = await _repository.approveActiveHandoverZone(
      request: request,
    );

    handle(
      result,
      success: (_) {
        _loadingZoneIds.remove(request.zoneId);
        emit(
          FixdAssetsActiveHandoverApprovalZoneSuccess(
            request.zoneId,
            Set<String>.from(_loadingZoneIds),
          ),
        );
      },
      failure: (failure) {
        _loadingZoneIds.remove(request.zoneId);
        emit(
          FixdAssetsActiveHandoverApprovalFailure(
            failure,
            loadingZoneIds: Set<String>.from(_loadingZoneIds),
          ),
        );
      },
    );
  }
}
