import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/handover_user_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../core/widgets/app_placeholder.dart';
import '../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/selection_circule.dart';
import '../../../logic/shifts/handover/handover_cubit.dart';
import '../cashier_name_and_branch_details.dart';

class HandOverWidget extends StatelessWidget {
  const HandOverWidget({
    super.key,
    required this.handOverAmountController,
    required this.handoverNoteController,
    required this.totalSales,
    this.onCashierSelected,
  });

  final Function(HandoverUserItem)? onCashierSelected;
  final TextEditingController handOverAmountController;
  final TextEditingController handoverNoteController;
  final double totalSales;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppPaddingWidget(
        right: 5.w,
        left: 5.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: AppColors.primaryLight.withAlpha(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.tr.totalSales, style: AppStyles.s14W400),

                  Row(
                    children: [
                      AppSvg(
                        assetName: AppAssets.saudiRiyal,
                        width: 25.w,
                        height: 15.h,
                      ),

                      Text(totalSales.toString(), style: AppStyles.s14W600),
                    ],
                  ),
                ],
              ),
            ),

            15.verticalSpace,
            Text(context.tr.handover, style: AppStyles.s16W500),

            15.verticalSpace,
            Text(
              context.tr.confirmWhoWillReceiveCash,
              style: AppStyles.s13W500.copyWith(
                color: context.customColor.text3,
              ),
            ),

            10.verticalSpace,
            const CustomDivider(),

            10.verticalSpace,

            ContainerCustomTextField(
              label: context.tr.handoverRecipient,
              child: AppGestureDetectorButton(
                onTap: () => _openNextCashierSelector(context),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          BlocSelector<
                            ValidationCubit,
                            ValidationState,
                            String?
                          >(
                            selector: (state) =>
                                state.fieldsValue['cashierName'],
                            builder: (context, selectedBranch) {
                              selectedBranch ??= '';
                              return Text(
                                selectedBranch.isNotEmpty
                                    ? selectedBranch
                                    : context.tr.whoAreUHandingTo,
                                style: AppStyles.s14W400.copyWith(
                                  color: selectedBranch.isEmpty
                                      ? context.customColor.text3
                                      : context.customColor.text1,
                                ),
                              );
                            },
                          ),
                    ),

                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.customColor.text1,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            10.verticalSpace,

            ContainerCustomTextField(
              label: context.tr.handOverAmount,
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: handOverAmountController,
                      hintText: context.tr.amount,
                      keyboardType: TextInputType.number,
                      maxLength: 30,
                      onChanged: (value) {
                        context
                            .read<ValidationCubit>()
                            .validateFieldAndStoreValue(
                              fieldName: 'handOverAmount',
                              value: value,
                              isValid: value.isNotEmpty,
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

            15.verticalSpace,

            Text(context.tr.additionalNote, style: AppStyles.s14W500),

            10.verticalSpace,

            Container(
              height: 130.h,
              decoration: BoxDecoration(
                color: context.customColor.text2,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 16.r),
              child: CustomTextField(
                controller: handoverNoteController,
                hintText: context.tr.optionalNote,
                maxLines: 7,
                onChanged: (value) {
                  context.read<ValidationCubit>().validateFieldAndStoreValue(
                    fieldName: 'notes',
                    value: value,
                    isValid: value.isNotEmpty,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openNextCashierSelector(BuildContext context) {
    final cubit = context.read<HandoverCubit>();

    cubit.initFetch();

    HandoverUserItem? selectedCashier;
    List<HandoverUserItem> handoverUserItems = [];

    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        // Near the bottom, load next page
        cubit.loadMore();
      }
    });

    AppBottomSheet.show(context, (sheetContext) {
      final searchController = TextEditingController();
      final validationCubit = context.read<ValidationCubit>();

      validationCubit.validateFieldAndStoreValue(
        fieldName: 'cashierName',
        value: '',
        isValid: false,
      );

      final ValueNotifier<String> query = ValueNotifier('');

      return BlocProvider.value(
        value: cubit,
        child: BlocBuilder<HandoverCubit, HandoverState>(
          builder: (context, HandoverState) {
            // --- handle states first ---
            // if (state is HandoverCashiersFetchingLoading) {
            //   return const AppLoadingWidget();
            // }

            if (HandoverState is HandoverCashiersFetchingFailure) {
              return AppFailureWidget(failure: HandoverState.failure);
            }

            if (HandoverState is HandoverCashiersFetchingSuccess) {
              handoverUserItems = HandoverState.usersList;
            }

            // Default fallback (shouldn't happen)
            return BlocProvider(
              create: (_) => getIt<ChooseItemCubit>(),
              child: AppPaddingWidget(
                child: SizedBox(
                  height: 600.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.chooseRecipient,
                        style: AppStyles.s20W500,
                      ),

                      2.verticalSpace,
                      Text(
                        context.tr.thisCouldBeTheNextCashier,
                        style: AppStyles.s14W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                      7.verticalSpace,
                      const CustomDivider(),
                      15.verticalSpace,

                      // --- Search box ---
                      SizedBox(
                        width: 300.w,
                        child: ContainerCustomTextField(
                          backgroundColor:
                              context.customColor.reversedTextColor,
                          borderColor: Colors.transparent,
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: context.customColor.text1,
                                size: 20.w,
                              ),
                              5.horizontalSpace,
                              Expanded(
                                child: CustomTextField(
                                  maxLength: 30,
                                  isFilled: true,
                                  isEnabled:
                                      HandoverState
                                          is HandoverCashiersFetchingSuccess,
                                  hintText: context.tr.searchForEmployeeByName,
                                  controller: searchController,
                                  onChanged: (text) =>
                                      query.value = text.toLowerCase(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      5.verticalSpace,

                      // --- Filtered list ---
                      Expanded(
                        child: ValueListenableBuilder<String>(
                          valueListenable: query,
                          builder: (_, q, _) {
                            final filtered = handoverUserItems
                                .where(
                                  (b) => b.name.toLowerCase().contains(q),
                                ) // assuming BranchEntity has name
                                .toList();

                            if (HandoverState
                                is HandoverCashiersFetchingEmpty) {
                              return Center(
                                child: Text(
                                  context.tr.noAvailableCashiers,
                                  style: AppStyles.s15W500,
                                ),
                              );
                            } else {
                              return BlocBuilder<
                                ValidationCubit,
                                ValidationState
                              >(
                                builder: (context, state) {
                                  return ListView.builder(
                                    controller: scrollController,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30.w,
                                      vertical: 5.h,
                                    ),
                                    itemCount:
                                        HandoverState
                                            is HandoverCashiersFetchingLoading
                                        ? 3
                                        : filtered.length,
                                    itemBuilder: (context, index) {
                                      if (HandoverState
                                          is HandoverCashiersFetchingLoading) {
                                        return Container(
                                          margin: EdgeInsetsDirectional.only(
                                            top: 15.h,
                                          ),
                                          child: Row(
                                            children: [
                                              AppPlaceholder(
                                                width: 25.w,
                                                height: 25.h,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              15.horizontalSpace,

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppPlaceholder(
                                                    width: 60.w,
                                                    height: 15.h,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                  ),
                                                  15.verticalSpace,

                                                  AppPlaceholder(
                                                    width: 80.w,
                                                    height: 10.h,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12.r,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      final cashier = filtered[index];
                                      return AppPaddingWidget(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        top: 15.r,
                                        child: AppGestureDetectorButton(
                                          onTap: () {
                                            if (cashier.disabled) return;
                                            context
                                                .read<ChooseItemCubit>()
                                                .selectItem(index);

                                            validationCubit
                                                .validateFieldAndStoreValue(
                                                  fieldName: 'cashierName',
                                                  value: cashier.name,
                                                  isValid: true,
                                                );

                                            selectedCashier = cashier;
                                          },
                                          child: Opacity(
                                            opacity: cashier.disabled ? 0.45 : 1.0,
                                            child: Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 40.w,
                                                      height: 35.h,
                                                      child:
                                                          (cashier.image !=
                                                                  null &&
                                                              cashier
                                                                  .image!
                                                                  .isNotEmpty)
                                                          ? Image.network(
                                                              cashier.image!,
                                                              errorBuilder:
                                                                  (
                                                                    context,
                                                                    error,
                                                                    stackTrace,
                                                                  ) {
                                                                    return const AppSvg(
                                                                      assetName:
                                                                          AppAssets
                                                                              .noProfile,
                                                                    );
                                                                  },
                                                            )
                                                          : const AppSvg(
                                                              assetName:
                                                                  AppAssets
                                                                      .noProfile,
                                                            ),
                                                    ),

                                                    10.horizontalSpace,

                                                    CashierNameAndBranch(
                                                      Name: cashier.name,
                                                      BranchName: cashier.isSuggested
                                                          ? (cashier.suggestionReason ??
                                                              'Next scheduled cashier (auto-handover)')
                                                          : (cashier.disabled &&
                                                                  cashier.reasonDisabled != null)
                                                              ? cashier.reasonDisabled!
                                                              : cashier.branchName,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              BlocSelector<
                                                ChooseItemCubit,
                                                ChooseItemState,
                                                int?
                                              >(
                                                selector: (state) =>
                                                    state.selectedIndex,
                                                builder: (context, selectedIndex) {
                                                  // return RowTextCirculeSelection(
                                                  //   text: cashier.name,
                                                  //   isSelected:
                                                  //   selectedIndex == index,
                                                  // );
                                                  return SelectionCircule(
                                                    isSelected:
                                                        selectedIndex == index,
                                                  );
                                                },
                                              ),
                                              // Expanded(
                                              //   child: BlocSelector<
                                              //       ChooseItemCubit,
                                              //       ChooseItemState,
                                              //       int?>(
                                              //     selector: (state) =>
                                              //     state.selectedIndex,
                                              //     builder:
                                              //         (context, selectedIndex) {
                                              //       // return RowTextCirculeSelection(
                                              //       //   text: cashier.name,
                                              //       //   isSelected:
                                              //       //   selectedIndex == index,
                                              //       // );
                                              //           return SelectionCircule(isSelected: selectedIndex == index);
                                              //         },
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),

                      15.verticalSpace,

                      BlocBuilder<ValidationCubit, ValidationState>(
                        builder: (context, state) {
                          return AppButton(
                            text: context.tr.confirm,
                            enabled:
                                state.fieldsValue['cashierName']?.isNotEmpty ==
                                true,
                            onClick: () {
                              if (state.fieldsValue['cashierName'] != null) {
                                validationCubit.validateFieldAndStoreValue(
                                  fieldName: 'cashierName',
                                  value: state.fieldsValue['cashierName']
                                      .toString(),
                                  isValid: true,
                                );

                                context.read<HandoverCubit>().selectedCashier =
                                    selectedCashier;

                                if (selectedCashier != null) {
                                  onCashierSelected?.call(selectedCashier!);
                                }

                                NavigationService.I.pop();
                              }
                            },
                          );
                        },
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
