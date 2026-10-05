import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../data/models/daily_inventory_list_response.dart';
import '../../../data/models/monthly_inventory_list_response.dart';
import '../../../data/models/wasted_damage_list_response.dart';
import '../../../data/repository/inventory_repository.dart';
import 'get_inventory_requests_state.dart';

@injectable
class GetInventoryRequestsCubit extends SafeCubit<GetInventoryRequestsState> {
  final InventoryRepository _inventoryRepository;

  late final Paginator<
    DailyInventoryListResponseSession,
    DailyInventoryListResponse
  >
  _dailyPaginator;

  late final Paginator<WastedDamageListEntry, WastedDamageListResponse>
  _wasteDamagePaginator;

  late final Paginator<MonthlyInventoryListItem, MonthlyInventoryListResponse>
  _monthlyPaginator;

  GetInventoryRequestsCubit(this._inventoryRepository)
    : super(const GetInventoryRequestsInit()) {
    _dailyPaginator =
        Paginator<
          DailyInventoryListResponseSession,
          DailyInventoryListResponse
        >(
          fetchPage: (page) =>
              _inventoryRepository.getInventoryDailyRequests(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );

    _wasteDamagePaginator =
        Paginator<WastedDamageListEntry, WastedDamageListResponse>(
          fetchPage: (page) =>
              _inventoryRepository.getWasteDamageListReports(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );

    _monthlyPaginator =
        Paginator<MonthlyInventoryListItem, MonthlyInventoryListResponse>(
          fetchPage: (page) =>
              _inventoryRepository.getMonthlyInventoryList(page: page),
          extractData: (response) => response.data,
          extractMeta: (response) => MetaInfo(
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
          ),
        );
  }

  Future<void> getInventoryDailyRequests({bool loadMore = false}) async {
    if (!loadMore) {
      _dailyPaginator.reset();
      emit(const GetInventoryRequestsLoading());
    }

    final result = await _dailyPaginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetInventoryRequestsFailure(failure)),
      success: (response) => emit(GetDailyInventoryRequestsSuccess(response)),
    );
  }

  Future<void> getWasteDamageRequests({bool loadMore = false}) async {
    if (!loadMore) {
      _wasteDamagePaginator.reset();
      emit(const GetInventoryRequestsLoading());
    }

    final result = await _wasteDamagePaginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetInventoryRequestsFailure(failure)),
      success: (response) =>
          emit(GetWasteDamageInventoryRequestsSuccess(response)),
    );
  }

  Future<void> getMonthlyInventoryRequests({bool loadMore = false}) async {
    if (!loadMore) {
      _monthlyPaginator.reset();
      emit(const GetInventoryRequestsLoading());
    }

    final result = await _monthlyPaginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetInventoryRequestsFailure(failure)),
      success: (response) {
        emit(GetMonthlyInventoryRequestsSuccess(response));
      },
    );
  }

  Paginator<DailyInventoryListResponseSession, DailyInventoryListResponse>
  get dailyInventoryPaginator => _dailyPaginator;

  Paginator<WastedDamageListEntry, WastedDamageListResponse>
  get wasteDamageInventoryPaginator => _wasteDamagePaginator;

  Paginator<MonthlyInventoryListItem, MonthlyInventoryListResponse>
  get monthlyInventoryPaginator => _monthlyPaginator;
}
