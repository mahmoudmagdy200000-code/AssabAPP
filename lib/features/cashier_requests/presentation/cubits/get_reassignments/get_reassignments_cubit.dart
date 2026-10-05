import 'package:assab/core/helpers/paginator.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../branch_manager_requests/data/repository/requests_repository.dart';
import '../../../data/models/reassigned_shift_item_model.dart';
import '../../../data/models/reassigned_shift_response.dart';
import 'get_reassignments_state.dart';

@injectable
class GetReassignedShiftsCubit extends SafeCubit<GetReassignedShiftsState> {
  final RequestsRepository _requestsRepository;

  late final Paginator<ReassignedShiftItemModel, ReassignedShiftsResponse>
  paginator;

  GetReassignedShiftsCubit(this._requestsRepository)
    : super(const GetReassignedShiftsInit()) {
    paginator = Paginator<ReassignedShiftItemModel, ReassignedShiftsResponse>(
      fetchPage: (page) async =>
          await _requestsRepository.getReassignedShifts(page: page),

      extractData: (response) => response.data,

      extractMeta: (response) => MetaInfo(
        currentPage: response.meta.currentPage,
        lastPage: response.meta.lastPage,
        total: response.meta.total,
      ),
    );
  }

  void getReassignedShifts({bool loadMore = false}) async {
    if (!loadMore) {
      paginator.reset();
      emit(const GetReassignedShiftsLoading());
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetReassignedShiftsFailure(failure)),
      success: (items) => emit(GetReassignedShiftsSuccess(items)),
    );
  }
}
