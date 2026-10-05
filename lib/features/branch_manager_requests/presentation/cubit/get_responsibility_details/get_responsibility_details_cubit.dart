import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/branch_manager_requests/domain/entities/responsibility_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/repository/requests_repository.dart';

part 'get_responsibility_details_state.dart';

@injectable
class GetResponsibilityDetailsCubit
    extends SafeCubit<GetResponsibilityDetailsState> {
  final RequestsRepository _requestsRepository;
  GetResponsibilityDetailsCubit(this._requestsRepository)
    : super(GetResponsibilityDetailsInitial());

  Future<void> getResponsibilityDetails(String shiftId) async {
    emit(GetResponsibilityDetailsLoading());

    final result = await _requestsRepository.getResponsibilityDetails(shiftId);
    handle(
      result,
      failure: (failure) => emit(GetResponsibilityDetailsFailure(failure)),
      success: (data) => emit(GetResponsibilityDetailsSuccess(data)),
    );
  }
}
