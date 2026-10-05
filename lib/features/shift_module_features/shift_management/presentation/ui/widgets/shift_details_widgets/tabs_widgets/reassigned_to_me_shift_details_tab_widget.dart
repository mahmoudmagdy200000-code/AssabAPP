import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_time_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/mappers/assigned_by_ui_mapper.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/shift_details_widgets/shift_details_container_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../domain/entity/shift/shift_entity.dart';
import '../../../../../domain/enums/user_type.dart';
import '../../../arguments/shift_arguments.dart';
import '../shift_details_row_widget.dart';
import 'shift_tab_widget_strategy.dart';

class ReassignedToMeShiftDetailsTabWidget implements ShiftTabStrategy {
  @override
  Widget buildTabContent(
    BuildContext context, {
    required ShiftEntity shift,
    ShiftArguments? shiftArguments,
  }) {
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
            title: context.tr.reassigned_from,
            value: shift.reassignedFrom ?? context.tr.no_name,
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.reassigned_to,
            value: shift.reassignedTo ?? context.tr.no_name,
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.reassigned_by,
            valueWidget:
                shift.shiftInfoDetails?.assignedBy?.userType.name ==
                    UserType.manager.name
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        shift.shiftInfoDetails?.assignedBy?.name ?? 'N/A',
                        style: AppStyles.s13W500,
                      ),
                      Text(
                        '(${shift.shiftInfoDetails?.assignedBy?.userType.label(context)})',
                        style: AppStyles.s13W500,
                      ),
                    ],
                  )
                : Text(
                    shift.shiftInfoDetails?.assignedBy?.name ??
                        context.tr.no_name,
                    style: AppStyles.s13W500,
                    textAlign: TextAlign.center,
                  ),
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.storeBranch,
            value: shift.shiftInfoDetails?.branchName ?? context.tr.no_name,
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.branchStoreSvg,
            title: context.tr.storeBranch,
            value: shift.shiftInfoDetails?.branchName ?? 'N/A',
          ),

          if (shift.reassignReason?.isNotEmpty ?? false) ...[
            const CustomDivider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withAlpha(10),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryLight,
                    size: 20.w,
                  ),
                  10.horizontalSpace,

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.reassignmentReason,
                          textAlign: TextAlign.center,
                          style: AppStyles.s14W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),

                        Text(
                          shift.reassignReason!,
                          textAlign: TextAlign.center,
                          style: AppStyles.s13W400.copyWith(
                            color: context.customColor.text4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const CustomDivider(),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.calendar,
            title: context.tr.shiftDateTitle,
            value: shift.shiftDateFormatted,
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.clockSvg,
            title: context.tr.start_time,
            value: shift.shiftTimeDetails.formattedStartTime,
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.clockSvg,
            title: context.tr.end_time,
            value: shift.shiftTimeDetails.formattedEndTime,
          ),

          ShiftDetailsRowWidget(
            iconSVGAsset: AppAssets.personSvg,
            title: context.tr.next_cashier,
            value: shift.nextCashier?.name ?? context.tr.no_name,
          ),
        ],
      ),
    );
  }
}
