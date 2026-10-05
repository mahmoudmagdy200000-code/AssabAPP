import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/variance_details/handover_variance_details_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';

part 'variance_state.dart';

@injectable
class VarianceCubit extends SafeCubit<VarianceState> {
  final ShiftManagementRepositoryImp _repo;

  VarianceCubit(this._repo) : super(VarianceInitial());

  Future<void> getVarianceDetails(String shiftId) async {
    emit(VarianceLoading());
    final result = await _repo.getVarianceDetails(shiftId);

    handle(
      result,
      success: (data) {
        emit(VarianceLoaded(data));
      },
      failure: (error) {
        emit(VarianceError(error));
      },
    );
  }
}
