import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repositories/fixed_assets_repository.dart';
import 'get_fixed_assets_overview_state.dart';

@injectable
class GetFixedAssetsOverviewCubit
    extends SafeCubit<GetFixedAssetsOverviewState> {
  final FixedAssetsRepository _repository;

  GetFixedAssetsOverviewCubit(this._repository)
    : super(const GetFixedAssetsOverviewInit());

  Future<void> getOverview({bool loading = true}) async {
    if (loading) {
      emit(const GetFixedAssetsOverviewLoading());
    }

    final result = await _repository.getOverview();

    handle(
      result,
      success: (overview) {
        emit(GetFixedAssetsOverviewSuccess(overview));
      },
      failure: (failure) => emit(GetFixedAssetsOverviewFailure(failure)),
    );
  }
}
