import 'dart:io';

import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/end_shift_aggregator_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_with_hand_over_summary_strategy/variance_summary_strategy_factory.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/model/shift/end_shift_aggregator_model.dart';
import '../../../../data/model/shift/end_shift_request.dart';
import '../../../../data/model/shift/variance_model.dart';
import '../../../../domain/entity/handover_user_item.dart';
import '../../../../domain/entity/shift/aggregator_entites.dart';

part 'end_shift_state.dart';

@injectable
class EndShiftCubit extends SafeCubit<EndShiftState> {
  final ShiftManagementRepositoryImp _repository;

  EndShiftCubit(
    this._repository,
    @factoryParam this.shiftId,
    @factoryParam this.shift,
  ) : super(EndShiftInitial());

  String shiftId = '';
  ShiftEntity? shift;
  double _totalSales = 0;
  double _cashCollected = 0;
  double _cardPayments = 0;
  final double _cashGiven = 0;
  double? handOverAmount = 0;
  List<TotalSalesAggregatorEntity> _aggregators = [];
  File? _posReceipt;
  HandoverUserItem? cashier;
  String? handOverNote;
  String? nextCashierId;
  double _varianceAmount = 0;

  void endShiftHandOverValuesUpdated({
    required double handOverAmount,
    required String? handOverNote,
    required HandoverUserItem? cashier,
  }) {
    this.handOverAmount = handOverAmount;
    this.handOverNote = handOverNote;
    this.cashier = cashier;

    emit(
      EndShiftHandOverValuesUpdated(
        handOverAmount: this.handOverAmount!,
        cashier: this.cashier,
      ),
    );
  }

  void endShiftTotalSalesValuesUpdated({
    required double totalSales,
    required double cashCollected,
    required double cardPayments,
    required List<AggregatorEntity> aggregators,
  }) {
    _totalSales = totalSales;
    _cashCollected = cashCollected;
    _cardPayments = cardPayments;

    updateAggregators(aggregators);

    emit(
      EndShiftTotalSalesValuesUpdated(
        totalSales: _totalSales,
        cashCollected: _cashCollected,
        cardPayments: _cardPayments,
        aggregators: _aggregators,
      ),
    );
  }

  void setVarianceType(String? type) {
    final strategy = type == null ? null : VarianceStrategyFactory.create(type);
    emit(state.copyWith(varianceStrategy: strategy));
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

  double get paymentMethodsTotal =>
      (_aggregators.fold<double>(0, (sum, e) => sum + (e.amount)) +
      _cashCollected +
      _cardPayments);

  double? get varianceAmount {
    final calculatedMethodsTotal = paymentMethodsTotal;

    if (calculatedMethodsTotal == 0) {
      return _varianceAmount = 0;
    }
    if (totalSales > (calculatedMethodsTotal)) {
      return _varianceAmount = totalSales - (calculatedMethodsTotal);
    } else if (totalSales < (calculatedMethodsTotal)) {
      return _varianceAmount = (calculatedMethodsTotal) - totalSales;
    }

    return _varianceAmount = 0;
  }

  set varianceAmount(double value) {
    _varianceAmount = value;
  }

  double get cashGiven => _cashGiven;

  double get totalSales => _totalSales;

  double get cashCollected => _cashCollected;

  double get cardPayments => _cardPayments;

  List<TotalSalesAggregatorEntity> get aggregators => _aggregators;

  File? get posReceipt => _posReceipt;

  void updateAggregators(List<AggregatorEntity> list) {
    _aggregators = list
        .map((a) => TotalSalesAggregatorEntity.fromEntity(a))
        .toList();
  }

  void updatePosReceipt(File file) {
    _posReceipt = file;
  }

  Future<void> endShift({
    required Variance variance,
    required bool isThereVariance,
  }) async {
    emit(EndShiftLoading(varianceStrategy: state.varianceStrategy));

    final request = EndShiftRequest(
      totalSales: _totalSales,
      cashCollected: _cashCollected,
      cardPayments: _cardPayments,
      aggregators: _aggregators
          .map((a) => EndShiftAggregatorModel.fromEntity(a))
          .toList(),
      posReceipt: _posReceipt,
      isThereVariance: isThereVariance,
      variance: variance,
    );

    final result = await _repository.endShift(
      shiftId: shiftId,
      endShiftRequest: request,
    );

    handle(
      result,
      success: (_) => emit(EndShiftSuccess()),
      failure: (f) => emit(EndShiftFailure(f)),
    );
  }

  Future<void> endShitWithHandOver(EndShiftRequestWithHandOver request) async {
    emit(EndShiftLoading(varianceStrategy: state.varianceStrategy));

    final result = await _repository.endShiftWithHandOver(shiftId, request);

    handle(
      result,
      success: (_) => emit(EndShiftSuccess()),
      failure: (f) => emit(EndShiftFailure(f)),
    );
  }
}
