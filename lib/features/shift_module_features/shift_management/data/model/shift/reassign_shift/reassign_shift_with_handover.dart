import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/end_shift_aggregator_entity.dart';
import 'package:dio/dio.dart';

import '../variance_model.dart';

class ReassignShiftRequestWithHandOverRequest {
  final double totalSales;
  final double cashCollected;
  final double cardPayments;

  final String? nextCashierId;
  final double? handoverAmount;
  final List<TotalSalesAggregatorEntity> aggregators;
  final Variance variance;
  final bool isThereVariance;
  final double? varianceAmount;
  ReassignShiftRequestWithHandOverRequest({
    required this.totalSales,
    required this.cashCollected,
    required this.cardPayments,
    required this.nextCashierId,
    required this.handoverAmount,
    required this.aggregators,
    required this.variance,
    required this.isThereVariance,
    this.varianceAmount,
  });

  Future<FormData> toFormData() async {
    final formMap = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty) {
        formMap[key] = value;
      }
    }

    void addIfNotNullAndNotZero(String key, dynamic value) {
      if (value != null && value.toString().isNotEmpty && value != 0) {
        formMap[key] = value;
      }
    }

    // قيم أساسية
    addIfNotNull('current_sales', totalSales);
    addIfNotNullAndNotZero('cash_collected', cashCollected);
    addIfNotNullAndNotZero('card_payments', cardPayments);
    addIfNotNull('new_cashier_id', nextCashierId);
    addIfNotNull('handover_amount', handoverAmount);

    // Aggregators
    for (int i = 0; i < aggregators.length; i++) {
      final agg = aggregators[i];
      addIfNotNull('aggregators[$i][aggregator_id]', agg.aggregatorId);
      addIfNotNull('aggregators[$i][amount]', agg.amount);
      addIfNotNull('aggregators[$i][notes]', agg.notes);
    }

    if (isThereVariance) {
      // Variance
      addIfNotNull(
        'variance[responsibility_type]',
        variance.responsibilityType,
      );
      addIfNotNullAndNotZero(
        'variance[current_cashier_amount]',
        variance.currentCashierAmount,
      );
      addIfNotNull('variance[reason]', variance.reason);

      // Other cashiers
      for (int i = 0; i < variance.otherCashiers.length; i++) {
        final oc = variance.otherCashiers[i];
        addIfNotNull('variance[other_cashiers][$i][cashier_id]', oc.cashierId);
        addIfNotNull('variance[other_cashiers][$i][amount]', oc.amount);
      }

      // Supporting files
      for (int i = 0; i < variance.supportingFiles.length; i++) {
        final file = variance.supportingFiles[i];
        if (file != null) {
          formMap['variance[supporting_files][$i]'] =
              await MultipartFile.fromFile(file.path);
        }
      }
    }
    return FormData.fromMap(formMap);
  }

  /// ✅ Manual Form Data Mapping (Not using toJson)
  // FormData toFormData() {
  //   final formMap = <String, dynamic>{
  //     "total_sales": totalSales.toString(),
  //     "cash_collected": cashCollected.toString(),
  //     "card_payments": cardPayments.toString(),
  //     "next_cashier_id": nextCashierId.toString(),
  //     "handover_amount": handoverAmount.toString(),
  //     "handover_notes": handoverNotes,
  //   };
  //
  //   if (posReceipt != null) {
  //     formMap["pos_receipt"] = posReceipt;
  //   }
  //
  //   // Aggregators
  //   for (int i = 0; i < aggregators.length; i++) {
  //     formMap["aggregators[$i][aggregator_id]"] =
  //         aggregators[i].aggregatorId.toString();
  //     formMap["aggregators[$i][amount]"] = aggregators[i].amount.toString();
  //     formMap["aggregators[$i][notes]"] = aggregators[i].notes;
  //   }
  //
  //   // Variance (simple fields)
  //   formMap["variance[responsibility_type]"] = variance.responsibilityType;
  //   formMap["variance[current_cashier_amount]"] =
  //       variance.currentCashierAmount.toString();
  //   formMap["variance[reason]"] = variance.reason;
  //
  //   // Variance other cashiers
  //   for (int i = 0; i < variance.otherCashiers.length; i++) {
  //     formMap["variance[other_cashiers][$i][cashier_id]"] =
  //         variance.otherCashiers[i].cashierId.toString();
  //     formMap["variance[other_cashiers][$i][amount]"] =
  //         variance.otherCashiers[i].amount.toString();
  //   }
  //
  //   // Variance supporting files
  //   for (int i = 0; i < variance.supportingFiles.length; i++) {
  //     if (variance.supportingFiles[i] != null) {
  //       formMap["variance[supporting_files][$i]"] = variance.supportingFiles[i];
  //     }
  //   }
  //
  //   return FormData.fromMap(formMap);
  // }
}
