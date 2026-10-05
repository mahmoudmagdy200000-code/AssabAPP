import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/calendar_cubit/calendar_cubit_cubit.dart';
import '../cubits/calendar_cubit/calendar_cubit_state.dart';
import '../styles/app_styles.dart';
import 'custom_divider.dart';

class CustomCalendar extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CustomCalendar({super.key, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CalendarCubit>(),
      child: _CalendarView(onDateSelected: onDateSelected),
    );
  }
}

class _CalendarView extends StatelessWidget {
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarView({required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return BlocConsumer<CalendarCubit, CalendarState>(
      listenWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate,
      listener: (context, state) {
        onDateSelected(state.selectedDate);
      },
      builder: (context, state) {
        final cubit = context.read<CalendarCubit>();
        final firstDayOfMonth = DateTime(
          state.displayedDate.year,
          state.displayedDate.month,
          1,
        );
        final daysInMonth = DateTime(
          state.displayedDate.year,
          state.displayedDate.month + 1,
          0,
        ).day;
        final weekdayOffset = (firstDayOfMonth.weekday) % 7;
        final totalCells = weekdayOffset + daysInMonth;
        final weeks = (totalCells / 7).ceil();

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.calendar,
                        style: AppStyles.s20W600.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        context.tr.chooseWhenTheExpenseOccurred,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.customColor.text2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      padding: EdgeInsets.symmetric(horizontal: 20.r),
                      borderRadius: BorderRadius.circular(30.r),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: state.selectedMonth,
                      dropdownColor: context.theme.scaffoldBackgroundColor,
                      items: List.generate(
                        12,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            months[index],
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) cubit.changeMonth(value);
                      },
                    ),
                  ),
                ),
                8.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: context.customColor.text2,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      padding: EdgeInsets.symmetric(horizontal: 20.r),
                      borderRadius: BorderRadius.circular(30.r),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: state.selectedYear,
                      dropdownColor: context.theme.scaffoldBackgroundColor,
                      items: List.generate(DateTime.now().year - 2000 + 1, (
                        index,
                      ) {
                        final year = 2000 + index;

                        return DropdownMenuItem(
                          value: year,
                          child: Text(
                            '$year',
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) cubit.changeYear(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            const CustomDivider(),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekdays
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: AppStyles.s14W400.copyWith(
                            color: context.customColor.text6,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            8.verticalSpace,
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(weeks * 7, (index) {
                  final day = index - weekdayOffset + 1;
                  final isValidDay = day > 0 && day <= daysInMonth;
                  final date = DateTime(
                    state.displayedDate.year,
                    state.displayedDate.month,
                    day,
                  );
                  final isSelected = state.selectedDate == date;

                  if (!isValidDay) return const SizedBox.shrink();

                  return GestureDetector(
                    onTap: () => cubit.selectDate(date),
                    child: Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected
                              ? context.theme.primaryColor
                              : context.customColor.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: AppStyles.s14WB.copyWith(
                            color: isSelected
                                ? context.theme.primaryColor
                                : context.customColor.text1,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
