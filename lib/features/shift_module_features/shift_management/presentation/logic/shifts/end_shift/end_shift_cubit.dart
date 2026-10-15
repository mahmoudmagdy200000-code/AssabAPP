import 'dart:io';

import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/end_shift_request_with_variance.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/end_shift_aggregator_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/end_shift_widgets/end_shift_with_hand_over_summary_strategy/variance_summary_strategy_factory.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/helpers/safe_cubit.dart';
import '../../../../data/model/shift/end_shift_aggregator_model.dart';
import '../../../../data/model/shift/end_shift_request.dart';
import '../../../../data/model/shift/variance_model.dart';
import '../../../../domain/entity/handover_user_item.dart';
import '../../../../domain/entity/shift/aggregator_entites.dart';

part 'end_shift_state.dart';

class EndShiftPreviewLoading extends EndShiftState {}

class EndShiftPreviewSuccess extends EndShiftState {
  final Map<String, dynamic> previewData;
  final double shortageToAllocate;
  final bool allocationRequired;
  final String cashVarianceType;

  const EndShiftPreviewSuccess({
    required this.previewData,
    required this.shortageToAllocate,
    required this.allocationRequired,
    required this.cashVarianceType,
  });

  @override
  List<Object?> get props => [
        previewData,
        shortageToAllocate,
        allocationRequired,
        cashVarianceType,
      ];
}

class EndShiftPreviewFailure extends EndShiftState {
  final ApiFailure failure;
  const EndShiftPreviewFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class EndShiftPreviewInvalidated extends EndShiftState {}

class EndShiftAllocationsUpdated extends EndShiftState {
  final List<CashShortageAllocation> allocations;
  const EndShiftAllocationsUpdated({required this.allocations});

  @override
  List<Object?> get props => [allocations];
}

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

  // Physical cash count (null = unentered, distinct from 0.0)
  double? _countedCash;
  Map<String, dynamic>? _previewData;
  bool _previewStale = true;
  bool _isPreviewLoading = false;
  List<CashShortageAllocation> _shortageAllocations = [];
  String? _allocationReason;
  bool _isSubmitting = false;

  double? get countedCash => _countedCash;
  Map<String, dynamic>? get previewData => _previewData;
  bool get previewStale => _previewStale;
  bool get isPreviewLoading => _isPreviewLoading;
  List<CashShortageAllocation> get shortageAllocations => _shortageAllocations;
  String? get allocationReason => _allocationReason;
  bool get isSubmitting => _isSubmitting;

  static ApiFailure _createValidationFailure(String message) {
    return ValidationFailure(
      error: LocalErrorModel(message: message, errors: null),
      icon: CupertinoIcons.exclamationmark_triangle,
      statusCode: 422,
      stackTrace: StackTrace.empty,
    );
  }

  void setCountedCash(double? value) {
    if (_countedCash != value) {
      _countedCash = value;
      invalidatePreview();
    }
  }

  void invalidatePreview() {
    _previewData = null;
    _previewStale = true;
    _shortageAllocations = [];
    emit(EndShiftPreviewInvalidated());
  }

  void updateShortageAllocations(
    List<CashShortageAllocation> allocations, [
    String? reason,
  ]) {
    _shortageAllocations = allocations;
    if (reason != null) _allocationReason = reason;
    emit(EndShiftAllocationsUpdated(allocations: _shortageAllocations));
  }

  Future<void> fetchCashReconciliationPreview() async {
    if (_countedCash == null) {
      emit(
        EndShiftPreviewFailure(
          _createValidationFailure(
            'Counted cash is required for reconciliation preview',
          ),
        ),
      );
      return;
    }
    _isPreviewLoading = true;
    emit(EndShiftPreviewLoading());

    final result = await _repository.previewCashReconciliation(
      shiftId: shiftId,
      totalSales: _totalSales,
      countedCash: _countedCash!,
      cardPayments: _cardPayments,
      aggregators: _aggregators
          .map((a) => EndShiftAggregatorModel.fromEntity(a))
          .toList(),
    );

    _isPreviewLoading = false;
    handle(
      result,
      success: (data) {
        _previewData = data;
        _previewStale = false;
        final previewMap = (data['data'] is Map<String, dynamic>)
            ? data['data'] as Map<String, dynamic>
            : data;
        final shortageToAllocate = (previewMap['shortage_to_allocate'] is num)
            ? (previewMap['shortage_to_allocate'] as num).toDouble()
            : double.tryParse(
                    previewMap['shortage_to_allocate']?.toString() ?? '0') ??
                0.0;
        final allocationRequired = previewMap['allocation_required'] == true;
        final recon =
            previewMap['cash_reconciliation'] as Map<String, dynamic>? ?? {};
        final varianceType =
            recon['cash_variance_type']?.toString() ?? 'balanced';

        emit(
          EndShiftPreviewSuccess(
            previewData: previewMap,
            shortageToAllocate: shortageToAllocate,
            allocationRequired: allocationRequired,
            cashVarianceType: varianceType,
          ),
        );
      },
      failure: (f) {
        _previewData = null;
        _previewStale = true;
        emit(EndShiftPreviewFailure(f));
      },
    );
  }

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
    invalidatePreview();

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
    invalidatePreview();
  }

  void updatePosReceipt(File file) {
    _posReceipt = file;
  }

  Future<void> endShift({
    required Variance variance,
    required bool isThereVariance,
  }) async {
    if (_isSubmitting) return;

    if (_countedCash == null) {
      emit(
        EndShiftFailure(
          _createValidationFailure('Counted cash is required before ending shift'),
        ),
      );
      return;
    }

    if (_previewStale || _previewData == null) {
      emit(
        EndShiftFailure(
          _createValidationFailure(
            'Stale or missing preview. Please preview cash reconciliation first.',
          ),
        ),
      );
      return;
    }

    final previewMap = (_previewData!['data'] is Map<String, dynamic>)
        ? _previewData!['data'] as Map<String, dynamic>
        : _previewData!;
    final allocationRequired = previewMap['allocation_required'] == true;
    final shortageToAllocate =
        (previewMap['shortage_to_allocate'] as num?)?.toDouble() ?? 0.0;

    if (allocationRequired) {
      final allocatedSum =
          _shortageAllocations.fold<double>(0.0, (sum, a) => sum + a.amount);
      if ((allocatedSum - shortageToAllocate).abs() > 0.01) {
        emit(
          EndShiftFailure(
            _createValidationFailure(
              'Allocated sum must equal the shortage amount before ending shift.',
            ),
          ),
        );
        return;
      }
    } else {
      if (_shortageAllocations.isNotEmpty) {
        emit(
          EndShiftFailure(
            _createValidationFailure('Allocations are only accepted for a shortage.'),
          ),
        );
        return;
      }
    }

    _isSubmitting = true;
    emit(EndShiftLoading(varianceStrategy: state.varianceStrategy));

    final request = EndShiftRequest(
      totalSales: _totalSales,
      cashCollected: _cashCollected,
      cardPayments: _cardPayments,
      countedCash: _countedCash!,
      shortageAllocations: _shortageAllocations,
      allocationReason: _allocationReason,
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

    _isSubmitting = false;
    handle(
      result,
      success: (_) => emit(EndShiftSuccess()),
      failure: (f) => emit(EndShiftFailure(f)),
    );
  }

  Future<void> endShitWithHandOver(EndShiftRequestWithHandOver request) async {
    if (_isSubmitting) return;

    if (_countedCash == null) {
      emit(
        EndShiftFailure(
          _createValidationFailure('Counted cash is required before ending shift'),
        ),
      );
      return;
    }

    if (_previewStale || _previewData == null) {
      emit(
        EndShiftFailure(
          _createValidationFailure(
            'Stale or missing preview. Please preview cash reconciliation first.',
          ),
        ),
      );
      return;
    }

    final previewMap = (_previewData!['data'] is Map<String, dynamic>)
        ? _previewData!['data'] as Map<String, dynamic>
        : _previewData!;
    final allocationRequired = previewMap['allocation_required'] == true;
    final shortageToAllocate =
        (previewMap['shortage_to_allocate'] as num?)?.toDouble() ?? 0.0;

    if (allocationRequired) {
      final allocatedSum =
          _shortageAllocations.fold<double>(0.0, (sum, a) => sum + a.amount);
      if ((allocatedSum - shortageToAllocate).abs() > 0.01) {
        emit(
          EndShiftFailure(
            _createValidationFailure(
              'Allocated sum must equal the shortage amount before ending shift.',
            ),
          ),
        );
        return;
      }
    } else {
      if (_shortageAllocations.isNotEmpty) {
        emit(
          EndShiftFailure(
            _createValidationFailure('Allocations are only accepted for a shortage.'),
          ),
        );
        return;
      }
    }

    _isSubmitting = true;
    emit(EndShiftLoading(varianceStrategy: state.varianceStrategy));

    // Bind physical count, allocations and allocation reason to the handover request
    final boundRequest = EndShiftRequestWithHandOver(
      totalSales: request.totalSales,
      cashCollected: request.cashCollected,
      cardPayments: request.cardPayments,
      countedCash: _countedCash!,
      shortageAllocations: _shortageAllocations,
      allocationReason: _allocationReason,
      posReceipt: request.posReceipt,
      nextCashierId: request.nextCashierId,
      handoverAmount: request.handoverAmount,
      handoverNotes: request.handoverNotes,
      aggregators: request.aggregators,
      variance: request.variance,
      isThereVariance: request.isThereVariance,
      isManager: request.isManager,
    );

    final result = await _repository.endShiftWithHandOver(shiftId, boundRequest);

    _isSubmitting = false;
    handle(
      result,
      success: (_) => emit(EndShiftSuccess()),
      failure: (f) => emit(EndShiftFailure(f)),
    );
  }
}
