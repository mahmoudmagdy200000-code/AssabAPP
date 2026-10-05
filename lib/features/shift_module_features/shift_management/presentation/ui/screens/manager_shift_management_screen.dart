import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/manager_shift_management_widgets/manager_shift_management_bottom_section.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/styles/app_colors.dart';
import '../widgets/cashier_shifts_management_widgets/cashier_shifts_app_bar.dart';
import '../widgets/manager_shift_management_widgets/manager_shift_management_top_section.dart';

class ManagerShiftManagementScreen extends StatelessWidget {
  const ManagerShiftManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.lightGray,
      child: AppPaddingWidget(
        top: 10.h,
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          children: [
            CashierShiftsAppBar(
              title: context.tr.workDayManagement,
              subTitle: context.tr.myShiftAndHandOffDetails,
              showInfoButton: false,
              showBackButton: false,
            ),

            Expanded(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: const Column(
                  children: [
                    ManagerShiftManagementTopSection(),
                    Expanded(child: ManagerShiftManagementBottomSection()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
