import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/filter_button.dart';
import '../cubit/expenses_filter/expenses_filter_cubit.dart';
import '../cubit/expenses_search/expenses_search_cubit.dart';
import 'expenses_filter_widget.dart';

class ExpensesFilterResultTopSection extends StatelessWidget {
  const ExpensesFilterResultTopSection({super.key});

  void _onClickShowResults(BuildContext context) {
    NavigationService.I.pop();
    _getSearchExpenses(context);
  }

  void _getSearchExpenses(BuildContext context) {
    final expensesFilterCubit = context.read<ExpensesFilterCubit>();

    context.read<ExpensesSearchCubit>().getSearchExpenses(
      loadMore: false,
      status: expensesFilterCubit.selectedStatus,
      type: expensesFilterCubit.selectedType,
      period: expensesFilterCubit.selectedSortBy,
    );
  }

  void _onClickFilter(BuildContext context) {
    final cubit = context.read<ExpensesFilterCubit>();

    AppBottomSheet.show(
      context,
      (context) => BlocProvider.value(
        value: cubit,
        child: ExpensesFilterWidget(
          onClickShowResults: (cubit) => _onClickShowResults(context),
        ),
      ),
    );
  }

  void _onClickClearFilter(BuildContext context) {
    context.read<ExpensesFilterCubit>().resetFilter();
    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    final filterCubit = context.watch<ExpensesFilterCubit>();
    final String status =
        filterCubit.selectedStatus?.getDisplayName(context) ?? '';
    final String type = filterCubit.selectedType?.getDisplayName(context) ?? '';
    final String time =
        filterCubit.selectedSortBy?.getDisplayName(context) ?? '';

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(13.r),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      FilterButton(onClick: () => _onClickFilter(context)),
                      Positioned(
                        right: 0,
                        bottom: -5.h,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.theme.primaryColor,
                          ),
                          padding: EdgeInsets.all(5.r),
                          child: Text(
                            '${filterCubit.countSelectedFilters}',
                            textAlign: TextAlign.center,
                            style: AppStyles.s10W400.copyWith(
                              color: context.customColor.reversedTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$status $type $time (${context.watch<ExpensesSearchCubit>().itemCount})',
                            softWrap: true,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                        ),
                        5.horizontalSpace,
                        AppGestureDetectorButton(
                          onTap: () => _onClickClearFilter(context),
                          child: Icon(
                            Icons.close,
                            color: context.customColor.text1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              20.verticalSpace,
              Divider(height: 1.h, color: context.customColor.border),
            ],
          ),
        ),
      ],
    );
  }
}
