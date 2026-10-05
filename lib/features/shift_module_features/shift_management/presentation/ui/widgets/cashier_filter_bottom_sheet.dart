import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/enums/date_filter_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/app_styles.dart';
import '../../../../../../core/widgets/app_padding_widget.dart';
import '../../../../../../core/widgets/custom_divider.dart';
import '../../../../../../core/widgets/selection_circule.dart';
import '../../logic/cashier/cashier_filter/cashier_filter_cubit.dart';
import '../../logic/cashier/cashier_management_cubit.dart';
import '../filters/cashier_filter/cashier_status_filter.dart';
import '../filters/date_filter.dart';
import 'cashiers_management/cashiers_search_result_widget.dart';

class CashierFilterBottomSheetWidget extends StatefulWidget {
  const CashierFilterBottomSheetWidget({super.key});

  @override
  State<CashierFilterBottomSheetWidget> createState() =>
      _CashierFilterBottomSheetWidgetState();
}

class _CashierFilterBottomSheetWidgetState
    extends State<CashierFilterBottomSheetWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<CashierManagementCubit>();

    if (!_scrollController.position.outOfRange &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (cubit.hasMore) {
        context.read<CashierManagementCubit>().getCashiers(loadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _openCashiersSheet({
    String? dateOption,
    String? statusOption,
    required CashierFilterCubit filterCubit,
  }) {
    Navigator.pop(context);

    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<CashierManagementCubit>()
              ..getCashiers(
                dateOption: dateOption,
                status: statusOption,
                loadMore: false,
              ),
          ),

          BlocProvider.value(value: filterCubit),
        ],
        child: const CashiersSearchResultWidget(),
      ),
    );
  }

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
      const ActiveCashierStatus(),
      const PendingCashierStatus(),
      const DeactivatedCashierStatus(),
    ];

    return BlocBuilder<CashierFilterCubit, CashierFilterState>(
      builder: (context, state) {
        final cubit = context.read<CashierFilterCubit>();

        return SizedBox(
          width: double.infinity,
          child: AppPaddingWidget(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      context.tr.filterCashierListBy,
                      style: AppStyles.s20W500,
                    ),
                  ),
                  7.verticalSpace,
                  const CustomDivider(),
                  7.verticalSpace,

                  /// DATE FILTER
                  Text(
                    context.tr.dateAdded,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  14.verticalSpace,

                  BlocProvider(
                    create: (context) => getIt<ChooseItemCubit>(),
                    child: TimeFilterRadioGroup<DateFilterOption>(
                      selected: state.dateFilter,
                      onChanged: (value) => cubit.updateDateFilter(value),
                      options: dateOptions,
                      getLabel: (option) => option.name,
                    ),
                  ),

                  const CustomDivider(),
                  14.verticalSpace,

                  /// STATUS FILTER
                  Text(
                    context.tr.accountStatus,
                    style: AppStyles.s14W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => getIt<ChooseItemCubit>(),
                    child: TimeFilterRadioGroup<CashierStatusFilter>(
                      selected: state.statusFilter,
                      onChanged: (value) => cubit.updateStatusFilter(value),
                      options: statusOptions,
                      getLabel: (option) => option.label,
                    ),
                  ),

                  const CustomDivider(),
                  14.verticalSpace,

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
                          enabled: cubit.hasActiveFilters,
                          onClick: () {
                            _openCashiersSheet(
                              dateOption:
                                  cubit.state.dateFilter?.dateOption.apiKey,
                              statusOption: cubit.state.statusFilter?.apiValue,
                              filterCubit: context.read<CashierFilterCubit>(),
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
    );
  }
}

// class TimeFilterRadioGroup<T> extends StatelessWidget {
//   const TimeFilterRadioGroup({
//     super.key,
//     required this.selected,
//     required this.onChanged,
//     required this.options,
//     required this.getLabel,
//   });
//
//   final T? selected;
//   final ValueChanged<T> onChanged;
//   final List<T> options;
//   final String Function(T) getLabel;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Center(
//       child: Container(
//         width: 400.w,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16.w),
//           border: Border.all(color: context.customColor.border, width: 2.w),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Column(
//           children: [
//             ...List.generate(
//                 options.length,
//                   (index) {
//                     final option = options[index];
//                     final isSelected = option == selected;
//
//                     return InkWell(
//                       onTap: () {
//                         context.read<ChooseItemCubit>().selectItem(index);
//                         onChanged(option);
//                       },
//                       child: Container(
//                         height: 50.h,
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(horizontal: 20.w),
//                         decoration: BoxDecoration(
//                           border: option == options.last
//                               ? null
//                               : Border(bottom: BorderSide(color: context.customColor.border, width: 1.w)),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               getLabel(option),
//                               style: AppStyles.s13W500.copyWith(
//                                 color: isSelected ? AppColors.primaryLight : context.customColor.text1,
//                               ),
//                             ),
//                             // Radio<T>(
//                             //   value: option,
//                             //   side: BorderSide(color: context.customColor.text3, width: 1.w),
//                             //   groupValue: selected,
//                             //   onChanged: (value) => onChanged(value as T),
//                             // ),
//
//                             BlocSelector<
//                                 ChooseItemCubit,
//                                 ChooseItemState,
//                                 int?
//                             >(
//                               selector: (state) =>
//                               state.selectedIndex,
//                               builder: (context, selectedIndex) {
//                                 // return RowTextCirculeSelection(
//                                 //   text: cashier.name,
//                                 //   isSelected:
//                                 //   selectedIndex == index,
//                                 // );
//                                 return SelectionCircule(
//                                   isSelected: selectedIndex == index,
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }
//             )
//           ],
//         )
//       ),
//     );
//   }
// }
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
          children: List.generate(options.length, (index) {
            final option = options[index];
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
                          bottom: BorderSide(color: context.customColor.border),
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

                    SelectionCircule(isSelected: isSelected),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
