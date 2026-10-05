import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../logic/shifts/aggregator_cubit.dart';
import '../cashier_shifts_management_widgets/shift_card_widgets/shift_card.dart';
import '../end_shift_widgets/openAggregatorsSelectorWidget.dart';
import '../shift_details_widgets/shift_details_container_widget.dart';

class SalesBreakDownWidget extends StatefulWidget {
  final TextEditingController totalSaleSController;
  final TextEditingController totalHandoverController;
  final TextEditingController madaController;
  final TextEditingController cashController;

  const SalesBreakDownWidget({
    super.key,
    required this.totalSaleSController,
    required this.totalHandoverController,
    required this.madaController,
    required this.cashController,
  });

  @override
  State<SalesBreakDownWidget> createState() => _SalesBreakDownWidget();
}

class _SalesBreakDownWidget extends State<SalesBreakDownWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReassignShiftCubit, ReassignShiftState>(
      builder: (context, state) {
        final selectedCashier = context
            .read<ReassignShiftCubit>()
            .selectedCashier;

        return SingleChildScrollView(
          child: AppPaddingWidget(
            right: 5.w,
            left: 5.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.SalesAndHandoverBreakdownTitle,
                  style: AppStyles.s20W500,
                ),
                2.verticalSpace,
                Text(
                  context.tr.SalesAndHandoverBreakdownDesc(
                    selectedCashier?.name ?? context.tr.no_name,
                  ),
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                15.verticalSpace,

                ContainerCustomTextField(
                  label: context.tr.totalSales,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: widget.totalSaleSController,
                          hintText: context.tr.totalSalesHintText,
                          keyboardType: TextInputType.number,
                          maxLength: 30,
                          onChanged: (value) {
                            context.read<ValidationCubit>().validateField(
                              'totalSales',
                              value.isNotEmpty,
                            );
                            setState(() {});
                          },
                        ),
                      ),
                      AppSvg(
                        assetName: AppAssets.saudiRiyal,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),

                if (widget.totalSaleSController.text.isNotEmpty) ...[
                  10.verticalSpace,
                  ShiftDetailsContainerWidget(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 10.w,
                    ),
                    child: Column(
                      children: [
                        buildShiftCardRowWidget(
                          context: context,
                          title: context.tr.netSalesExcludingVar,
                          value: context
                              .read<ReassignShiftCubit>()
                              .calculateNetSales(
                                widget.totalSaleSController.text,
                              ),
                          firstValueSvgAsset: AppAssets.saudiRiyal,
                          hasSpaceBetweenTitleAndValue: true,
                        ),
                        5.verticalSpace,
                        buildShiftCardRowWidget(
                          context: context,
                          title: context.tr.netVal,
                          value: context
                              .read<ReassignShiftCubit>()
                              .calculateNetVal(
                                widget.totalSaleSController.text,
                              ),
                          firstValueSvgAsset: AppAssets.saudiRiyal,
                          hasSpaceBetweenTitleAndValue: true,
                        ),

                        10.verticalSpace,

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withAlpha(10),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 20.w,
                                color: AppColors.primaryLight,
                              ),

                              10.horizontalSpace,

                              SizedBox(
                                width: 250.w,
                                child: Text(
                                  context.tr.weCalculateVatAuto,
                                  style: AppStyles.s14W400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                15.verticalSpace,

                ContainerCustomTextField(
                  label: context.tr.handoverAmountTitle,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: widget.totalHandoverController,
                          hintText: context.tr.handoverAmountHintText,
                          keyboardType: TextInputType.number,
                          maxLength: 30,
                          onChanged: (value) {
                            context.read<ValidationCubit>().validateField(
                              'handoverAmount',
                              value.isNotEmpty,
                            );
                          },
                        ),
                      ),
                      AppSvg(
                        assetName: AppAssets.saudiRiyal,
                        width: 20.w,
                        height: 20.h,
                      ),
                    ],
                  ),
                ),

                10.verticalSpace,
                const CustomDivider(),

                10.verticalSpace,
                Text(context.tr.paymentMethods, style: AppStyles.s15W500),
                Text(
                  context.tr.paymentMethodsDesc,
                  style: AppStyles.s13W500.copyWith(
                    color: context.customColor.text3,
                  ),
                ),

                10.verticalSpace,
                const CustomDivider(),

                SizedBox(
                  width: 470.w,
                  height: 100.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: ContainerCustomTextField(
                          label: context.tr.cash,
                          isLabelRequired: false,
                          pngAssetName: AppAssets.cashPng,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: widget.cashController,
                                  hintText: context.tr.amount,
                                  keyboardType: TextInputType.number,
                                  maxLength: 30,
                                  onChanged: (value) {},
                                ),
                              ),
                              AppSvg(
                                assetName: AppAssets.saudiRiyal,
                                width: 20.w,
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ),

                      10.horizontalSpace,
                      Expanded(
                        child: ContainerCustomTextField(
                          label: context.tr.mada,
                          isLabelRequired: false,
                          pngAssetName: AppAssets.madaPng,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: widget.madaController,
                                  hintText: context.tr.amount,
                                  keyboardType: TextInputType.number,
                                  maxLength: 30,
                                  onChanged: (value) {},
                                ),
                              ),
                              AppSvg(
                                assetName: AppAssets.saudiRiyal,
                                width: 20.w,
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                15.verticalSpace,

                const CustomDivider(),
                15.verticalSpace,

                BlocBuilder<AggregatorCubit, AggregatorState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr.paymentAggregtors(
                            context
                                .read<AggregatorCubit>()
                                .addedAggregators
                                .length,
                          ),
                          style: AppStyles.s15W500,
                        ),

                        AppGestureDetectorButton(
                          child: Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: context.theme.primaryColor,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: context.theme.primaryColor,
                                  size: 20.w,
                                ),
                                Text(
                                  context.tr.add,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            _openAggregatorSelector(context);
                          },
                        ),
                      ],
                    );
                  },
                ),

                10.verticalSpace,
                BlocBuilder<AggregatorCubit, AggregatorState>(
                  builder: (context, state) {
                    if (context
                        .read<AggregatorCubit>()
                        .addedAggregators
                        .isNotEmpty) {
                      final aggregators = context
                          .read<AggregatorCubit>()
                          .addedAggregators;

                      return SizedBox(
                        height: 130.h,
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 4.h,
                                crossAxisSpacing: 20.w,
                                childAspectRatio: 1.7,
                              ),
                          itemCount: aggregators.length,
                          itemBuilder: (context, index) {
                            final aggregator = aggregators[index];
                            return ContainerCustomTextField(
                              label: aggregator.name,
                              isLabelRequired: false,
                              imageUrl: aggregator.logo,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: null,
                                      isEnabled: true,
                                      initialValue:
                                          (aggregator.totalAmount ?? 0)
                                              .toString(),
                                      maxLength: 30,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        context
                                                .read<AggregatorCubit>()
                                                .addedAggregators[index] =
                                            aggregator.copyWith(
                                              totalAmount:
                                                  double.tryParse(value) ?? 0,
                                            );
                                      },
                                    ),
                                  ),
                                  AppSvg(
                                    assetName: AppAssets.saudiRiyal,
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state is AggregatorEmpty) {
                      return const Text('No Aggregators');
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAggregatorSelector(BuildContext context) {
    final aggregatorCubit = context.read<AggregatorCubit>();
    AppBottomSheet.show(
      context,
      (_) => BlocProvider.value(
        value: aggregatorCubit,
        child: AggregatorSelectorContent(
          onConfirm: (aggregators) {
            context.read<ReassignShiftCubit>().updateAggregators(aggregators);
          },
        ),
      ),
    );
  }
}
