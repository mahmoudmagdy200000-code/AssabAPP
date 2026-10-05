import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';

import '../../../../core/enums/purchase_sources_types.dart';
import '../../../../core/styles/app_styles.dart';
import '../../data/models/compare_price_response.dart';

class ComparePriceAdditionalFactorsSection extends StatelessWidget {
  final PurchaseComparePriceResponseFactors factors;

  const ComparePriceAdditionalFactorsSection({
    super.key,
    required this.factors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.tr.additionalFactors}:',
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          8.verticalSpace,
          _buildFactorRow(
            context,
            context.tr.bestCompliance,
            '${PurchaseSourcesTypes.formatSourceType(context, PurchaseSourcesTypes.fromValue(factors.bestCompliance?.sourceType ?? ''))}${factors.bestCompliance == null ? '' : ' (${factors.bestCompliance?.rate}%)'}',
          ),
          16.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildFactorRow(
            context,
            context.tr.fastestDelivery,
            PurchaseSourcesTypes.formatSourceType(
              context,
              PurchaseSourcesTypes.fromValue(
                factors.fastestDelivery?.sourceType ?? '',
              ),
            ),
          ),
          16.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildFactorRow(
            context,
            context.tr.lowestPrice,
            PurchaseSourcesTypes.formatSourceType(
              context,
              PurchaseSourcesTypes.fromValue(
                factors.lowestPrice?.sourceType ?? '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorRow(BuildContext context, String factor, String detail) {
    return Row(
      children: [
        Expanded(
          child: Text(
            factor,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Expanded(
          child: Text(
            detail,
            textAlign: TextAlign.end,
            style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
          ),
        ),
      ],
    );
  }
}
