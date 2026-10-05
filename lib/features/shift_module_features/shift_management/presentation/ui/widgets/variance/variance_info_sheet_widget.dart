import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/variance/variance_icons_info_details.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/extensions/build_context_extensions.dart';
import '../../../../../../../core/extensions/number_extensions.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';

class VarianceInfoSheetWidget extends StatelessWidget {
  const VarianceInfoSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        top: 15.h,
        bottom: 55.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.varianceType,
              style: AppStyles.s18W600.copyWith(color: AppColors.primaryLight),
            ),

            10.verticalSpace,
            Text(
              context.tr.varianceInfoDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text4,
              ),
            ),

            15.verticalSpace,
            const CustomDivider(),
            15.verticalSpace,

            VarianceIconsInfoDetails(
              svgAsset: AppAssets.over,
              title: context.tr.over,
              richTextFirstPart: context.tr.thisMeansThe,
              richTextSecondStyledPart: context.tr.cashOrPaymentHandedOver,
              richTextThirdPart: context.tr.areMoreThanTheRecordedSales,
              isolatedDesc: context.tr.itCouldBeDueToManualEntryErrors,
            ),

            15.verticalSpace,
            const CustomDivider(),
            15.verticalSpace,

            VarianceIconsInfoDetails(
              svgAsset: AppAssets.short,
              title: context.tr.short,
              richTextFirstPart: context.tr.thisMeansThe,
              richTextSecondStyledPart: context.tr.cashOrPaymentHandedOver,
              richTextThirdPart: context.tr.areLessThanTheRecordedSales,
              isolatedDesc: context
                  .tr
                  .possibleCausesIncludeMissingCashIncorrectEntriesUnprocessedRefunds,
            ),
          ],
        ),
      ),
    );
  }
}
