import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/officer_order_details_response.dart';

class PurchasingOfficerRequestScreenProductDetailsSection
    extends StatelessWidget {
  final OfficerOrderDetailsResponse details;

  const PurchasingOfficerRequestScreenProductDetailsSection({
    super.key,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: details.productDetails.length,
      itemBuilder: (context, index) {
        final product = details.productDetails[index];
        final itemUnit = product.itemUnit;

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.all(16.r),
          margin: EdgeInsets.only(bottom: 12.r),
          child: Column(
            children: [
              Row(
                children: [
                  PurchaseItemImage(
                    bgColor: context.customColor.reversedTextColor,
                    image: product.itemLogo,
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      product.itemName,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.requestedQty,
                '${product.requestedQty} $itemUnit',
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(context, context.tr.quality, product.quality),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.preferredDelivery,
                DateFormatter.formatDateMDY(
                      DateTime.tryParse(product.preferredDeliveryDate),
                    ) ??
                    '',
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.latestDelivery,
                DateFormatter.formatDateMDY(
                      DateTime.tryParse(product.latestDeliveryDate),
                    ) ??
                    '',
              ),
              if (product.specialInstructions != null &&
                  product.specialInstructions!.isNotEmpty) ...[
                8.verticalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 12.r,
                        horizontal: 16.r,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.specialInstruction,
                                  style: AppStyles.s14W600.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              AppSvgButton(
                                assetName: AppAssets.edit,
                                onTap: () {},
                                withBorder: false,
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: context.customColor.text2.withValues(
                                alpha: 0.7,
                              ),
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                            padding: EdgeInsets.all(16.r),
                            child: Text(
                              product.specialInstructions!,
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              8.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
                child: Column(
                  children: [
                    Text(
                      context.tr.priceComparison,
                      style: AppStyles.s14W500.copyWith(
                        color: context.theme.primaryColor,
                      ),
                    ),
                    8.verticalSpace,
                    _buildPriceComparisonRow(
                      context,
                      context.tr.directSupplier,
                      '${product.priceComparison.directSupplierPriceSameItem} ${context.tr.sar}/${context.tr.pk}',
                    ),
                    6.verticalSpace,
                    const CustomDivider(),
                    6.verticalSpace,
                    _buildPriceComparisonRow(
                      context,
                      context.tr.viaPurchasingOfficer,
                      '${product.priceComparison.viaPurchasingOfficerSameItem} ${context.tr.sar}/${context.tr.pk}',
                    ),
                    6.verticalSpace,
                    const CustomDivider(),
                    6.verticalSpace,
                    _buildPriceComparisonRow(
                      context,
                      context.tr.savings,
                      '${(product.priceComparison.directSupplierPriceSameItem - product.priceComparison.viaPurchasingOfficerSameItem).abs()} ${context.tr.sar}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildPriceComparisonRow(
    BuildContext context,
    String title,
    String value, {
    bool showCurrencySymbol = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (showCurrencySymbol) const SaudiRiyalSvgWidget(),
        5.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
