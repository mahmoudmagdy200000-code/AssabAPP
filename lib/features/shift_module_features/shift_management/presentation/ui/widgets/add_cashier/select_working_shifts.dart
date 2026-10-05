import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_placeholder.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_info_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../logic/add_cashier/get_available_cashier_shifts_cubit.dart';

class SelectWorkingShiftWidget extends StatefulWidget {
  const SelectWorkingShiftWidget({
    super.key,
    required this.onAction,
    this.initialShiftId,
    this.showButton = false,
  });

  @override
  State<SelectWorkingShiftWidget> createState() =>
      _SelectWorkingShiftWidgetState();

  final bool showButton;

  final Function(ShiftInfoDetailsEntity shift) onAction;
  final String? initialShiftId;
}

class _SelectWorkingShiftWidgetState extends State<SelectWorkingShiftWidget> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<GetAvailableCashierShiftsCubit>();
    cubit.getAvailableCashierShifts(resetPagination: true);

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        if (cubit.shiftsPaginatorHasMore) {
          cubit.getAvailableCashierShifts(resetPagination: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    late ShiftInfoDetailsEntity selectedShiftEntity;

    return AppPaddingWidget(
      child: SizedBox(
        height: 600.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.tr.chooseEmplyeeShift, style: AppStyles.s20W500),
            2.verticalSpace,
            Text(
              context.tr.chooseEmplyeeShiftDesc(
                validationCubit.getFieldValue('storeBranch'),
              ),
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            7.verticalSpace,
            const CustomDivider(),
            15.verticalSpace,

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: context.customColor.border,
                    width: 1.w,
                  ),
                ),
                child: Column(
                  children: [
                    10.verticalSpace,

                    Container(
                      decoration: BoxDecoration(
                        color: context.customColor.text2,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 50.w,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text(
                            context.tr.sundayThursday,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),

                          Text(
                            context.tr.workHoursFrom_t0('6:00 AM', '6:00 PM'),
                            style: AppStyles.s11W500.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 250.w, child: const CustomDivider()),

                    BlocBuilder<
                      GetAvailableCashierShiftsCubit,
                      GetAvailableCashierShiftsState
                    >(
                      builder: (context, state) {
                        if (state is GetAvailableCashierShiftsLoading) {
                          return Expanded(
                            child: Scrollbar(
                              controller: _controller,
                              thumbVisibility: true,
                              radius: Radius.circular(12.r),
                              trackVisibility: true,
                              thickness: 4.w,
                              child: ListView.builder(
                                controller: _controller,
                                primary: false,
                                itemCount: 3,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30.w,
                                  vertical: 5.h,
                                ),

                                itemBuilder: (context, index) {
                                  return AppPaddingWidget(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    top: 15.r,
                                    child: Row(
                                      children: [
                                        AppPlaceholder(
                                          width: 25.w,
                                          height: 25.h,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        20.horizontalSpace,

                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppPlaceholder(
                                              width: 60.w,
                                              height: 15.h,
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                            10.verticalSpace,

                                            AppPlaceholder(
                                              width: 80.w,
                                              height: 10.h,
                                              borderRadius:
                                                  BorderRadius.circular(12.r),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        } else if (state is GetAvailableCashierShiftsFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: () => context
                                .read<GetAvailableCashierShiftsCubit>()
                                .getAvailableCashierShifts(
                                  resetPagination: true,
                                ),
                          );
                        }
                        return Expanded(
                          child: Scrollbar(
                            controller: _controller,
                            thumbVisibility: true,
                            radius: Radius.circular(12.r),
                            trackVisibility: true,
                            thickness: 4.w,
                            child: ListView.builder(
                              controller: _controller,
                              primary: false,
                              itemCount: context
                                  .read<GetAvailableCashierShiftsCubit>()
                                  .workShifts
                                  ?.length,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 5.h,
                              ),

                              itemBuilder: (context, index) {
                                List<ShiftInfoDetailsEntity> shifts;
                                late ShiftInfoDetailsEntity shift;

                                if (state
                                    is! GetAvailableCashierShiftsLoading) {
                                  shifts =
                                      context
                                          .read<
                                            GetAvailableCashierShiftsCubit
                                          >()
                                          .workShifts ??
                                      [];
                                  shift = shifts[index];

                                  if (state
                                      is GetAvailableCashierShiftsSuccess) {
                                    shifts =
                                        context
                                            .read<
                                              GetAvailableCashierShiftsCubit
                                            >()
                                            .workShifts ??
                                        [];

                                    if (widget.initialShiftId != null) {
                                      final searchIndex = shifts.indexWhere(
                                        (s) => s.id == widget.initialShiftId,
                                      );
                                      if (searchIndex != -1) {
                                        context
                                            .read<ChooseItemCubit>()
                                            .selectItem(searchIndex);

                                        context
                                            .read<ValidationCubit>()
                                            .validateFieldAndStoreValue(
                                              fieldName: 'selectedShift',
                                              value: shifts[searchIndex].name,
                                              isValid: true,
                                            );
                                      }
                                    }
                                  }

                                  return AppPaddingWidget(
                                    bottom: 0,
                                    right: 0,
                                    left: 0,
                                    top: 15.r,
                                    child: AppGestureDetectorButton(
                                      onTap: () {
                                        if (!shift.isActive) {
                                          return;
                                        }

                                        context
                                            .read<ChooseItemCubit>()
                                            .selectItem(index);

                                        validationCubit
                                            .validateFieldAndStoreValue(
                                              fieldName: 'selectedShift',
                                              value: shift.name,
                                              isValid: true,
                                            );

                                        selectedShiftEntity = shift;
                                        if (!widget.showButton) {
                                          widget.onAction(selectedShiftEntity);
                                        }
                                      },
                                      child: BlocSelector<ChooseItemCubit, ChooseItemState, int?>(
                                        selector: (state) {
                                          return state.selectedIndex;
                                        },
                                        builder: (context, selectedIndex) {
                                          return Row(
                                            children: [
                                              SelectionCircule(
                                                isSelected: shift.isActive
                                                    ? selectedIndex == index
                                                    : true,
                                                color: shift.isActive
                                                    ? null
                                                    : context.customColor.text2,
                                              ),

                                              20.horizontalSpace,

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,

                                                children: [
                                                  Text(
                                                    shift.name,
                                                    style: AppStyles.s14W500.copyWith(
                                                      color: shift.isActive
                                                          ? selectedIndex ==
                                                                    index
                                                                ? AppColors
                                                                      .primaryLight
                                                                : context
                                                                      .customColor
                                                                      .text1
                                                          : context
                                                                .customColor
                                                                .text3,
                                                    ),
                                                  ),

                                                  Text(
                                                    context.tr.workHoursFrom_t0(
                                                      shift.formatTime12(
                                                            shift.startTime,
                                                          ) ??
                                                          'N/A',
                                                      shift.formatTime12(
                                                            shift.endTime,
                                                          ) ??
                                                          'N/A',
                                                    ),
                                                    style: AppStyles.s11W500
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text3,
                                                        ),
                                                  ),
                                                  if (!shift.isActive)
                                                    Text(
                                                      context
                                                          .tr
                                                          .shiftAssignedToAnotherCashier,
                                                      style: AppStyles.s11W400
                                                          .copyWith(
                                                            color: AppColors
                                                                .darkYellow,
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
                                }

                                return null;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            10.verticalSpace,

            if (widget.showButton) ...[
              BlocBuilder<ValidationCubit, ValidationState>(
                builder: (context, state) {
                  final selectedShift = state.fieldsValue['selectedShift'];

                  return AppButton(
                    text: context.tr.confirm,
                    enabled:
                        selectedShift?.isNotEmpty == true &&
                        (context
                                .read<GetAvailableCashierShiftsCubit>()
                                .workShifts
                                ?.any((shift) => shift.isActive) ??
                            false),
                    onClick: () {
                      if (selectedShift != null) {
                        validationCubit.validateFieldAndStoreValue(
                          fieldName: 'selectedShift',
                          value: selectedShift,
                          isValid: true,
                        );

                        widget.onAction(selectedShiftEntity);
                      }
                    },
                  );
                },
              ),
              10.verticalSpace,
            ],
          ],
        ),
      ),
    );
  }
}
