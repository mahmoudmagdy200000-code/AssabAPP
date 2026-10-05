import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../data/repositories/brand_owner_requests_repository.dart';
import '../../data/models/brand_owner_requests_models.dart';
import 'brand_owner_payment_log_state.dart';

@injectable
class BrandOwnerPaymentLogCubit extends SafeCubit<BrandOwnerPaymentLogState> {
  final BrandOwnerRequestsRepository _repository;

  // ── pagination bookkeeping ──────────────────────────────────────────────
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;

  // active filters – kept so loadMore() can reuse them
  String? _type;
  String? _sortByDate;
  String? _branchId;

  // accumulated list across pages
  final List<BrandOwnerPaymentLogItemModel> _items = [];

  BrandOwnerPaymentLogCubit(this._repository)
    : super(const BrandOwnerPaymentLogInitial());

  // ── public helpers ───────────────────────────────────────────────────────
  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;

  // ── initial / filtered fetch (resets pagination) ─────────────────────────
  Future<void> getBrandOwnerPaymentLog({
    String? type,
    String? sortByDate,
    String? branchId,
  }) async {
    // reset state
    _currentPage = 1;
    _hasMore = true;
    _isFetchingMore = false;
    _items.clear();
    _type = type;
    _sortByDate = sortByDate;
    _branchId = branchId;

    emit(const BrandOwnerPaymentLogLoading());

    final result = await _repository.getBrandOwnerPaymentLogScreen(
      type: _type,
      sortByDate: _sortByDate,
      branchId: _branchId,
      page: _currentPage,
    );

    handle(
      result,
      success: (response) {
        _items.addAll(response.data);
        _hasMore = _currentPage < response.meta.lastPage;
        emit(
          BrandOwnerPaymentLogSuccess(
            items: List.unmodifiable(_items),
            summary: response.summary,
            meta: response.meta,
            hasMore: _hasMore,
          ),
        );
      },
      failure: (failure) => emit(BrandOwnerPaymentLogFailure(failure)),
    );
  }

  // ── load next page (called from scroll listener) ─────────────────────────
  Future<void> loadMore() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    _currentPage++;

    // Emit paginating so the UI can show a bottom spinner
    // while keeping the existing list visible.
    if (state is BrandOwnerPaymentLogSuccess) {
      emit(
        BrandOwnerPaymentLogPaginating(
          items: List.unmodifiable(_items),
          summary: (state as BrandOwnerPaymentLogSuccess).summary,
          meta: (state as BrandOwnerPaymentLogSuccess).meta,
        ),
      );
    }

    final result = await _repository.getBrandOwnerPaymentLogScreen(
      type: _type,
      sortByDate: _sortByDate,
      branchId: _branchId,
      page: _currentPage,
    );

    handle(
      result,
      success: (response) {
        _items.addAll(response.data);
        _hasMore = _currentPage < response.meta.lastPage;
        emit(
          BrandOwnerPaymentLogSuccess(
            items: List.unmodifiable(_items),
            summary: response.summary,
            meta: response.meta,
            hasMore: _hasMore,
          ),
        );
      },
      failure: (failure) {
        // Roll back page counter so the user can retry
        _currentPage--;
        emit(BrandOwnerPaymentLogFailure(failure));
      },
    );

    _isFetchingMore = false;
  }

  // ── detail & branches (unchanged) ────────────────────────────────────────
  Future<void> getBrandOwnerPaymentLogDetails({
    required String paymentLogId,
  }) async {
    emit(const BrandOwnerPaymentLogLoading());
    final result = await _repository.getBrandOwnerPaymentLogDetailsScreen(
      paymentLogId: paymentLogId,
    );
    handle(
      result,
      success: (details) => emit(BrandOwnerPaymentLogDetailsSuccess(details)),
      failure: (failure) => emit(BrandOwnerPaymentLogFailure(failure)),
    );
  }

  Future<void> getBrandOwnerPaymentLogBranches() async {
    emit(const BrandOwnerPaymentLogLoading());

    final result = await _repository.getBrandOwnerPaymentLogBranches();
    handle(
      result,
      success: (branches) =>
          emit(BrandOwnerPaymentLogBranchesSuccess(branches.branches)),
      failure: (failure) => emit(BrandOwnerPaymentLogFailure(failure)),
    );
  }
}
