import 'package:assab/core/enums/shift_status/shift_status.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../../core/extensions/number_extensions.dart';
import '../shift_tab_views/filtered_shifts_view.dart';
import 'cashier_shifts_search_app_bar.dart';

class CashierShiftsSearchResultWidget extends StatelessWidget {
  const CashierShiftsSearchResultWidget({
    super.key,
    this.isFromFilter = false,
    this.dateFilter,
    this.statusFilter,
    this.managerIdFilter,
    required this.cashierId,
  });

  final bool isFromFilter;
  final String? dateFilter;
  final ShiftStatus? statusFilter;
  final String? managerIdFilter;
  final String cashierId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Container(
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          children: [
            CashierShiftsSearchAppBar(cashierId: cashierId),
            10.verticalSpace,
            CashierFilteredShiftsView(
              // isFromFilter: isFromFilter,
              dateFilter: dateFilter,
              filterStatus: statusFilter,
              managerId: managerIdFilter,
            ),
          ],
        ),
      ),
    );
  }
}
