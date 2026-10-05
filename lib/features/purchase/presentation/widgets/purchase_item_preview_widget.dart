import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import 'purchase_item_image.dart';

class PurchaseItemPreviewWidget extends StatelessWidget {
  final String? itemImage;
  final String? itemName;
  final int? itemQuantity;
  final double? itemPrice;
  final String? itemUnit;

  const PurchaseItemPreviewWidget({
    super.key,
    this.itemImage,
    this.itemName,
    this.itemQuantity,
    this.itemPrice,
    this.itemUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 16.r),
      child: Row(
        children: [
          PurchaseItemImage(image: itemImage),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName ?? '',
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${context.tr.totalAmount} =',
                      style: AppStyles.s11W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    2.horizontalSpace,
                    SaudiRiyalSvgWidget(
                      size: 15.r,
                      color: context.customColor.text3,
                    ),
                    2.horizontalSpace,
                    Text(
                      ((itemPrice ?? 0) * (itemQuantity ?? 0)).toString(),
                      style: AppStyles.s11W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.horizontalSpace,
          Text(
            '$itemQuantity $itemUnit',
            style: AppStyles.s12W500.copyWith(
              color: context.theme.primaryColor,
            ),
          ),
          6.horizontalSpace,
          Text(
            context.tr.qty,
            style: AppStyles.s10W500.copyWith(color: context.customColor.text3),
          ),
        ],
      ),
    );
  }
}
