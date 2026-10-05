import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/errors/api_failure.dart';
import '../../../../../../core/helpers/paginator.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../data/mapper/shift/shift_details/shift_info_details_mapper.dart';
import '../../../data/model/shift/available_shifts_model.dart';
import '../../../data/model/shift/shift_details/shift_info_details_model.dart';
import '../../../domain/entity/shift/shift_info_details_entity.dart';

part 'get_available_cashier_shifts_state.dart';

class GetAvailableCashierShiftsCubit
    extends SafeCubit<GetAvailableCashierShiftsState> {
  final ShiftManagementRepositoryImp _repository;

  GetAvailableCashierShiftsCubit(this._repository)
    : super(GetAvailableCashierShiftsInitial());

  Paginator<ShiftInfoDetailsModel, AvailableShiftResponseModel>?
  _shiftsPaginator;
  List<ShiftInfoDetailsEntity>? workShifts;

  bool get shiftsPaginatorHasMore => _shiftsPaginator?.hasMore ?? false;

  Future<void> getAvailableCashierShifts({
    required bool resetPagination,
  }) async {
    if (_shiftsPaginator == null || resetPagination) {
      _shiftsPaginator =
          Paginator<ShiftInfoDetailsModel, AvailableShiftResponseModel>(
            fetchPage: (page) => _repository.getAvailableShifts(page: page),
            extractData: (res) => res.shifts,
            extractMeta: (res) => MetaInfo(
              currentPage: res.meta.currentPage,
              lastPage: res.meta.lastPage,
              total: res.meta.total,
            ),
          );
    }

    if (resetPagination) {
      _shiftsPaginator!.reset();
      workShifts = [];
      emit(GetAvailableCashierShiftsLoading());
    }

    final result = await _shiftsPaginator!.loadNextPage();

    handle(
      result,
      failure: (f) => emit(GetAvailableCashierShiftsFailure(f)),
      success: (items) {
        if (items.isNotEmpty) {
          workShifts ??= [];
          workShifts!.addAll(items.map((e) => e.toEntity()));

          emit(
            GetAvailableCashierShiftsSuccess<ShiftInfoDetailsEntity>(
              List.unmodifiable(workShifts!),
            ),
          );
        } else if (workShifts == null || workShifts!.isEmpty) {
          emit(GetAvailableCashierShiftsEmpty());
        }
      },
    );
  }
}
