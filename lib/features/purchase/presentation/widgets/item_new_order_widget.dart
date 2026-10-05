import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/strategies/purchase_source_strategy.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../data/models/purchase_branch_items_response.dart';
import 'order_source_bottom_sheet_widget.dart';

class ItemNewOrderWidget extends StatelessWidget {
  final PurchaseSourceStrategy strategy;
  final PurchaseBranchItemData item;
  final int quantity;
  final String sourceTypeFieldName;
  final String sourceIdFieldName;
  final String sourceNameFieldName;
  final String choosedSourceItemIdFieldName;
  final String addedItemMainId;

  const ItemNewOrderWidget({
    super.key,
    required this.strategy,
    required this.item,
    required this.quantity,
    required this.sourceTypeFieldName,
    required this.sourceIdFieldName,
    required this.sourceNameFieldName,
    required this.choosedSourceItemIdFieldName,
    required this.addedItemMainId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 16.r),
      child: Column(
        children: [
          Row(
            children: [
              PurchaseItemImage(image: item.itemLogo),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.itemName} (${item.itemUnit})',
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
                          (quantity * item.itemPrice).toString(),
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
                '$quantity ${context.tr.kg}',
                style: AppStyles.s12W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
              6.horizontalSpace,
              Text(
                context.tr.qty,
                style: AppStyles.s10W500.copyWith(
                  color: context.customColor.text3,
                ),
              ),
            ],
          ),
          6.verticalSpace,
          CustomDivider(
            color: context.customColor.text2.withValues(alpha: 0.4),
          ),
          6.verticalSpace,
          AppGestureDetectorButton(
            onTap: () {
              final validationCubit = context.read<ValidationCubit>();

              AppBottomSheet.show(context, (context) {
                return MultiBlocProvider(
                  providers: [BlocProvider.value(value: validationCubit)],
                  child: OrderSourceBottomSheetWidget(
                    item: item,
                    itemQuantity: quantity,
                    sourceTypeFieldName: sourceTypeFieldName,
                    sourceIdFieldName: sourceIdFieldName,
                    sourceNameFieldName: sourceNameFieldName,
                    choosedSourceItemIdFieldName: choosedSourceItemIdFieldName,
                    addedItemMainId: addedItemMainId,
                  ),
                );
              });
            },
            child: ContainerCustomTextField(
              borderColor: context.theme.primaryColor,
              child: Row(
                children: [
                  Expanded(
                    child: strategy.buildSource(
                      context,
                      sourceNameFieldName,
                      sourceTypeFieldName,
                    ),
                  ),
                  10.horizontalSpace,
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24.r,
                    color: context.theme.primaryColor,
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
