import 'package:assab/features/cashier_my_shifts/data/repository/cashier_my_shifts_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/helpers/paginator.dart';
import '../../../../core/helpers/safe_cubit.dart';
import '../../data/mapper/shift_status_mappers/cashier_completed_shift_mapper.dart';
import '../../data/mapper/shift_status_mappers/cashier_in_progress_shift_mapper.dart';
import '../../data/mapper/shift_status_mappers/cashier_pending_shift_mapper.dart';
import '../../data/mapper/shift_status_mappers/cashier_reassigned_shift_mapper.dart';
import '../../data/model/shifts_models/completed/cashier_completed_shift_model.dart';
import '../../data/model/shifts_models/completed/cashier_completed_shifts_response_model.dart';
import '../../data/model/shifts_models/pending/cashier_pending_shift_model.dart';
import '../../data/model/shifts_models/pending/cashier_pending_shifts_response_model.dart';
import '../../data/model/shifts_models/reassigned/cashier_reassigned_shift_model.dart';
import '../../data/model/shifts_models/reassigned/cashier_reassigned_shifts_response_model.dart';
import 'cashier_my_shifts_state.dart';

@injectable
class CashierMyShiftsCubit extends SafeCubit<CashierMyShiftsState> {
  final CashierMyShiftsRepo _repo;

  CashierMyShiftsCubit(this._repo) : super(CashierMyShiftsState.initial()) {
    _initPaginators();
  }

  late final Paginator<
    CashierPendingShiftModel,
    CashierPendingShiftsResponseModel
  >
  pendingPaginator;

  late final Paginator<
    CashierCompletedShiftModel,
    CashierCompletedShiftsResponseModel
  >
  completedPaginator;

  late final Paginator<
    CashierReassignedShiftModel,
    CashierReassignedShiftsResponseModel
  >
  reassignedPaginator;

  void _initPaginators() {
    _initPendingShiftsPaginator();
    _initCompletedShiftsPaginator();
    _initReassignedShiftsPaginator();
  }

  void _initReassignedShiftsPaginator() {
    reassignedPaginator =
        Paginator<
          CashierReassignedShiftModel,
          CashierReassignedShiftsResponseModel
        >(
          fetchPage: (page) => _repo.getCashierMyReassignedShifts(page: page),
          extractData: (res) => res.data,
          extractMeta: (res) => MetaInfo(
            currentPage: res.meta.currentPage,
            lastPage: res.meta.lastPage,
            total: res.meta.total,
          ),
        );
  }

  void _initPendingShiftsPaginator() {
    pendingPaginator =
        Paginator<CashierPendingShiftModel, CashierPendingShiftsResponseModel>(
          fetchPage: (page) => _repo.getCashierMyPendingShifts(page: page),
          extractData: (res) => res.data,
          extractMeta: (res) => MetaInfo(
            currentPage: res.meta.currentPage,
            lastPage: res.meta.lastPage,
            total: res.meta.total,
          ),
        );
  }

  void _initCompletedShiftsPaginator() {
    completedPaginator =
        Paginator<
          CashierCompletedShiftModel,
          CashierCompletedShiftsResponseModel
        >(
          fetchPage: (page) => _repo.getCashierMyCompletedShifts(page: page),
          extractData: (res) => res.data,
          extractMeta: (res) => MetaInfo(
            currentPage: res.meta.currentPage,
            lastPage: res.meta.lastPage,
            total: res.meta.total,
          ),
        );
  }

  void fetchAllShifts() {
    getPendingShifts();
    getCompletedShifts();
    getReassignedShifts();
    getInProgressShifts();
  }

  Future<void> getPendingShifts({bool loadMore = false}) async {
    if (!loadMore) {
      pendingPaginator.reset();
      emit(state.copyWith(pending: state.pending.copyWith(isLoading: true)));
    }

    final result = await pendingPaginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(
        state.copyWith(
          pending: state.pending.copyWith(isLoading: false, failure: f),
        ),
      ),
      success: (items) => emit(
        state.copyWith(
          pending: state.pending.copyWith(
            isLoading: false,
            items: items.map((e) => e.toEntity()).toList(),
            hasMore: pendingPaginator.hasMore,
          ),
        ),
      ),
    );
  }

  Future<void> getCompletedShifts({bool loadMore = false}) async {
    if (!loadMore) {
      completedPaginator.reset();
      emit(
        state.copyWith(completed: state.completed.copyWith(isLoading: true)),
      );
    }

    final result = await completedPaginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(
        state.copyWith(
          completed: state.completed.copyWith(isLoading: false, failure: f),
        ),
      ),
      success: (items) => emit(
        state.copyWith(
          completed: state.completed.copyWith(
            isLoading: false,
            items: items.map((e) => e.toEntity()).toList(),
            hasMore: completedPaginator.hasMore,
          ),
        ),
      ),
    );
  }

  Future<void> getReassignedShifts({bool loadMore = false}) async {
    if (!loadMore) {
      reassignedPaginator.reset();
      emit(
        state.copyWith(reassigned: state.reassigned.copyWith(isLoading: true)),
      );
    }

    final result = await reassignedPaginator.loadNextPage();

    handle(
      result,
      failure: (f) => emit(
        state.copyWith(
          reassigned: state.reassigned.copyWith(isLoading: false, failure: f),
        ),
      ),
      success: (items) => emit(
        state.copyWith(
          reassigned: state.reassigned.copyWith(
            isLoading: false,
            items: items.map((e) => e.toEntity()).toList(),
            hasMore: reassignedPaginator.hasMore,
          ),
        ),
      ),
    );
  }

  Future<void> getInProgressShifts() async {
    emit(
      state.copyWith(
        inProgress: state.inProgress.copyWith(isLoading: true, failure: null),
      ),
    );

    final result = await _repo.getCashierMyInProgressShifts();

    handle(
      result,
      failure: (f) => emit(
        state.copyWith(
          inProgress: state.inProgress.copyWith(isLoading: false, failure: f),
        ),
      ),

      success: (response) {
        emit(
          state.copyWith(
            inProgress: state.inProgress.copyWith(
              isLoading: false,
              items: response.data.shifts.map((e) => e.toEntity()).toList(),
            ),
          ),
        );
      },
    );
  }
}
