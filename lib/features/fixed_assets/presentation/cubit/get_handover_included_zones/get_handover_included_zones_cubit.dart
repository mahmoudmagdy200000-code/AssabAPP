import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_handover_included_zones_state.dart';

@injectable
class GetHandoverIncludedZonesCubit
    extends SafeCubit<GetHandoverIncludedZonesState> {
  final FixedAssetsRepository _repository;

  GetHandoverIncludedZonesCubit(this._repository)
    : super(const GetHandoverIncludedZonesInit());

  Future<void> getHandoverIncludedZones({required String statusFilter}) async {
    emit(const GetHandoverIncludedZonesLoading());

    final result = await _repository.getHandoverIncludedZones(
      statusFilter: statusFilter,
    );

    handle(
      result,
      success: (data) => emit(GetHandoverIncludedZonesSuccess(data)),
      failure: (failure) => emit(GetHandoverIncludedZonesFailure(failure)),
    );
  }
}
