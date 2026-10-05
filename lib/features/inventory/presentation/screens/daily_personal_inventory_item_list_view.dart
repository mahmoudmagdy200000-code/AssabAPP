import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_logger.dart';
import 'package:assab/core/widgets/app_svg_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/container_custom_text_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/daily_inventory_items_response.dart';
import '../../data/models/inventory_slider_model.dart';
import '../widgets/daily_inventory_personal_add_note_section_list_view_item.dart';

class DailyPersonalInventoryItemListView extends StatelessWidget {
  final DailyInventoryItem item;
  final int index;
  final int length;

  const DailyPersonalInventoryItemListView({
    super.key,
    required this.item,
    required this.index,
    required this.length,
  });

  String get _quantityKey => 'quantity_${item.id}';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: index < length - 1 ? 10.r : 0),
      child: ContainerCustomTextField(
        label: context.tr.enterItemActualQuantity(item.itemName),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(1000.r),
              ),
              padding: EdgeInsets.all(4.r),
              child: Row(
                children: [
                  PurchaseItemImage(image: item.itemLogo),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: AppStyles.s12W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  5.horizontalSpace,
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.customColor.text4,
                    size: 20.r,
                  ),
                  5.horizontalSpace,
                ],
              ),
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr.quantity,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                20.horizontalSpace,
                Flexible(
                  child:
                      BlocSelector<
                        ValidationCubit,
                        ValidationState,
                        InventorySliderModel?
                      >(
                        selector: (state) =>
                            state.getTypedValue<InventorySliderModel>(
                              'inventorySliderModel_${item.id}',
                            ),
                        builder: (context, validationState) {
                          final total = validationState?.total ?? 0;

                          final percentage = validationState?.percentage ?? 0;

                          String result;

                          if (percentage == 100) {
                            result = '$total ${context.tr.full}';
                          } else if (percentage == 0) {
                            result = '${total - 1} ${context.tr.full}';
                          } else {
                            result =
                                '${total - 1} ${context.tr.full} + ${context.tr.one} $percentage% ${context.tr.full}';
                          }

                          return Row(
                            spacing: 10.w,
                            children: [
                              if (validationState != null)
                                AppSvgButton(
                                  assetName: AppAssets.refresh,
                                  onTap: () {
                                    context
                                        .read<ValidationCubit>()
                                        .validateFieldAndStoreTypedValue<
                                          InventorySliderModel?
                                        >(
                                          fieldName:
                                              'inventorySliderModel_${item.id}',
                                          value: null,
                                          isValid: true,
                                        );
                                  },
                                  iconSize: 12.r,
                                  padding: EdgeInsets.all(5.r),
                                ),
                              Flexible(
                                child: ContainerCustomTextField(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.r,
                                    vertical: 7.r,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: validationState != null
                                            ? Text(
                                                result,
                                                style: AppStyles.s12W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              )
                                            : CustomTextField(
                                                hintText: '0',
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  context
                                                      .read<ValidationCubit>()
                                                      .validateFieldAndStoreValue(
                                                        fieldName: _quantityKey,
                                                        value: value,
                                                        isValid:
                                                            value.isNotEmpty,
                                                      );
                                                },
                                              ),
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        '/${item.itemUnit}',
                                        style: AppStyles.s10W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      ),
                                      3.horizontalSpace,
                                      AppSvg(
                                        assetName: AppAssets.edit,
                                        width: 10.w,
                                        height: 10.w,
                                        colorFilter: ColorFilter.mode(
                                          context.customColor.text3,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
              ],
            ),
            8.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.inputMethods,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    spacing: 10.w,
                    children: [
                      Expanded(
                        child: _buildInputMethod(
                          context: context,
                          asset: AppAssets.micSvg,
                          text: context.tr.voice,
                        ),
                      ),
                      Expanded(
                        child: _buildInputMethod(
                          context: context,
                          asset: AppAssets.cameraSvg,
                          text: context.tr.camera,
                        ),
                      ),
                      if (item.itemUnit == 'liter' ||
                          item.itemUnit == 'bottle' ||
                          item.itemUnit == 'pg')
                        Expanded(
                          child: _buildInputMethod(
                            context: context,
                            asset: AppAssets.sliderSvg,
                            text: context.tr.slider,
                            onTap: () async {
                              final result = await NavigationService.I
                                  .pushNamed(
                                    AppRouteName.inventoryHowToSliderWorkScreen,
                                  );

                              if (result == null) {
                                AppLogger.log('No result from slider screen');
                                return;
                              }

                              final castedResult =
                                  result as InventorySliderModel;

                              context
                                  .read<ValidationCubit>()
                                  .validateFieldAndStoreValue(
                                    fieldName: _quantityKey,
                                    value: castedResult.total.toString(),
                                    isValid: true,
                                  );

                              context
                                  .read<ValidationCubit>()
                                  .validateFieldAndStoreTypedValue<
                                    InventorySliderModel
                                  >(
                                    fieldName:
                                        'inventorySliderModel_${item.id}',
                                    value: castedResult,
                                    isValid: true,
                                  );
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            8.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr.quickSuggestions,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text4,
                    ),
                  ),
                  5.verticalSpace,
                  Row(
                    children: List.generate(6, (index) {
                      final value = 12 + (index * 2);

                      return Expanded(
                        child: AppGestureDetectorButton(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.all(10.r),
                            margin: EdgeInsetsDirectional.only(
                              end: index < 5 ? 5.r : 0,
                            ),
                            child: Text(
                              '$value',
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            8.verticalSpace,
            DailyInventoryPersonalAddNoteSectionListViewItem(itemId: item.id),
          ],
        ),
      ),
    );
  }

  Widget _buildInputMethod({
    required BuildContext context,
    required String asset,
    required String text,
    VoidCallback? onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvg(assetName: asset),
            4.verticalSpace,
            Text(
              text,
              style: AppStyles.s12W500.copyWith(
                color: context.customColor.text4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
