import 'dart:io';

import 'package:assab/features/shift_module_features/shift_management/data/model/shift/variance_model.dart';
import 'package:dio/dio.dart';

import 'end_shift_aggregator_model.dart';

class EndShiftRequest {
  final double totalSales;

  final double cashCollected;

  final double cardPayments;

  final File? posReceipt;

  final List<EndShiftAggregatorModel> aggregators;

  final Variance variance;

  final bool isThereVariance;

  EndShiftRequest({
    required this.totalSales,
    required this.cashCollected,
    required this.cardPayments,
    required this.aggregators,
    required this.variance,
    required this.isThereVariance,
    this.posReceipt,
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

    addIfNotNull('total_sales', totalSales);
    addIfNotNullAndNotZero('cash_collected', cashCollected);
    addIfNotNullAndNotZero('card_payments', cardPayments);

    if (posReceipt != null) {
      formMap['pos_receipt'] = await MultipartFile.fromFile(posReceipt!.path);
    }

    // Aggregators
    for (int i = 0; i < aggregators.length; i++) {
      final agg = aggregators[i];
      addIfNotNull('aggregators[$i][aggregator_id]', agg.aggregatorId);
      addIfNotNull('aggregators[$i][amount]', agg.amount);
      addIfNotNull('aggregators[$i][notes]', agg.notes);
    }

    if (isThereVariance) {
      // Variance simple fields
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
}
