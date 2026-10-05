import 'package:assab/core/enums/wasted_problem_type_enum.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/enums/wasted_for_reason_enum.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../presentation/widgets/wasted_damage_details_cause_damage_section.dart';

abstract class WastedProblemTypeStrategy {
  WastedProblemTypeEnum get type;

  Widget buildDetailsSection(
    BuildContext context, {
    String? itemId,
    WastedDamageItemData? item,
  }) {
    return const SizedBox.shrink();
  }

  List<WastedForReasonEnum> get reasons;
}

class WasteProblemTypeStrategy extends WastedProblemTypeStrategy {
  @override
  WastedProblemTypeEnum get type => WastedProblemTypeEnum.waste;

  @override
  List<WastedForReasonEnum> get reasons => [
    WastedForReasonEnum.productionError,
    WastedForReasonEnum.portionHandlingIssue,
    WastedForReasonEnum.orderCancellation,
    WastedForReasonEnum.operationalMismanagement,
    WastedForReasonEnum.other,
  ];
}

class DamageProblemTypeStrategy extends WastedProblemTypeStrategy {
  @override
  WastedProblemTypeEnum get type => WastedProblemTypeEnum.damage;

  @override
  Widget buildDetailsSection(
    BuildContext context, {
    String? itemId,
    WastedDamageItemData? item,
  }) {
    return WastedDamageDetailsCauseDamageSection(itemId: itemId, item: item);
  }

  @override
  List<WastedForReasonEnum> get reasons => [
    WastedForReasonEnum.expiredProduct,
    WastedForReasonEnum.storageDamage,
    WastedForReasonEnum.supplierIssue,
    WastedForReasonEnum.equipmentFailure,
    WastedForReasonEnum.other,
  ];
}
