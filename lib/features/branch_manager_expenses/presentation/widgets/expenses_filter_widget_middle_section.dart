import 'dart:developer';

import 'package:assab/core/enums/filter_status.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/expenses_filter/expenses_filter_cubit.dart';
import '../cubit/expenses_filter/expenses_filter_state.dart';
import 'expenses_filter_text_button.dart';
import 'expenses_filter_widget_text_title.dart';

class ExpensesFilterWidgetMiddleSection extends StatelessWidget {
  const ExpensesFilterWidgetMiddleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List buttons = [
      context.tr.pending,
      context.tr.approved,
      context.tr.rejected,
    ];

    return BlocBuilder<ExpensesFilterCubit, ExpensesFilterState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpensesFilterWidgetTextTitle(text: context.tr.status),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ExpensesFilterTextButton(
                          isSelected:
                              state.status[FilterStatus.values[index]] ?? false,
                          onClick: () {
                            log(
                              'Selected Status: ${FilterStatus.values[index]}',
                            );

                            context.read<ExpensesFilterCubit>().updateStatus(
                              FilterStatus.values[index],
                            );
                          },
                          text: buttons[index],
                        ),
                      ),
                      if (index != 2) 8.horizontalSpace,
                    ],
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
