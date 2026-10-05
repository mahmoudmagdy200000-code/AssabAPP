import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassign_shift_with_handover.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/available_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/end_shift_aggregator_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/helpers/paginator.dart';
import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/mapper/shift/available_cashiers_mapper.dart';
import '../../../../data/model/shift/available_cashiers_response_model.dart';
import '../../../../data/model/shift/reassign_shift/reassign_shift_params.dart';
import '../../../../data/model/shift/reassign_shift/reassign_shift_request_model.dart';
import '../../../../domain/entity/shift/aggregator_entites.dart';

part 'reassign_shift_state.dart';

@injectable
class ReassignShiftCubit extends SafeCubit<ReassignShiftState> {
  final ShiftManagementRepositoryImp _repository;
  final ReassignShiftParams params;

  ReassignShiftCubit(this._repository, @factoryParam this.params)
    : super(ReassignShiftInitial());

  ShiftEntity get shift => params.shift;
  ShiftCashierEntity? get previousCashier => params.previousCashier;
  ShiftCashierEntity? get nextCashier => params.nextCashier;

  List<AvailableCashierEntity>? cashiers;
  AvailableCashierEntity? selectedCashier;

  double totalSales = 0;
  double cashCollected = 0;
  double cardPayments = 0;
  double handOverAmount = 0;
  double paymentMethodsTotal = 0;
  double? _varianceAmount;

  List<TotalSalesAggregatorEntity> aggregators = [];

  Paginator<AvailableCashierEntity, AvailableCashiersResponse>?
  _cashiersPaginator;

  Future<void> getAvailableCashiers({bool resetPagination = false}) async {
    if (_cashiersPaginator == null || resetPagination) {
      _cashiersPaginator =
          Paginator<AvailableCashierEntity, AvailableCashiersResponse>(
            fetchPage: (page) => _repository.getAvailableCashiersForShift(
              shiftId: shift.shiftInfoDetails!.id,
              shiftDate: shift.shiftDate,
              page: page,
            ),
            extractData: (res) => res.data.map((e) => e.toEntity()).toList(),
            extractMeta: (res) => MetaInfo(
              currentPage: res.meta.currentPage,
              lastPage: res.meta.lastPage,
              total: res.meta.total,
            ),
          );
    }

    if (resetPagination) _cashiersPaginator!.reset();

    emit(ReassignShiftFetchAvailableLoading());
    final result = await _cashiersPaginator!.loadNextPage();

    handle(
      result,
      failure: (f) => emit(ReassignShiftFetchAvailableFailure(f)),
      success: (items) {
        if (items.isNotEmpty) {
          cashiers = items;
          emit(ReassignShiftFetchAvailableSuccess());
        } else {
          emit(ReassignShiftFetchAvailableEmpty());
        }
      },
    );
  }

  bool get hasMoreCashiers => _cashiersPaginator?.hasMore ?? false;

  /// Load next page if available
  Future<void> loadMoreCashiers() async {
    if (!hasMoreCashiers) return;
    final result = await _cashiersPaginator!.loadNextPage();

    handle(
      result,
      failure: (f) => emit(ReassignShiftFetchAvailableFailure(f)),
      success: (items) {
        if (items.isNotEmpty) {
          cashiers ??= [];
          cashiers!.addAll(items);
          emit(ReassignShiftFetchAvailableSuccess());
        }
      },
    );
  }

  Future<void> reassignCashier(String? reason) async {
    emit(ReassignShiftLoading());

    final result = await _repository.reassignShift(
      shift.id,
      ReassignShiftRequestModel(
        newCashierId: selectedCashier!.id,
        reason: reason,
      ),
    );

    handle(
      result,
      failure: (failure) {
        return emit(ReassignShiftFailure(failure));
      },
      success: (val) {
        return emit(ReassignShiftSuccess());
      },
    );
  }

  Future<void> reassignCashierWithHandOver({
    required ReassignShiftRequestWithHandOverRequest request,
  }) async {
    emit(ReassignShiftLoading());

    final result = await _repository.reassignShiftWithHandOver(
      shift.id,
      request,
    );

    handle(
      result,
      failure: (failure) {
        return emit(ReassignShiftFailure(failure));
      },
      success: (val) {
        return emit(ReassignShiftSuccess());
      },
    );
  }

  String calculateNetSales(String totalSalesText) {
    final totalSales = int.tryParse(totalSalesText) ?? 0;
    // Example: subtract 15% VAT or any other calculation
    final netSales = totalSales / 1.15;
    return netSales.toStringAsFixed(2);
  }

  String calculateNetVal(String totalSalesText) {
    final totalSales = int.tryParse(totalSalesText) ?? 0;

    final netVal = totalSales - (totalSales / 1.15);
    return netVal.toStringAsFixed(2);
  }

  void reassignTotalSalesValuesUpdated({
    required double totalSales,
    required double cashCollected,
    required double cardPayments,
    required double handOverAmount,
    required List<AggregatorEntity> aggregators,
  }) {
    updateAggregators(aggregators);
    this.totalSales = totalSales;
    this.cashCollected = cashCollected;
    this.cardPayments = cardPayments;
    this.handOverAmount = handOverAmount;

    emit(
      ReassignTotalSalesValuesUpdated(
        totalSales: totalSales,
        cashCollected: cashCollected,
        cardPayments: cardPayments,
        handOverAmount: handOverAmount,
        aggregators: this.aggregators,
      ),
    );
  }

  void updateAggregators(List<AggregatorEntity> list) {
    aggregators = list
        .map((a) => TotalSalesAggregatorEntity.fromEntity(a))
        .toList();
  }

  double? get varianceAmount {
    paymentMethodsTotal =
        (aggregators.fold<double>(0, (sum, e) => sum + (e.amount ?? 0)) +
        cashCollected +
        cardPayments);

    if (paymentMethodsTotal == 0) {
      return _varianceAmount = 0;
    }
    if (totalSales > (paymentMethodsTotal ?? 0)) {
      return _varianceAmount = totalSales - (paymentMethodsTotal ?? 0);
    } else if (totalSales < (paymentMethodsTotal ?? 0)) {
      return _varianceAmount = (paymentMethodsTotal ?? 0) - totalSales;
    }

    return _varianceAmount = 0;
  }

  void updateChooseEmployeeValues() {
    emit(
      ReassignChooseEmployeeValuesUpdated(selectedCashier: selectedCashier!),
    );
  }
}
