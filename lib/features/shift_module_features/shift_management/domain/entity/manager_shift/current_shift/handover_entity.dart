import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/handover_entity.dart';

class HandoverEntity {
  final num openingBalance;
  final num closingBalance;
  final num expectedBalance;
  final num variance;
  final String varianceType;
  final String? handedOverAt;
  final String? handoverNotes;
  final String? nextManager;
  final HandoverStatusEntity? handoverStatus;

  HandoverEntity({
    required this.openingBalance,
    required this.closingBalance,
    required this.expectedBalance,
    required this.variance,
    required this.varianceType,
    required this.handedOverAt,
    required this.handoverNotes,
    required this.nextManager,
    required this.handoverStatus,
  });
}
