import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/strategies/requests_order_type_strategy.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_orders_response.dart';

class SupplierDetailsScreenProductDetailsSection extends StatelessWidget {
  final List<SupplierOrderItem> items;
  final String orderId;

  const SupplierDetailsScreenProductDetailsSection({
    super.key,
    required this.items,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        final productUnit = product.productUnit;

        return Container(
          decoration: BoxDecoration(
            color: context.customColor.text2,
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
                      product.productName,
                      style: AppStyles.s14W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  product.status.buildStatus(context),
                ],
              ),
              8.verticalSpace,
              _buildDiv(context),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.requestedQty,
                '${product.orderedQuantity} $productUnit',
              ),
              product.status.buildStatusItem(
                context,
                quantityConfirmed: product.quantityConfirmed.toInt(),
                requestedQty: product.orderedQuantity.toInt(),
              ),
              8.verticalSpace,
              _buildDiv(context),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.quality,
                product.qualityLevel.getString(context),
              ),
              8.verticalSpace,
              _buildDiv(context),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.price,
                '${product.unitPrice} / $productUnit',
                showCurrencySymbol: true,
              ),
              8.verticalSpace,
              _buildDiv(context),
              8.verticalSpace,
              _buildDetailRow(
                context,
                context.tr.totalAmount,
                '${product.totalPrice}',
                showCurrencySymbol: true,
              ),
              8.verticalSpace,
              _buildDiv(context),
              8.verticalSpace,
              SupplierItemRequestTypeStrategy(
                product.status,
                item: product,
                orderId: orderId,
              ).buildButtonsItem(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
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
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildDiv(BuildContext context) {
    return CustomDivider(color: context.customColor.border);
  }
}
