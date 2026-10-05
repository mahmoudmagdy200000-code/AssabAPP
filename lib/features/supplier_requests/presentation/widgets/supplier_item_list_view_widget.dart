import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../../purchase/presentation/widgets/custom_svg_button.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/supplier_items_response.dart';

class SupplierItemListViewWidget extends StatelessWidget {
  final SupplierItem item;
  final ValueNotifier<Map<SupplierItem, int>> itemCountNotifier;

  const SupplierItemListViewWidget({
    super.key,
    required this.item,
    required this.itemCountNotifier,
  });

  void _incrementItem(BuildContext context) {
    final newMap = Map<SupplierItem, int>.from(itemCountNotifier.value);

    newMap[item] = (newMap[item] ?? 0) + 1;

    itemCountNotifier.value = newMap;

    _validateItems(context);
  }

  void _decrementItem(BuildContext context) {
    final newMap = Map<SupplierItem, int>.from(itemCountNotifier.value);

    final current = (newMap[item] ?? 1) - 1;

    if (current <= 0) {
      newMap.remove(item);
    } else {
      newMap[item] = current;
    }

    itemCountNotifier.value = newMap;

    _validateItems(context);
  }

  void _validateItems(BuildContext context) {
    context.read<ValidationCubit>().validateField(
      'items',
      itemCountNotifier.value.isNotEmpty,
    );
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
      margin: EdgeInsets.only(bottom: 8.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PurchaseItemImage(image: item.item.logoUrl),
          10.horizontalSpace,
          Expanded(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.item.name} (${item.item.unit})',
                              style: AppStyles.s14W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            Text(
                              item.item.code,
                              style: AppStyles.s10W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      15.horizontalSpace,
                      ValueListenableBuilder(
                        valueListenable: itemCountNotifier,
                        builder: (context, value, child) {
                          final hasAnySelected = value.isNotEmpty;
                          final isThisItemSelected = value.containsKey(item);

                          final isAddDisabled =
                              hasAnySelected && !isThisItemSelected;

                          return AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if ((value[item] ?? 0) > 0) ...[
                                  CustomSvgButton(
                                    assetName: AppAssets.minus,
                                    onTap: () => _decrementItem(context),
                                  ),
                                  12.horizontalSpace,
                                  Text(
                                    '${value[item]}',
                                    style: AppStyles.s12W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ],
                                12.horizontalSpace,
                                CustomSvgButton(
                                  assetName: AppAssets.add,
                                  onTap: isAddDisabled
                                      ? () {}
                                      : () => _incrementItem(context),
                                  backgroundColor: isAddDisabled
                                      ? context.customColor.text2
                                      : context.theme.primaryColor,
                                  iconColor: isAddDisabled
                                      ? context.customColor.text3
                                      : context.customColor.reversedTextColor,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ValueListenableBuilder(
                    valueListenable: itemCountNotifier,
                    builder: (context, value, child) {
                      if ((value[item] ?? 0) <= 0) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          8.verticalSpace,
                          const CustomDivider(),
                          8.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${context.tr.rate} = ${item.unitPrice} /kg',
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              Text(
                                '=',
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              5.horizontalSpace,
                              SaudiRiyalSvgWidget(
                                size: 15.r,
                                color: context.customColor.text3,
                              ),
                              5.horizontalSpace,
                              Text(
                                ((double.tryParse(item.unitPrice) ?? 0) *
                                        (value[item] ?? 0))
                                    .toStringAsFixed(2),
                                style: AppStyles.s13W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
