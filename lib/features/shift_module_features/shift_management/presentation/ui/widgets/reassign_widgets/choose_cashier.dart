import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/available_cashier_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/styles/app_colors.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/app_placeholder.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/selection_circule.dart';
import '../../../logic/shifts/reassign_shift/reassign_shift_cubit.dart';

class ChooseCashierWidget extends StatefulWidget {
  const ChooseCashierWidget({super.key});

  @override
  State<ChooseCashierWidget> createState() => _ChooseCashierWidgetState();
}

class _ChooseCashierWidgetState extends State<ChooseCashierWidget> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ReassignShiftCubit>().getAvailableCashiers();
  }

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    return AppPaddingWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr.chooseEmplyeeShift, style: AppStyles.s20W500),
          2.verticalSpace,
          Text(
            context.tr.whoWillTakeTheShift,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          7.verticalSpace,
          Row(
            children: [
              Container(
                width: 5.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              10.horizontalSpace,
              SizedBox(
                width: 260.w,
                child: Column(
                  children: [
                    Text(
                      context.tr.confirmAvailabilityBeforeReassigning,
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                    5.verticalSpace,

                    Text(
                      context.tr.theActionIsIrreversible,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          const CustomDivider(),
          15.verticalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.customColor.border),
              ),
              child: Column(
                children: [
                  10.verticalSpace,
                  const CustomDivider(),
                  BlocBuilder<ReassignShiftCubit, ReassignShiftState>(
                    buildWhen: (previous, current) =>
                        (current is ReassignShiftFetchAvailableSuccess) ||
                        (current is ReassignShiftFetchAvailableLoading) ||
                        (current is ReassignShiftFetchAvailableEmpty) ||
                        (current is ReassignShiftFetchAvailableFailure),
                    builder: (context, state) {
                      final List<AvailableCashierEntity> cashiers = [];

                      if (state is ReassignShiftFetchAvailableEmpty) {
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppSvg(
                                assetName: AppAssets.noCashiers,
                                width: 60.w,
                              ),
                              Text(
                                context.tr.noCashiersAreAvailable,
                                style: AppStyles.s14W400,
                              ),
                            ],
                          ),
                        );
                      } else if (state is ReassignShiftFetchAvailableFailure) {
                        return Expanded(
                          child: AppFailureWidget(
                            failure: state.failure,
                            withBorder: false,
                          ),
                        );
                      } else if (state is ReassignShiftFetchAvailableLoading) {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            itemCount: 5,
                            itemBuilder: (context, index) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppPlaceholder(
                                  width: 25.w,
                                  height: 25.h,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                20.horizontalSpace,

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppPlaceholder(
                                      width: 60.w,
                                      height: 15.h,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    15.verticalSpace,

                                    // AppPlaceholder(
                                    //   width: 80.w,
                                    //   height: 10.h,
                                    //   borderRadius: BorderRadius.circular(12.r),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (state is ReassignShiftFetchAvailableSuccess) {
                        cashiers.addAll(
                          context.read<ReassignShiftCubit>().cashiers ?? [],
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          controller: _controller,
                          primary: false,
                          itemCount:
                              context
                                  .read<ReassignShiftCubit>()
                                  .cashiers
                                  ?.length ??
                              0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 5.h,
                          ),

                          itemBuilder: (context, index) {
                            final cashier = cashiers[index];

                            return AppPaddingWidget(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              top: 15.h,
                              child: AppGestureDetectorButton(
                                onTap: () {
                                  context.read<ChooseItemCubit>().selectItem(
                                    index,
                                  );

                                  validationCubit.validateFieldAndStoreValue(
                                    fieldName: 'cashierName',
                                    value: cashier.name,
                                    isValid: true,
                                  );

                                  context
                                          .read<ReassignShiftCubit>()
                                          .selectedCashier =
                                      cashier;
                                },
                                child:
                                    BlocSelector<
                                      ChooseItemCubit,
                                      ChooseItemState,
                                      int?
                                    >(
                                      selector: (state) => state.selectedIndex,
                                      builder: (context, selectedIndex) {
                                        return Row(
                                          children: [
                                            SelectionCircule(
                                              isSelected:
                                                  selectedIndex == index,
                                            ),

                                            20.horizontalSpace,

                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,

                                              children: [
                                                Text(
                                                  cashier.name,
                                                  style: AppStyles.s14W500
                                                      .copyWith(
                                                        color:
                                                            selectedIndex ==
                                                                index
                                                            ? AppColors
                                                                  .primaryLight
                                                            : context
                                                                  .customColor
                                                                  .text1,
                                                      ),
                                                ),

                                                Text(
                                                  cashier.isAvailable
                                                      ? context.tr.available
                                                      : context
                                                            .tr
                                                            .currentlyWorking,
                                                  style: AppStyles.s11W500
                                                      .copyWith(
                                                        color:
                                                            cashier.isAvailable
                                                            ? context
                                                                  .customColor
                                                                  .text3
                                                            : AppColors
                                                                  .darkOrange,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }
}
