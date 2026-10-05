import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/shift_tab_states.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../core/helpers/paginator.dart';
import '../../../../../../core/helpers/safe_cubit.dart';
import '../../../../../../core/utils/api_result.dart';
import '../../../data/mapper/shift/shift_mapper.dart';
import '../../../data/model/shift/shift_model.dart';
import '../../../data/model/shift/shift_response_model.dart';
import '../../../data/repository/shift_management_repository_imp.dart';
import '../../ui/filters/cashier_shifts_status_impl.dart';

part 'cashier_shifts_management_state.dart';
// @injectable
// class CashierShiftsManagementCubit
//     extends SafeCubit<CashierShiftsManagementState> {
//   final ShiftManagementRepositoryImp _repository;
//   final String cashierId;
//
//   List<ShiftEntity> shifts = [];
//   ShiftStatus? status;
//
//   late final Paginator<ShiftModel, ShiftResponseModel> paginator;
//
//   CashierShiftsManagementCubit(this._repository, @factoryParam this.cashierId)
//     : super(ShiftManagementBranchInitial()) {
//     paginator = Paginator<ShiftModel, ShiftResponseModel>(
//       fetchPage: (page) async {
//         return _currentFetcher!(cashierId, page);
//       },
//       extractData: (res) => res.data,
//       extractMeta: (res) => MetaInfo(
//         currentPage: res.meta.currentPage,
//         lastPage: res.meta.lastPage,
//         total: res.meta.total,
//       ),
//     );
//   }
//
//   Future<ApiResult<ShiftResponseModel>> Function(String cashierId, int page)?
//   _currentFetcher;
//
//   bool get hasMore => paginator.hasMore;
//
//   Future<void> getAllCashierShifts({bool loadMore = false}) async {
//     await _load(
//       loadMore,
//       _repository.getAllCashierShifts,
//       CashierShiftsAllShiftsStatus(),
//     );
//   }
//
//   Future<void> getPendingShifts({bool loadMore = false}) async {
//     await _load(
//       loadMore,
//       _repository.getPendingShifts,
//       CashierShiftsPendingStatus(),
//     );
//   }
//
//   Future<void> getInProgressShifts({bool loadMore = false}) async {
//     await _load(
//       loadMore,
//       _repository.getInProgressShifts,
//       CashierShiftsInProgressStatus(),
//     );
//   }
//
//   Future<void> getCompletedShifts({bool loadMore = false}) async {
//     await _load(
//       loadMore,
//       _repository.getCompletedShifts,
//       CashierShiftsCompletedStatus(),
//     );
//   }
//
//   Future<void> fetchShiftsWithFilters({
//     String? dateFilter,
//     ShiftStatus? statusFilter,
//     String? managerIdFilter,
//     required bool loadMore,
//   }) async {
//     // Save the filters
//     dateFilterOption = dateFilter;
//     this.statusFilter = statusFilter;
//     selectedManagerIdFilter = managerIdFilter;
//
//     // Update the fetcher internally
//     _currentFetcher = (cashierId, page) => _repository.getAllCashierShifts(
//       cashierId,
//       page,
//       dateFilter: dateFilterOption,
//       statusFilter: this.statusFilter,
//       managerId: selectedManagerIdFilter,
//     );
//
//     await _load(
//       loadMore,
//       _currentFetcher!, // now it includes filters
//       CashierShiftsFilterShiftsStatus(),
//     );
//   }
//
//   Future<void> _load(
//     bool loadMore,
//     Future<ApiResult<ShiftResponseModel>> Function(String, int) fetcher,
//     ShiftStatus newStatus,
//   ) async {
//     if (!loadMore || status?.type != newStatus.type) {
//       paginator.reset();
//       shifts.clear();
//       status = newStatus;
//       _currentFetcher = fetcher;
//       emit(const ShiftManagementBranchLoading());
//     }
//
//     final result = await paginator.loadNextPage();
//
//     result.when(
//       failure: (f) => emit(ShiftManagementBranchFailure(f, status!)),
//       success: (items) {
//         if (items.isNotEmpty) {
//           shifts.addAll(items.map((e) => e.toEntity()));
//
//           emit(
//             ShiftManagementBranchLoaded(
//               shifts: List.unmodifiable(shifts),
//               status: status!,
//             ),
//           );
//         } else if (shifts.isEmpty) {
//           emit(ShiftManagementBranchEmpty(status!));
//         }
//       },
//     );
//   }
//
//   Future<void> startCashierShift(
//     String shiftId,
//     ShiftStatus selectedShiftsStatus,
//   ) async {
//     emit(ShiftButtonLoading(shiftId));
//
//     final result = await _repository.startCashierShift(shiftId);
//
//     result.when(
//       failure: (f) => emit(ShiftButtonFailure(f)),
//       success: (shift) => emit(FetchShiftsAgain(status: selectedShiftsStatus)),
//     );
//   }
//
//   String? dateFilterOption;
//   ShiftStatus? statusFilter;
//   String? selectedManagerIdFilter;
//
//   bool get hasFilters =>
//       dateFilterOption != null ||
//       statusFilter != null ||
//       selectedManagerIdFilter != null;
// }

@injectable
class CashierShiftsManagementCubit
    extends SafeCubit<CashierShiftsManagementState> {
  final ShiftManagementRepositoryImp _repository;
  final String cashierId;

  CashierShiftsManagementCubit(this._repository, @factoryParam this.cashierId)
    : super(CashierShiftsManagementState.initial()) {
    _initPaginators();
  }

  /// ----------------------------
  /// Paginators
  /// ----------------------------

  late final Paginator<ShiftModel, ShiftResponseModel> pendingPaginator;

  late final Paginator<ShiftModel, ShiftResponseModel> inProgressPaginator;

  late final Paginator<ShiftModel, ShiftResponseModel> completedPaginator;

  late final Paginator<ShiftModel, ShiftResponseModel> filterPaginator;

  void _initPaginators() {
    pendingPaginator = _createPaginator(
      fetcher: (page) => _repository.getPendingShifts(cashierId, page),
    );

    inProgressPaginator = _createPaginator(
      fetcher: (page) => _repository.getInProgressShifts(cashierId, page),
    );

    completedPaginator = _createPaginator(
      fetcher: (page) => _repository.getCompletedShifts(cashierId, page),
    );

    filterPaginator = _createPaginator(
      fetcher: (page) => _repository.getAllCashierShifts(
        cashierId,
        page,
        dateFilter: dateFilterOption,
        statusFilter: statusFilter,
        managerId: selectedManagerIdFilter,
      ),
    );
  }

  Paginator<ShiftModel, ShiftResponseModel> _createPaginator({
    required Future<ApiResult<ShiftResponseModel>> Function(int page) fetcher,
  }) {
    return Paginator<ShiftModel, ShiftResponseModel>(
      fetchPage: fetcher,
      extractData: (res) => res.data,
      extractMeta: (res) => MetaInfo(
        currentPage: res.meta.currentPage,
        lastPage: res.meta.lastPage,
        total: res.meta.total,
      ),
    );
  }

  /// ===============================
  /// Pending
  /// ===============================

  ShiftStatus getStatusByIndex(int index) {
    switch (index) {
      case 0:
        return CashierShiftsPendingStatus();

      case 1:
        return CashierShiftsInProgressStatus();

      case 2:
        return CashierShiftsCompletedStatus();

      default:
        return CashierShiftsPendingStatus();
    }
  }

  String? dateFilterOption;
  ShiftStatus? statusFilter;
  String? selectedManagerIdFilter;

  Future<void> fetchShiftsWithFilters({
    String? dateFilter,
    ShiftStatus? statusFilter,
    String? managerIdFilter,
    bool loadMore = false,
  }) async {
    dateFilterOption = dateFilter;
    this.statusFilter = statusFilter;
    selectedManagerIdFilter = managerIdFilter;

    await _loadTab(
      paginator: filterPaginator,
      selector: (s) => s.filter,
      updater: (tab) => state.copyWith(filter: tab),
      loadMore: loadMore,
    );
  }

  Future<void> getPendingShifts({bool loadMore = false}) => _loadTab(
    paginator: pendingPaginator,
    selector: (s) => s.pending,
    updater: (tab) => state.copyWith(pending: tab),
    loadMore: loadMore,
  );

  /// ===============================
  /// InProgress
  /// ===============================

  Future<void> getInProgressShifts({bool loadMore = false}) => _loadTab(
    paginator: inProgressPaginator,
    selector: (s) => s.inProgress,
    updater: (tab) => state.copyWith(inProgress: tab),
    loadMore: loadMore,
  );

  /// ===============================
  /// Completed
  /// ===============================

  Future<void> getCompletedShifts({bool loadMore = false}) => _loadTab(
    paginator: completedPaginator,
    selector: (s) => s.completed,
    updater: (tab) => state.copyWith(completed: tab),
    loadMore: loadMore,
  );

  /// ===============================
  /// Reassigned
  /// ===============================

  /// ===============================
  /// Generic Loader
  /// ===============================

  Future<void> _loadTab({
    required Paginator<ShiftModel, ShiftResponseModel> paginator,
    required CashierShiftTabState Function(CashierShiftsManagementState)
    selector,
    required CashierShiftsManagementState Function(CashierShiftTabState)
    updater,
    required bool loadMore,
  }) async {
    final tabState = selector(state);

    if (!loadMore) {
      paginator.reset();

      emit(updater(tabState.copyWith(isLoading: true, failure: null)));
    }

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (f) {
        emit(updater(tabState.copyWith(isLoading: false, failure: f)));
      },
      success: (items) {
        emit(
          updater(
            tabState.copyWith(
              isLoading: false,
              items: items.map((e) => e.toEntity()).toList(),
              hasMore: paginator.hasMore,
            ),
          ),
        );
      },
    );
  }
}
