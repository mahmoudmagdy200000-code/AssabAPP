import '../../../../../core/utils/future_api_result.dart';
import '../../data/model/shift/end_shift_aggregator_model.dart';
import '../../data/model/shift/shortage_allocation_candidate.dart';

abstract class ShiftManagementRepository {
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    double? pendingIncomingCash,
    List<EndShiftAggregatorModel>? aggregators,
  });

  FutureApiResult<List<ShortageAllocationCandidate>> getShortageAllocationCandidates({
    required String shiftId,
  });
}
