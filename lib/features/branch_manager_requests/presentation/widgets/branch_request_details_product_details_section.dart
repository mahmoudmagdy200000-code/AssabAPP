import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/order_details_response.dart';

class BranchRequestDetailsProductDetailsSection extends StatelessWidget {
  final List<OrderDetailsResponseProductDetails> productDetails;

  const BranchRequestDetailsProductDetailsSection({
    super.key,
    required this.productDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: productDetails.length,
      itemBuilder: (context, index) {
        final product = productDetails[index];

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
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Text(
                      '${product.itemName} (${product.itemUnit})',
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
                '${product.requestedQty} ${product.itemUnit}',
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                '${context.tr.availableIn} ${product.availableInBranchName}',
                '${product.availableInQuantity} ${product.itemUnit}',
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.balanceAfter,
                '${product.balanceAfter} ${product.itemUnit}',
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.qualityGrade,
                product.qualityGrade,
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.expiryDate,
                product.expiryDate,
              ),
              8.verticalSpace,
              const CustomDivider(),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.coolingStatus,
                product.coolingStatus
                    ? context.tr.transferReady
                    : context.tr.notReady,
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
        Text(
          title,
          style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
        ),
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
