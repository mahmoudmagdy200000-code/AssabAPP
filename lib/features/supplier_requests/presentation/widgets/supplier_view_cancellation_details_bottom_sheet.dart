import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:flutter/material.dart';

import '../../data/models/supplier_orders_response.dart';
import 'supplier_item_preview_widget.dart';

class SupplierViewCancellationDetailsBottomSheet extends StatelessWidget {
  final SupplierOrderItem item;

  const SupplierViewCancellationDetailsBottomSheet({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item canceled by Branch.',
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            8.verticalSpace,
            Text(
              'This item was canceled before it was approved or confirmed by you. As a result, it has been voided and will not be processed further.',
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            8.verticalSpace,
            const SupplierItemPreviewWidget(itemName: 'Fresh Beef (200 kg)'),
            8.verticalSpace,
            const CustomDivider(),
            8.verticalSpace,
            const RejectedWidget(),
          ],
        ),
      ),
    );
  }
}
