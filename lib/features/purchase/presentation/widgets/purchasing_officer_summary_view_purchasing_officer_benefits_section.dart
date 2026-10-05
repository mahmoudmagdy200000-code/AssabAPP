import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';

class PurchasingOfficerSummaryViewPurchasingOfficerBenefitsSection
    extends StatelessWidget {
  final bool isSliver;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;

  const PurchasingOfficerSummaryViewPurchasingOfficerBenefitsSection({
    super.key,
    this.isSliver = true,
    this.padding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    if (isSliver) {
      return _buildBody(context).sliverBoxAdapter;
    } else {
      return _buildBody(context);
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: border ?? Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: padding ?? EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr.purchasingOfficerBenefits,
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          10.verticalSpace,
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: context.customColor.border),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                _buildDetailRow(context, context.tr.bulkDiscounts1020),
                const CustomDivider(),
                _buildDetailRow(
                  context,
                  context.tr.premiumTrustedSupplierRelations,
                ),
                const CustomDivider(),
                _buildDetailRow(
                  context,
                  context.tr.coordinatedDeliveryQualityAssurance,
                ),
                const CustomDivider(),
                _buildDetailRow(
                  context,
                  context.tr.prioritySupplyDuringShortages,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 19.r, horizontal: 12.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppSvg(
            assetName: AppAssets.checkWithContainer,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
            width: 14.w,
            height: 14.w,
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              title,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
