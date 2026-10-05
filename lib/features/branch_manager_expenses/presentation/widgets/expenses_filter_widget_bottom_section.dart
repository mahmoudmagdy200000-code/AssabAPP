import 'dart:developer';

import 'package:assab/core/enums/time_keys.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_gesture_detector_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../cubit/expenses_filter/expenses_filter_cubit.dart';
import '../cubit/expenses_filter/expenses_filter_state.dart';
import 'expenses_filter_widget_text_title.dart';

class ExpensesFilterWidgetBottomSection extends StatelessWidget {
  const ExpensesFilterWidgetBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> storedBy = [
      context.tr.last24Hours,
      context.tr.last7Days,
      context.tr.last30Days,
    ];

    return BlocBuilder<ExpensesFilterCubit, ExpensesFilterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpensesFilterWidgetTextTitle(text: context.tr.sortByDateAdded),
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: context.customColor.border),
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: List.generate(3, (index) {
                  return _buildSortByDateWidgetChild(
                    context: context,
                    text: storedBy[index],
                    index: index,
                    value: state.sortBy,
                    onClick: () {
                      log('Selected Time: ${TimeKeys.values[index]}');

                      context.read<ExpensesFilterCubit>().updateSortBy(
                        TimeKeys.values[index],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortByDateWidgetChild({
    required BuildContext context,
    required String text,
    required VoidCallback onClick,
    required int index,
    required Map<TimeKeys, bool> value,
    bool showUnderLine = true,
  }) {
    final isSelected = value[TimeKeys.values[index]] ?? false;

    return AppGestureDetectorButton(
      onTap: onClick,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: AppStyles.s13W400.copyWith(
                  color: context.customColor.text1,
                ),
              ),
              Container(
                width: 18.h,
                height: 18.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.theme.primaryColor
                      : Colors.transparent,
                  border: Border.all(color: context.customColor.border),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          if (showUnderLine) ...[
            13.verticalSpace,
            const CustomDivider(),
            13.verticalSpace,
          ],
        ],
      ),
    );
  }
}
