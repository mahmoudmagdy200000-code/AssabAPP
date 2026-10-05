import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/cashier_shifts_management_widgets/shift_card_widgets/shift_card_factory.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../domain/entity/shift/shift_entity.dart';

class ShiftsListView extends StatelessWidget {
  final List<ShiftEntity> shifts;
  final ScrollController controller;
  final ShiftStatus shiftStatusSelectedOption;
  final Future<void> Function() onRefresh;

  const ShiftsListView({
    super.key,
    required this.shifts,
    required this.controller,
    required this.shiftStatusSelectedOption,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller,
        itemCount: shifts.length,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),

        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsetsDirectional.only(bottom: 10.h),
            child: ShiftCardFactory.getStrategy(
              shifts[index].status,
              shiftStatusSelectedOption,
            ).buildCard(context, shifts[index]),
          );
        },
      ),
    );
  }
}
