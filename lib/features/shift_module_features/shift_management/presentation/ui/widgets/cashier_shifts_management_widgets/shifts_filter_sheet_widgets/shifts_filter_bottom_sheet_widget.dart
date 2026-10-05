import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/enums/date_filter_options.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../../core/cubits/choose_item/choose_item_state.dart';
import '../../../../../../../../core/di/dependency_injection.dart';
import '../../../../../../../../core/enums/shift_status/shift_status.dart';
import '../../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../../../core/widgets/app_placeholder.dart';
import '../../../../../../../../core/widgets/app_svg.dart';
import '../../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../../core/widgets/selection_circule.dart';
import '../../../../../domain/entity/handover_user_item.dart';
import '../../../../logic/shifts/shift_filter/fetch_manager_cubit.dart';
import '../../../../logic/shifts/shift_filter/fetch_manager_state.dart';
import '../../../../logic/shifts/shift_filter/shift_filter_cubit.dart';
import '../../../filters/cashier_shifts_status_impl.dart';
import '../../../filters/date_filter.dart';
import '../../cashier_name_and_branch_details.dart';
import 'cashier_shifts_search_result_widget.dart';

class ShiftsFilterBottomSheetWidget extends StatelessWidget {
  const ShiftsFilterBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateOptions = [
      Last24HoursOption(),
      Last7DaysOption(),
      Last14DaysOption(),
      Last30DaysOption(),
      Last1YearOption(),
    ];
    final statusOptions = [
      CashierShiftsAllShiftsStatus(),
      CashierShiftsPendingStatus(),
      CashierShiftsInProgressStatus(),
      CashierShiftsCompletedStatus(),
    ];

    return Scaffold(
      body: BlocBuilder<ShiftFilterCubit, ShiftFilterState>(
        builder: (context, state) {
          final cubit = context.read<ShiftFilterCubit>();

          return SizedBox(
            width: double.infinity,
            child: AppPaddingWidget(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 600.h,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              context.tr.filterShiftListBy,
                              style: AppStyles.s20W500,
                            ),
                          ),
                          7.verticalSpace,
                          const CustomDivider(),
                          7.verticalSpace,

                          Text(
                            context.tr.accountStatus,
                            style: AppStyles.s14W500.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          TimeFilterRadioGroupGridView<ShiftStatus>(
                            selected: state.status,
                            onChanged: (value) => cubit.setStatus(value),
                            options: statusOptions,
                            getLabel: (option) => option.name,
                          ),

                          const CustomDivider(),
                          14.verticalSpace,

                          /// DATE FILTER
                          Text(
                            context.tr.dateAdded,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          14.verticalSpace,
                          TimeFilterRadioGroup<DateFilterOption>(
                            selected: state.dateFilter,
                            onChanged: (value) => cubit.setDateFilter(value),
                            options: dateOptions,
                            getLabel: (option) => option.name,
                          ),
                          const CustomDivider(),
                          14.verticalSpace,

                          BlocProvider(
                            create: (_) => FetchManagerCubit(
                              getIt<ShiftManagementRepositoryImp>(),
                            )..initFetch(),
                            child: openNextCashierSelector(context),
                          ),
                        ],
                      ),
                    ),

                    /// BUTTONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150.w,
                          height: 45.h,
                          child: AppButton(
                            padding: EdgeInsets.zero,
                            enabled: true,
                            isTransparent: true,
                            textColor: AppColors.sBlack,
                            onClick: () {
                              cubit.resetFilters();

                              context.read<ChooseItemCubit>().reset();
                            },
                            text: context.tr.defaultSettings,
                          ),
                        ),
                        SizedBox(
                          width: 150.w,
                          height: 45.h,
                          child: AppButton(
                            padding: EdgeInsets.zero,
                            background: AppColors.primaryLight,
                            textColor: Colors.white,
                            enabled: cubit.hasFilters,
                            onClick: () {
                              // context.read<CashierShiftsManagementCubit>().fetchShiftsWithFilters(
                              //   dateFilter: cubit.state.dateFilter?.dateOption.apiKey,
                              //   statusFilter: cubit.state.status,
                              //   managerIdFilter: cubit.state.managerId,
                              //   loadMore: false,
                              // );

                              AppBottomSheet.show(
                                context,
                                (context) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          getIt<CashierShiftsManagementCubit>(
                                            param1: context
                                                .read<
                                                  CashierShiftsManagementCubit
                                                >()
                                                .cashierId,
                                          )..fetchShiftsWithFilters(
                                            dateFilter: cubit
                                                .state
                                                .dateFilter
                                                ?.dateOption
                                                .apiKey,
                                            statusFilter: cubit.state.status,
                                            managerIdFilter:
                                                cubit.state.managerId,
                                            loadMore: false,
                                          ),
                                    ),

                                    BlocProvider.value(value: cubit),
                                  ],
                                  child: CashierShiftsSearchResultWidget(
                                    isFromFilter: true,
                                    cashierId: context
                                        .read<CashierShiftsManagementCubit>()
                                        .cashierId,
                                    dateFilter: cubit
                                        .state
                                        .dateFilter
                                        ?.dateOption
                                        .apiKey,
                                    statusFilter: cubit.state.status,
                                    managerIdFilter: cubit.state.managerId,
                                  ),
                                ),
                              );
                            },
                            text: context.tr.showResults,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TimeFilterRadioGroup<T> extends StatelessWidget {
  const TimeFilterRadioGroup({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.options,
    required this.getLabel,
  });

  final T? selected;
  final ValueChanged<T> onChanged;
  final List<T> options;
  final String Function(T) getLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: context.customColor.border, width: 2.w),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: options.map((option) {
            final isSelected = option == selected;
            return InkWell(
              onTap: () => onChanged(option),
              child: Container(
                height: 50.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  border: option == options.last
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: context.customColor.border,
                            width: 1.w,
                          ),
                        ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getLabel(option),
                      style: AppStyles.s13W500.copyWith(
                        color: isSelected
                            ? AppColors.primaryLight
                            : context.customColor.text1,
                      ),
                    ),
                    Radio<T>(
                      value: option,
                      side: BorderSide(
                        color: context.customColor.text3,
                        width: 1.w,
                      ),
                      groupValue: selected,
                      onChanged: (value) => onChanged(value as T),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TimeFilterRadioGroupGridView<T> extends StatelessWidget {
  const TimeFilterRadioGroupGridView({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.options,
    required this.getLabel,
  });

  final T? selected;
  final ValueChanged<T> onChanged;
  final List<T> options;
  final String Function(T) getLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option == selected;
          return InkWell(
            borderRadius: BorderRadius.circular(25.w),
            onTap: () => onChanged(option),
            child: Container(
              // padding: EdgeInsets.symmetric(vertical: 5.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryLight
                      : context.customColor.border,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(25.w),
                color: isSelected ? AppColors.primaryLight.withAlpha(10) : null,
              ),
              child: Text(
                getLabel(option),
                style: AppStyles.s13W400.copyWith(
                  color: isSelected
                      ? AppColors.primaryLight
                      : context.customColor.text1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget openNextCashierSelector(BuildContext context) {
  final filterCubit = context.read<ShiftFilterCubit>();

  final searchController = TextEditingController();
  final ValueNotifier<String> query = ValueNotifier('');

  return BlocBuilder<FetchManagerCubit, FetchManagerState>(
    builder: (context, state) {
      if (state is FetchManagerLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is FetchManagerEmpty) {
        return const Center(child: Text('No managers found'));
      }

      if (state is FetchManagerFailure) {
        return Center(child: AppFailureWidget(failure: state.failure));
      }

      final managers = state is FetchManagerSuccess
          ? state.managers
          : <HandoverUserItem>[];

      return AppPaddingWidget(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.customColor.border, width: 1.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
          height: 300.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              7.verticalSpace,
              const CustomDivider(),
              15.verticalSpace,

              // --- Search box ---
              SizedBox(
                width: 300.w,
                child: ContainerCustomTextField(
                  backgroundColor: context.customColor.reversedTextColor,
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
                          isEnabled: true,
                          hintText: context.tr.searchForEmployeeByName,
                          controller: searchController,
                          onChanged: (text) => query.value = text.toLowerCase(),
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
                    final filtered = managers
                        .where(
                          (b) => b.name.toLowerCase().contains(q),
                        ) // assuming BranchEntity has name
                        .toList();

                    if (FetchManagerState is FetchManagerEmpty) {
                      return Center(
                        child: Text(
                          context.tr.noAvailableCashiers,
                          style: AppStyles.s15W500,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _buildScrollController(context),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 5.h,
                        ),
                        itemCount: FetchManagerState is FetchManagerLoading
                            ? 3
                            : filtered.length,
                        itemBuilder: (context, index) {
                          if (FetchManagerState is FetchManagerLoading) {
                            return Container(
                              margin: EdgeInsetsDirectional.only(top: 15.h),
                              child: Row(
                                children: [
                                  AppPlaceholder(
                                    width: 25.w,
                                    height: 25.h,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  15.horizontalSpace,

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppPlaceholder(
                                        width: 60.w,
                                        height: 15.h,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      15.verticalSpace,

                                      AppPlaceholder(
                                        width: 80.w,
                                        height: 10.h,
                                        borderRadius: BorderRadius.circular(
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
                                context.read<ChooseItemCubit>().selectItem(
                                  index,
                                );

                                filterCubit.setSelectedManager(cashier.id);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40.w,
                                          height: 35.h,
                                          child:
                                              (cashier.image != null &&
                                                  cashier.image!.isNotEmpty)
                                              ? Image.network(
                                                  cashier.image!,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return const AppSvg(
                                                          assetName: AppAssets
                                                              .noProfile,
                                                        );
                                                      },
                                                )
                                              : const AppSvg(
                                                  assetName:
                                                      AppAssets.noProfile,
                                                ),
                                        ),

                                        10.horizontalSpace,

                                        CashierNameAndBranch(
                                          Name: cashier.name,
                                          BranchName: cashier.branchName,
                                        ),
                                      ],
                                    ),
                                  ),

                                  BlocSelector<
                                    ChooseItemCubit,
                                    ChooseItemState,
                                    int?
                                  >(
                                    selector: (state) => state.selectedIndex,
                                    builder: (context, selectedIndex) {
                                      // return RowTextCirculeSelection(
                                      //   text: cashier.name,
                                      //   isSelected:
                                      //   selectedIndex == index,
                                      // );
                                      return SelectionCircule(
                                        isSelected: selectedIndex == index,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              15.verticalSpace,
            ],
          ),
        ),
      );
    },
  );
}

ScrollController _buildScrollController(BuildContext context) {
  final controller = ScrollController();

  controller.addListener(() {
    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 200) {
      context.read<FetchManagerCubit>().loadMore();
    }
  });

  return controller;
}
