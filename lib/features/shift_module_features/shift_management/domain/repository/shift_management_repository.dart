import '../../../../../core/utils/future_api_result.dart';
import '../../data/model/shift/end_shift_aggregator_model.dart';

abstract class ShiftManagementRepository {
  FutureApiResult<Map<String, dynamic>> previewCashReconciliation({
    required String shiftId,
    required double totalSales,
    required double countedCash,
    double? cardPayments,
    List<EndShiftAggregatorModel>? aggregators,
  });
}
