import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/choose_variance_reason/choose_variance_reason_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/choose_variance_reason/choose_variance_reason_cubit.dart';
import '../widgets/shift_row_title_and_amount.dart';
import '../widgets/variance/choose_variance_reason_bottom_sheet.dart';
import '../widgets/variance/show_variance_info_description_widget.dart';
import '../widgets/variance/variance_type_widget.dart';

class VarianceDetectedScreen extends StatefulWidget {
  final bool showButtons;
  final double totalSales;
  final double handOverAmount;
  final double paymentMethodsTotal;
  final double varianceAmount;

  const VarianceDetectedScreen({
    super.key,
    this.showButtons = true,
    required this.totalSales,
    required this.handOverAmount,
    required this.paymentMethodsTotal,
    required this.varianceAmount,
  });

  @override
  State<VarianceDetectedScreen> createState() => _VarianceDetectedScreenState();
}

class _VarianceDetectedScreenState extends State<VarianceDetectedScreen> {
  void _showChooseVarianceReasonBottomSheet(BuildContext context) {
    final chooseVarianceReasonCubit = context.read<ChooseVarianceReasonCubit>();

    AppBottomSheet.show(
      context,
      (context) => BlocProvider.value(
        value: chooseVarianceReasonCubit,
        child: const ChooseVarianceReasonBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAssetImage(image: AppAssets.darkLogo, width: 57.w),
                    20.verticalSpace,
                    Text(
                      context.tr.varianceDetected,
                      style: AppStyles.s20W600.copyWith(
                        color: context.theme.primaryColor,
                      ),
                    ),
                    20.verticalSpace,
                    Text(
                      context.tr.varianceDetectedDesc,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 3.w,
                          height: 42.h,
                          color: AppColors.yellow,
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Text(
                            context.tr.cannotProceedWithoutVarianceDetails,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.verticalSpace,
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: context.customColor.border),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          Text(
                            context.tr.varianceBreakdown,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ShiftRowTitleAndAmount(
                            amount: widget.totalSales.toStringAsFixed(2),
                            title: context.tr.totalSales,
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ShiftRowTitleAndAmount(
                            amount: widget.handOverAmount.toStringAsFixed(2),
                            title: context.tr.cashHandover,
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ShiftRowTitleAndAmount(
                            amount: widget.varianceAmount.toStringAsFixed(2),
                            title: context.tr.varianceAmount,
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,
                          ShiftRowTitleAndAmount(
                            title: context.tr.varianceType,
                            showCurrencySymbol: false,
                            widget: VarianceTypeWidget(
                              label:
                                  (widget.totalSales -
                                          widget.paymentMethodsTotal) <
                                      0
                                  ? context.tr.over
                                  : context.tr.short,
                              assetName:
                                  (widget.totalSales -
                                          widget.paymentMethodsTotal) <
                                      0
                                  ? AppAssets.over
                                  : AppAssets.short,
                            ),
                          ),
                          14.verticalSpace,
                          const CustomDivider(),
                          14.verticalSpace,

                          const ShowVarianceInfoDescriptionWidget(),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    LabelTextField(text: context.tr.whatTheCauseOfVariance),
                    8.verticalSpace,

                    AppGestureDetectorButton(
                      onTap: () =>
                          _showChooseVarianceReasonBottomSheet(context),
                      child: ContainerCustomTextField(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocSelector<
                              ChooseVarianceReasonCubit,
                              ChooseVarianceReasonState,
                              String?
                            >(
                              selector: (state) =>
                                  state.varianceStrategy?.label(context),
                              builder: (context, state) {
                                return Text(
                                  state ?? context.tr.choose,
                                  style: AppStyles.s14W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                );
                              },
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 16.r,
                              color: context.customColor.text1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    BlocBuilder<
                      ChooseVarianceReasonCubit,
                      ChooseVarianceReasonState
                    >(
                      builder: (context, state) {
                        if (state.varianceStrategy == null) {
                          return const SizedBox.shrink();
                        }

                        return state.varianceStrategy!.fieldsWidget();
                      },
                    ),
                  ],
                ),
              ),
            ),

            if (widget.showButtons) ...[
              30.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: ButtonTextIcon(
                      onTap: () {},
                      label: context.tr.edit,
                      borderRadius: BorderRadius.circular(15.r),
                      padding: EdgeInsets.symmetric(
                        vertical: 13.r,
                        horizontal: 30.r,
                      ),
                      icon: AppSvg(assetName: AppAssets.edit, width: 16.w),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: BlocSelector<ValidationCubit, ValidationState, bool>(
                      selector: (state) => state.enableButton,
                      builder: (context, enableButton) {
                        return AppButton(
                          onClick: () {},
                          text: context.tr.confirm,
                          enabled: enableButton,
                          borderRadius: BorderRadius.circular(15.r),
                          padding: EdgeInsets.symmetric(
                            vertical: 13.r,
                            horizontal: 30.r,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
