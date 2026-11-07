import 'package:assab/generated/l10n.dart';
import 'dart:io';

import 'package:assab/core/errors/api_error_model.dart';
import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/core/network/idempotency_interceptor.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/cash_shortage_allocation.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/shift/shortage_allocation_candidate.dart';
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

class EndShiftCandidatesLoading extends EndShiftState {
  const EndShiftCandidatesLoading({super.varianceStrategy});
}

class EndShiftCandidatesSuccess extends EndShiftState {
  final List<ShortageAllocationCandidate> candidates;
  const EndShiftCandidatesSuccess(this.candidates, {super.varianceStrategy});

  @override
  List<Object?> get props => [candidates, varianceStrategy];
}

class EndShiftCandidatesFailure extends EndShiftState {
  final ApiFailure failure;
  const EndShiftCandidatesFailure(this.failure, {super.varianceStrategy});

  @override
  List<Object?> get props => [failure, varianceStrategy];
}

@injectable
class EndShiftCubit extends SafeCubit<EndShiftState> with UserIntentOwner {
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

  // Physical cash count (null = unentered, distinct from 0.0)
  double? _countedCash;
  Map<String, dynamic>? _previewData;
  bool _previewStale = true;
  bool _isPreviewLoading = false;
  int _previewRequestId = 0;
  List<CashShortageAllocation> _shortageAllocations = [];
  String? _allocationReason;
  bool _isSubmitting = false;
  List<ShortageAllocationCandidate> _shortageCandidates = [];
  bool _isLoadingCandidates = false;
  String? _candidatesError;
  int _candidateRequestId = 0;

  double? get countedCash => _countedCash;
  Map<String, dynamic>? get previewData => _previewData;
  bool get previewStale => _previewStale;
  bool get isPreviewLoading => _isPreviewLoading;
  int get previewRequestId => _previewRequestId;
  List<CashShortageAllocation> get shortageAllocations => _shortageAllocations;
  String? get allocationReason => _allocationReason;
  bool get isSubmitting => _isSubmitting;
  List<ShortageAllocationCandidate> get shortageCandidates =>
      _shortageCandidates;
  bool get isLoadingCandidates => _isLoadingCandidates;
  String? get candidatesError => _candidatesError;
  int get candidateRequestId => _candidateRequestId;

  String _computeInputFingerprint() {
    final aggList =
        _aggregators
            .map((a) => '${a.aggregatorId}:${a.amount.toStringAsFixed(2)}')
            .toList()
          ..sort();
    return '$_countedCash:${_totalSales.toStringAsFixed(2)}:${_cardPayments.toStringAsFixed(2)}:${(_declaredPendingIncomingCash ?? 0.0).toStringAsFixed(2)}:${aggList.join(',')}';
  }

  bool get canProceedToEndShift {
    if (_hasInvalidPendingIncomingCash) return false;
    if (_countedCash == null) return false;
    if (_previewStale || _previewData == null) return false;
    if (_isPreviewLoading || _isSubmitting) return false;

    final previewMap = (_previewData!['data'] is Map<String, dynamic>)
        ? _previewData!['data'] as Map<String, dynamic>
        : _previewData!;
    final allocationRequired = previewMap['allocation_required'] == true;
    final shortageToAllocate =
        (previewMap['shortage_to_allocate'] as num?)?.toDouble() ?? 0.0;

    if (allocationRequired && shortageToAllocate > 0) {
      if (_shortageAllocations.isEmpty) {
        return false;
      }
      final shortageHalalas = (shortageToAllocate * 100).round();
      final allocatedHalalas = _shortageAllocations.fold<int>(
        0,
        (sum, a) => sum + (a.amount * 100).round(),
      );
      if (allocatedHalalas != shortageHalalas) {
        return false;
      }
      for (final a in _shortageAllocations) {
        if (a.responsibleId.trim().isEmpty || (a.amount * 100).round() <= 0) {
          return false;
        }
        if (_shortageCandidates.isNotEmpty &&
            !_shortageCandidates.any(
              (c) => c.type == a.responsibleType && c.id == a.responsibleId,
            )) {
          return false;
        }
      }
    } else {
      if (_shortageAllocations.isNotEmpty) {
        return false;
      }
    }

    return true;
  }

  Map<String, dynamic>? get cashReconciliation {
    if (_previewData == null) return null;
    final previewMap = (_previewData!['data'] is Map<String, dynamic>)
        ? _previewData!['data'] as Map<String, dynamic>
        : _previewData!;
    return previewMap['cash_reconciliation'] as Map<String, dynamic>?;
  }

  double? get expectedCash {
    final val = cashReconciliation?['expected_cash'];
    if (val is num) return val.toDouble();
    if (val != null) return double.tryParse(val.toString());
    return null;
  }

  double? get previewCountedCash {
    final val = cashReconciliation?['counted_cash'];
    if (val is num) return val.toDouble();
    if (val != null) return double.tryParse(val.toString());
    return _countedCash;
  }

  double? get cashVariance {
    final val = cashReconciliation?['cash_variance'];
    if (val is num) return val.toDouble();
    if (val != null) return double.tryParse(val.toString());
    return null;
  }

  String? get cashVarianceType {
    return cashReconciliation?['cash_variance_type']?.toString();
  }

  double? get confirmedOpeningCash {
    final val = cashReconciliation?['confirmed_opening_cash'];
    if (val is num) return val.toDouble();
    if (val != null) return double.tryParse(val.toString());
    return null;
  }

  double? _declaredPendingIncomingCash;
  bool _hasInvalidPendingIncomingCash = false;
  double get declaredPendingIncomingCash => _declaredPendingIncomingCash ?? 0.0;
  bool get hasInvalidPendingIncomingCash => _hasInvalidPendingIncomingCash;

  void setPendingIncomingCash(double? value, {bool isInvalid = false}) {
    if (_declaredPendingIncomingCash != value || _hasInvalidPendingIncomingCash != isInvalid) {
      _declaredPendingIncomingCash = value;
      _hasInvalidPendingIncomingCash = isInvalid;
      invalidatePreview();
    }
  }

  double? get pendingIncomingCash {
    final val = cashReconciliation?['pending_incoming_cash'];
    if (val is num) return val.toDouble();
    if (val != null) return double.tryParse(val.toString());
    return _declaredPendingIncomingCash;
  }

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
    _previewRequestId++;
    _candidateRequestId++;
    _previewData = null;
    _previewStale = true;
    _isPreviewLoading = false;
    _shortageAllocations = [];
    _shortageCandidates = [];
    _isLoadingCandidates = false;
    _candidatesError = null;
    emit(EndShiftPreviewInvalidated());
  }

  void _pruneStaleAllocations() {
    if (_shortageAllocations.isEmpty) return;
    _shortageAllocations.removeWhere((alloc) {
      return !_shortageCandidates.any(
        (c) => c.type == alloc.responsibleType && c.id == alloc.responsibleId,
      );
    });
  }

  void updateShortageAllocations(
    List<CashShortageAllocation> allocations, [
    String? reason,
  ]) {
    if (_shortageCandidates.isNotEmpty) {
      _shortageAllocations = allocations.where((alloc) {
        return _shortageCandidates.any(
          (c) => c.type == alloc.responsibleType && c.id == alloc.responsibleId,
        );
      }).toList();
    } else {
      _shortageAllocations = allocations;
    }
    if (reason != null) _allocationReason = reason;
    emit(EndShiftAllocationsUpdated(allocations: _shortageAllocations));
  }

  Future<void> fetchShortageCandidates() async {
    _candidateRequestId++;
    final currentCandidateId = _candidateRequestId;
    final currentShiftId = shiftId;

    _isLoadingCandidates = true;
    _candidatesError = null;
    emit(EndShiftCandidatesLoading(varianceStrategy: state.varianceStrategy));

    final result = await _repository.getShortageAllocationCandidates(
      shiftId: shiftId,
    );

    // Drop out-of-order, stale, or invalidated responses
    if (currentCandidateId != _candidateRequestId ||
        currentShiftId != shiftId) {
      _isLoadingCandidates = false;
      return;
    }

    _isLoadingCandidates = false;

    handle(
      result,
      success: (candidates) {
        final validCandidates = candidates.where((c) => c.isValid).toList();
        _shortageCandidates = validCandidates;
        _candidatesError = null;
        _pruneStaleAllocations();

        emit(
          EndShiftCandidatesSuccess(
            validCandidates,
            varianceStrategy: state.varianceStrategy,
          ),
        );
      },
      failure: (failure) {
        _shortageCandidates = [];
        _candidatesError = failure.error.message;
        _pruneStaleAllocations();
        emit(
          EndShiftCandidatesFailure(
            failure,
            varianceStrategy: state.varianceStrategy,
          ),
        );
      },
    );
  }

  Future<bool> fetchCashReconciliationPreview() async {
    if (_hasInvalidPendingIncomingCash) {
      emit(
        EndShiftPreviewFailure(
          _createValidationFailure('القيمة المدخلة في النقد المعلق غير صالحة'),
        ),
      );
      return false;
    }
    if (_countedCash == null) {
      emit(
        EndShiftPreviewFailure(
          _createValidationFailure(
            S().followupCountedCashIsRequiredForReconciliationPreview,
          ),
        ),
      );
      return false;
    }

    if ((_declaredPendingIncomingCash ?? 0.0) > (_countedCash ?? 0.0)) {
      emit(
        EndShiftPreviewFailure(
          _createValidationFailure(
            'النقد الوارد المعلق لا يمكن أن يتجاوز النقد الفعلي المعدود بالدرج',
          ),
        ),
      );
      return false;
    }

    _previewRequestId++;
    final currentRequestId = _previewRequestId;
    final currentFingerprint = _computeInputFingerprint();

    _isPreviewLoading = true;
    emit(EndShiftPreviewLoading());

    final result = await _repository.previewCashReconciliation(
      shiftId: shiftId,
      totalSales: _totalSales,
      countedCash: _countedCash!,
      cardPayments: _cardPayments,
      pendingIncomingCash: _declaredPendingIncomingCash,
      aggregators: _aggregators
          .map((a) => EndShiftAggregatorModel.fromEntity(a))
          .toList(),
    );

    // If an invalidation or newer request occurred while in-flight, discard response
    if (currentRequestId != _previewRequestId ||
        currentFingerprint != _computeInputFingerprint()) {
      return false;
    }

    _isPreviewLoading = false;
    bool isSuccess = false;
    bool shouldFetchCandidates = false;

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
                    previewMap['shortage_to_allocate']?.toString() ?? '0',
                  ) ??
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
        isSuccess = true;

        if (allocationRequired && shortageToAllocate > 0) {
          shouldFetchCandidates = true;
        }
      },
      failure: (f) {
        _previewData = null;
        _previewStale = true;
        emit(EndShiftPreviewFailure(f));
        isSuccess = false;
      },
    );

    if (shouldFetchCandidates) {
      await fetchShortageCandidates();
    }

    return isSuccess;
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

  static double? tryParseFinancialAmount(String? text) {
    if (text == null) return null;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final sanitized = trimmed
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9')
        .replaceAll('۰', '0')
        .replaceAll('۱', '1')
        .replaceAll('۲', '2')
        .replaceAll('۳', '3')
        .replaceAll('۴', '4')
        .replaceAll('۵', '5')
        .replaceAll('۶', '6')
        .replaceAll('۷', '7')
        .replaceAll('۸', '8')
        .replaceAll('۹', '9')
        .replaceAll('٫', '.')
        .replaceAll('،', '')
        .replaceAll('٬', '')
        .replaceAll('\u066C', '')
        .replaceAll(',', '');
    final parsed = double.tryParse(sanitized);
    if (parsed == null || parsed < 0) return null;
    return parsed;
  }

  static double _parseFinancialAmount(String text) {
    return tryParseFinancialAmount(text) ?? 0.0;
  }

  String calculateNetSales(String totalSalesText) {
    final totalSales = _parseFinancialAmount(totalSalesText);
    final netSales = totalSales / 1.15;
    return netSales.toStringAsFixed(2);
  }

  String calculateNetVal(String totalSalesText) {
    final totalSales = _parseFinancialAmount(totalSalesText);
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
      return 0;
    }
    if (totalSales > (calculatedMethodsTotal)) {
      return totalSales - (calculatedMethodsTotal);
    } else if (totalSales < (calculatedMethodsTotal)) {
      return (calculatedMethodsTotal) - totalSales;
    }

    return 0;
  }

  set varianceAmount(double value) {}

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
          _createValidationFailure(
            S().followupCountedCashIsRequiredBeforeEndingShift,
          ),
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
      final shortageHalalas = (shortageToAllocate * 100).round();
      final allocatedHalalas = _shortageAllocations.fold<int>(
        0,
        (sum, a) => sum + (a.amount * 100).round(),
      );
      if (allocatedHalalas != shortageHalalas) {
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
            _createValidationFailure(
              'Allocations are only accepted for a shortage.',
            ),
          ),
        );
        return;
      }
    }

    if (_hasInvalidPendingIncomingCash) {
      emit(
        EndShiftFailure(
          _createValidationFailure('القيمة المدخلة في النقد المعلق غير صالحة'),
        ),
      );
      return;
    }

    if ((_declaredPendingIncomingCash ?? 0.0) > (_countedCash ?? 0.0)) {
      emit(
        EndShiftFailure(
          _createValidationFailure(
            'النقد الوارد المعلق لا يمكن أن يتجاوز النقد الفعلي المعدود بالدرج',
          ),
        ),
      );
      return;
    }

    _isSubmitting = true;
    emit(EndShiftLoading(varianceStrategy: state.varianceStrategy));

    final request = EndShiftRequest(
      totalSales: _totalSales,
      cashCollected: _cashCollected,
      cardPayments: _cardPayments,
      countedCash: _countedCash!,
      pendingIncomingCash: _declaredPendingIncomingCash,
      shortageAllocations: _shortageAllocations,
      allocationReason: _allocationReason,
      aggregators: _aggregators
          .map((a) => EndShiftAggregatorModel.fromEntity(a))
          .toList(),
      posReceipt: _posReceipt,
      isThereVariance: isThereVariance,
      variance: variance,
    );

    final result = await runUserIntent(
      'end:$shiftId:${request.countedCash}:${request.totalSales}:${request.cashCollected}:${request.cardPayments}:${request.pendingIncomingCash ?? 0.0}',
      () => _repository.endShift(shiftId: shiftId, endShiftRequest: request),
    );

    _isSubmitting = false;
    if (result == null) {
      emit(
        EndShiftFailure(
          _createValidationFailure(
            'The previous submission has an unknown outcome. Refresh and verify its status before submitting again.',
          ),
        ),
      );
      return;
    }
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
          _createValidationFailure(
            S().followupCountedCashIsRequiredBeforeEndingShift,
          ),
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
      final shortageHalalas = (shortageToAllocate * 100).round();
      final allocatedHalalas = _shortageAllocations.fold<int>(
        0,
        (sum, a) => sum + (a.amount * 100).round(),
      );
      if (allocatedHalalas != shortageHalalas) {
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
            _createValidationFailure(
              'Allocations are only accepted for a shortage.',
            ),
          ),
        );
        return;
      }
    }

    if (_hasInvalidPendingIncomingCash) {
      emit(
        EndShiftFailure(
          _createValidationFailure('القيمة المدخلة في النقد المعلق غير صالحة'),
        ),
      );
      return;
    }

    if ((_declaredPendingIncomingCash ?? 0.0) > (_countedCash ?? 0.0)) {
      emit(
        EndShiftFailure(
          _createValidationFailure(
            'النقد الوارد المعلق لا يمكن أن يتجاوز النقد الفعلي المعدود بالدرج',
          ),
        ),
      );
      return;
    }

    _isSubmitting = true;
    emit(EndShiftLoading(varianceStrategy: state.varianceStrategy));

    // Bind physical count, allocations and allocation reason to the handover request

    final boundRequest = EndShiftRequestWithHandOver(
      totalSales: request.totalSales,
      cashCollected: request.cashCollected,
      cardPayments: request.cardPayments,
      countedCash: _countedCash!,
      pendingIncomingCash: _declaredPendingIncomingCash,
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

    final result = await runUserIntent(
      'end-with-handover:$shiftId:${boundRequest.countedCash}:${boundRequest.nextCashierId}:${boundRequest.handoverAmount}:${boundRequest.totalSales}:${boundRequest.pendingIncomingCash ?? 0.0}',
      () => _repository.endShiftWithHandOver(shiftId, boundRequest),
    );

    _isSubmitting = false;
    if (result == null) {
      emit(
        EndShiftFailure(
          _createValidationFailure(
            'The previous submission has an unknown outcome. Refresh and verify its status before submitting again.',
          ),
        ),
      );
      return;
    }
    handle(
      result,
      success: (_) => emit(EndShiftSuccess()),
      failure: (f) => emit(EndShiftFailure(f)),
    );
  }
}
