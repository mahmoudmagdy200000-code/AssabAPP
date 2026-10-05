import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_dropdown.dart';
import 'package:assab/features/inventory/data/models/inventory_slider_model.dart';
import 'package:assab/features/inventory/domain/strategies/slider_strategy.dart';
import 'package:assab/features/inventory/presentation/widgets/inverntory_slider_bottom_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import 'inventory_slider_learn_more_bottom_sheet_widget.dart';

class InventorySliderScreen extends StatefulWidget {
  const InventorySliderScreen({super.key});

  @override
  State<InventorySliderScreen> createState() => _InventorySliderScreenState();
}

class _InventorySliderScreenState extends State<InventorySliderScreen> {
  @override
  void initState() {
    super.initState();

    context
        .read<ValidationCubit>()
        .validateFieldAndStoreTypedValue<SliderStrategy>(
          fieldName: 'sliderType',
          value: BottlesSliderStrategy(),
          isValid: true,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 30.r,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppSvg(assetName: AppAssets.sliderSvg, width: 25.r),
                        Builder(
                          builder: (c) {
                            return ButtonTextIcon(
                              onTap: () {
                                AppBottomSheet.show(
                                  c,
                                  (context) =>
                                      const InventorySliderLearnMoreBottomSheetWidget(),
                                );
                              },
                              label: context.tr.learnMore,
                              icon: Icon(
                                Icons.error_outline_outlined,
                                size: 16.r,
                                color: context.theme.primaryColor,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              borderRadius: BorderRadius.circular(10.r),
                            );
                          },
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    Text(
                      context.tr.slideToSetCount,
                      style: AppStyles.s20W600.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    10.verticalSpace,
                    Text(
                      context.tr.enterFullVolumeThenDragToEstimateLeft,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    12.verticalSpace,
                    ContainerCustomTextField(
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
                                const PurchaseItemImage(),
                                10.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    'ItemName',
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
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.totalNumberOfMilkContainers,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                              5.horizontalSpace,
                              Expanded(
                                child: ContainerCustomTextField(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.r,
                                    vertical: 7.r,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                          hintText: '0',
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            final intVal =
                                                int.tryParse(value) ?? 0;
                                            context
                                                .read<ValidationCubit>()
                                                .validateFieldAndStoreTypedValue<
                                                  int
                                                >(
                                                  fieldName:
                                                      'totalNumberOfMilkContainers',
                                                  value: intVal,
                                                  isValid: value.isNotEmpty,
                                                );
                                          },
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      AppSvg(
                                        assetName: AppAssets.edit,
                                        width: 10.w,
                                        height: 10.w,
                                        colorFilter: ColorFilter.mode(
                                          context.theme.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.tr.volumePerContainer,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ),
                              5.horizontalSpace,
                              Expanded(
                                child: ContainerCustomTextField(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.r,
                                    vertical: 7.r,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '100',
                                          style: AppStyles.s12W500.copyWith(
                                            color: context.customColor.text1,
                                          ),
                                        ),
                                        // CustomTextField(
                                        //   hintText: '0',
                                        //   keyboardType: TextInputType.number,
                                        //   onChanged: (value) {
                                        //     final intVal =
                                        //         int.tryParse(value) ?? 0;
                                        //     context
                                        //         .read<ValidationCubit>()
                                        //         .validateFieldAndStoreTypedValue<
                                        //           int
                                        //         >(
                                        //           fieldName:
                                        //               'volumePerContainer',
                                        //           value: intVal,
                                        //           isValid: value.isNotEmpty,
                                        //         );
                                        //   },
                                        // ),
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        '/L',
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
                                          context.theme.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: context.customColor.border),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.r,
                        vertical: 14.r,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  String
                                >(
                                  selector: (state) {
                                    final total =
                                        state.getTypedValue<int>(
                                          'totalNumberOfMilkContainers',
                                        ) ??
                                        0;
                                    final percentage =
                                        state.getTypedValue<int>(
                                          'sliderPercentage',
                                        ) ??
                                        0;

                                    if (total == 0) {
                                      return '0';
                                    }

                                    String result;

                                    if (percentage == 100) {
                                      result = '$total ${context.tr.full}';
                                    } else if (percentage == 0) {
                                      result =
                                          '${total - 1} ${context.tr.full}';
                                    } else {
                                      result =
                                          '${total - 1} ${context.tr.full} + ${context.tr.one} $percentage% ${context.tr.full}';
                                    }

                                    return result;
                                  },
                                  builder: (context, result) {
                                    return Text(
                                      result,
                                      style: AppStyles.s16W600.copyWith(
                                        color: context.customColor.text6,
                                      ),
                                    );
                                  },
                                ),
                                10.horizontalSpace,
                                Text(
                                  context.tr.totalLiters,
                                  style: AppStyles.s12W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown<SliderStrategy>(
                              items: [
                                BottlesSliderStrategy(),
                                GallonsSliderStrategy(),
                                // BarrelsSliderStrategy(),
                                // PacksSliderStrategy(),
                              ],
                              displayTextBuilder: (value) =>
                                  value?.label(context) ?? '',
                              initialValue: BottlesSliderStrategy(),
                              displayTextSize: 12.r,
                              displayTextWeight: FontWeight.w500,
                              hint: context.tr.selectQuality,
                              dropdownHeight: 150.r,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.r,
                                vertical: 5.r,
                              ),
                              backgroundColor:
                                  context.customColor.reversedTextColor,
                              iconSize: 15.r,
                              borderRadius: 10.r,
                              onChanged: (value) {
                                context
                                    .read<ValidationCubit>()
                                    .validateFieldAndStoreTypedValue<
                                      SliderStrategy
                                    >(
                                      fieldName: 'sliderType',
                                      value: value,
                                      isValid: true,
                                    );
                              },
                              itemBuilder: (context, item, isSelected) {
                                return Container(
                                  padding: EdgeInsets.all(16.r),
                                  child: Text(
                                    item.label(context),
                                    style: AppStyles.s12W500.copyWith(
                                      color: isSelected
                                          ? context.theme.primaryColor
                                          : context.customColor.text1,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    12.verticalSpace,
                    Row(
                      children: [
                        Container(
                          width: 5.w,
                          height: 21.h,
                          color: context.theme.primaryColor,
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: Text(
                            context.tr.slideToPercentageOfPartialContainer,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    const InverntorySliderBottomSection(),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CustomTextButton(
                    text: context.tr.resetAll,
                    onTap: () {},
                    padding: EdgeInsets.symmetric(vertical: 18.r),
                    textColor: context.customColor.text1,
                    borderRadius: 18.r,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) => state.enableButton,
                    builder: (context, state) {
                      return AppButton(
                        onClick: () {
                          final state = context.read<ValidationCubit>().state;

                          NavigationService.I.pop(
                            InventorySliderModel(
                              total:
                                  state.getTypedValue<int>(
                                    'totalNumberOfMilkContainers',
                                  ) ??
                                  0,
                              percentage:
                                  state.getTypedValue<int>(
                                    'sliderPercentage',
                                  ) ??
                                  0,
                            ),
                          );
                        },
                        text: context.tr.confirmCount,
                        enabled: state,
                        padding: EdgeInsets.symmetric(vertical: 18.r),
                        borderRadius: BorderRadius.circular(18.r),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
