import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../data/models/compare_price_response.dart';

class ComparePriceBenefitsAnalysisSection extends StatelessWidget {
  final PurchaseComparePriceResponse comparePriceResponse;

  const ComparePriceBenefitsAnalysisSection({
    super.key,
    required this.comparePriceResponse,
  });

  double get _calculateSavings {
    return (((double.tryParse(
                  comparePriceResponse.data.sources.directSupplier?.price ??
                      '0',
                ) ??
                0) -
            (double.tryParse(
                  comparePriceResponse
                          .data
                          .sources
                          .viaPurchasingOfficer
                          ?.price ??
                      '0',
                ) ??
                0)))
        .abs();
  }

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
            '${context.tr.benefitsAnalysis}:',
            style: AppStyles.s16W600.copyWith(color: context.customColor.text1),
          ),
          6.verticalSpace,
          Row(
            children: [
              AppSvg(assetName: AppAssets.personSvg, width: 14.w, height: 14.w),
              10.horizontalSpace,
              Text(
                '${context.tr.orderingViaBrandManager}:',
                style: AppStyles.s14W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
          6.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: context.customColor.border),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                _buildBenefitsAnalysis(
                  context,
                  'Save ${_calculateSavings.toStringAsFixed(2)} SAR (3 SAR/${comparePriceResponse.data.itemUnit})',
                ),
                const CustomDivider(),
                _buildBenefitsAnalysis(
                  context,
                  context.tr.guaranteedHighQuality,
                ),
                const CustomDivider(),
                _buildBenefitsAnalysis(
                  context,
                  context.tr.trustedAndStableRelationship,
                ),
                const CustomDivider(),
                _buildBenefitsAnalysis(
                  context,
                  context.tr.prioritySupplyAccess,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsAnalysis(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          AppSvg(assetName: AppAssets.review, width: 14.w, height: 14.w),
          5.horizontalSpace,
          Text(
            text,
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
        ],
      ),
    );
  }
}
