import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/wasted_damage_items_response.dart';

class WastedDamageDetailsProductInfoSection extends StatelessWidget {
  final WastedDamageItemData? item;

  const WastedDamageDetailsProductInfoSection({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox.shrink();
    final data = item!;
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          Row(
            spacing: 12.w,
            children: [
              PurchaseItemImage(image: data.itemLogo),
              Text(
                data.itemName,
                style: AppStyles.s12W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),
            ],
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          Text(
            context.tr.productInformation,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text4),
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowItem(
            context: context,
            title: context.tr.availableInStock,
            value:
                '${data.availableInStock.toStringAsFixed(0)} ${data.itemUnit}',
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowItem(
            context: context,
            title: context.tr.pricePerUnit,
            value:
                '${data.pricePerUnit.toStringAsFixed(2)} SAR /${data.itemUnit}',
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowItem(
            context: context,
            title: context.tr.expirationDate,
            value: data.expirationDate != null
                ? DateFormatter.formatDateMDY(data.expirationDate) ?? '-'
                : '-',
          ),
          8.verticalSpace,
          const CustomDivider(),
          8.verticalSpace,
          _buildRowItem(
            context: context,
            title: context.tr.location,
            value: data.storageLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    return Row(
      spacing: 5.w,
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
}
