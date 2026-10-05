import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/data_management/date_management/date_management_cubit.dart';
import '../../../../core/cubits/data_management/date_management/date_management_state.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/month_and_year_button_dropdown.dart';
import '../../../../core/widgets/month_and_year_button_dropdown_widget.dart';

class CustodyMonthAndYearSection extends StatelessWidget {
  final void Function(int index) onTapMonth;
  final void Function(int index) onTapYear;

  const CustodyMonthAndYearSection({
    super.key,
    required this.onTapMonth,
    required this.onTapYear,
  });

  void _monthPicker(BuildContext context) {
    const months = DateManagementCubit.shortMonths;
    final cubit = context.read<DateManagementCubit>();

    AppBottomSheet.showModal(context, (context) {
      return MonthAndYearButtonDropdownWidget(
        text: months,
        onTap: (index) {
          onTapMonth(index);
        },
        selectedText: cubit.state.selectedMonth,
      );
    });
  }

  void _yearPicker(BuildContext context) {
    final years = DateManagementCubit.years;
    final cubit = context.read<DateManagementCubit>();

    AppBottomSheet.showModal(context, (context) {
      return MonthAndYearButtonDropdownWidget(
        text: years,
        onTap: (index) {
          onTapYear(index);
        },
        selectedText: cubit.state.selectedYear.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateManagementCubit, DateManagementState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: MonthAndYearButtonDropdown(
                text: state.selectedMonth,
                backgroundColor: context.customColor.reversedTextColor,
                onClick: () => _monthPicker(context),
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: MonthAndYearButtonDropdown(
                text: state.selectedYear.toString(),
                backgroundColor: context.customColor.reversedTextColor,
                onClick: () => _yearPicker(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
