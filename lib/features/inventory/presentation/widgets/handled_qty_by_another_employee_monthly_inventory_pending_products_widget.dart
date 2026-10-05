import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/monthly_inventory_pending_products_response.dart';

class HandledQtyByAnotherEmployeeMonthlyInventoryPendingProductsWidget
    extends StatelessWidget {
  final MonthlyInventoryPendingProduct product;

  const HandledQtyByAnotherEmployeeMonthlyInventoryPendingProductsWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.customColor.reversedTextColor,
          width: 2.r,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 16.r),
      margin: EdgeInsets.only(bottom: 4.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const PurchaseItemImage(),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        product.itemName,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              ProfileImageWidget(image: product.handledBy?.image),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          Row(
            children: [
              Text(
                product.handledBy?.name ?? '',
                style: AppStyles.s12W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
              Text(
                context.tr.isHandlingIt,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              const Spacer(),
              Text(
                '(${DateFormatter.timeAgo(DateTime.tryParse(product.lockedAt ?? ''))})',
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
