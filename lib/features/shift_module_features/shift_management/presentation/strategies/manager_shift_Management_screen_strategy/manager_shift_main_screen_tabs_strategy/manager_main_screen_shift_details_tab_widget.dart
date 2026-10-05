import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/manager_shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/progress_entity.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../ui/widgets/shift_details_widgets/shift_details_container_widget.dart';
import '../../../ui/widgets/shift_details_widgets/shift_details_row_widget.dart';
import 'manager_main_screen_tab_strategy.dart';

class ManagerMainScreenShiftDetailsTabWidget
    extends ManagerMainScreenTabStrategy {
  ManagerShiftEntity managerShift;
  ProgressEntity shiftProgress;
  ManagerMainScreenShiftDetailsTabWidget({
    required this.managerShift,
    required this.shiftProgress,
  });

  @override
  Widget buildTabContent(BuildContext context) {
    return ShiftDetailsContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.h,
        children: [
          Text(context.tr.shiftDetails, style: AppStyles.s14W600),

          Stack(
            alignment: AlignmentGeometry.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: double.maxFinite,
                height: 100.h,
                child: const AppSvg(assetName: AppAssets.noProfile),
              ),

              Container(
                width: 130.w,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: context.customColor.border,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvg(assetName: AppAssets.headCashierSvg, width: 15.w),

                    2.horizontalSpace,

                    Text(context.tr.headCashier, style: AppStyles.s13W400),
                  ],
                ),
              ),
            ],
          ),

          const CustomDivider(),
          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.assigned_to,
            value: context.tr.assignedToMeBranchManager,
            textAlign: TextAlign.end,
          ),

          const CustomDivider(),
          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.assigned_by,
            value: context.tr.shopOwner,
          ),

          const CustomDivider(),
          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.branchStoreSvg,
            title: context.tr.storeBranch,
            value: managerShift.shiftDetails.storeBranch,
          ),

          const CustomDivider(),
          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.clockSvg,
            title: context.tr.start_time,
            value: shiftProgress.formattedStartTime ?? 'N/A',
          ),

          const CustomDivider(),
          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.clockSvg,
            title: context.tr.end_time,
            value: shiftProgress.formattedEndTime ?? 'N/A',
          ),

          const CustomDivider(),
          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.finalApprovalBy,
            value: 'Name',
          ),
        ],
      ),
    );
  }
}
