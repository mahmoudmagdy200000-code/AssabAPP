import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';

class ReceiveOrderItemPreviewWidget extends StatelessWidget {
  final String itemName;
  final String? itemImageUrl;
  final Color? bgColor;

  const ReceiveOrderItemPreviewWidget({
    super.key,
    required this.itemName,
    this.itemImageUrl,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? context.customColor.text2,
        borderRadius: BorderRadius.circular(1000.r),
      ),
      child: Row(
        children: [
          PurchaseItemImage(
            bgColor: context.customColor.reversedTextColor,
            image: itemImageUrl,
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              itemName,
              style: AppStyles.s14W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
