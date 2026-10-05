import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/select_filter_account_statement/select_filter_account_statement_cubit.dart';
import '../cubit/select_filter_account_statement/select_filter_account_statement_state.dart';

class CustodyPersonalAccountStatementFilterSortByDateSection
    extends StatefulWidget {
  const CustodyPersonalAccountStatementFilterSortByDateSection({super.key});

  @override
  State<CustodyPersonalAccountStatementFilterSortByDateSection> createState() =>
      _CustodyPersonalAccountStatementFilterSortByDateSectionState();
}

class _CustodyPersonalAccountStatementFilterSortByDateSectionState
    extends State<CustodyPersonalAccountStatementFilterSortByDateSection> {
  late final ScrollController _leftScrollController;
  late final ScrollController _rightScrollController;

  @override
  void initState() {
    super.initState();

    _leftScrollController = ScrollController();
    _rightScrollController = ScrollController();
  }

  @override
  void dispose() {
    _leftScrollController.dispose();
    _rightScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 326.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(vertical: 10.r),
      child: Row(
        children: [
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll<Color>(
                  context.customColor.text1,
                ),
                trackColor: WidgetStatePropertyAll<Color>(
                  context.customColor.text2,
                ),
                trackBorderColor: const WidgetStatePropertyAll<Color>(
                  Colors.transparent,
                ),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _leftScrollController,
                thickness: 6.r,
                trackVisibility: true,
                radius: Radius.circular(1000.r),
                child:
                    BlocBuilder<
                      SelectFilterAccountStatementCubit,
                      SelectFilterAccountStatementState
                    >(
                      builder: (context, mainState) {
                        return ListView.builder(
                          controller: _leftScrollController,
                          itemCount: mainState.months.length,
                          itemBuilder: (context, index) {
                            return AppGestureDetectorButton(
                              onTap: () {
                                context
                                    .read<SelectFilterAccountStatementCubit>()
                                    .setMonth(mainState.months[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: index != 11
                                      ? Border(
                                          bottom: BorderSide(
                                            color: context.customColor.border,
                                          ),
                                        )
                                      : null,
                                ),
                                padding: EdgeInsets.all(16.r),
                                child:
                                    BlocSelector<
                                      SelectFilterAccountStatementCubit,
                                      SelectFilterAccountStatementState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.selectedMonth ==
                                          state.months[index],
                                      builder: (context, state) {
                                        return Text(
                                          mainState.months[index],
                                          style: AppStyles.s12W500.copyWith(
                                            color: state
                                                ? context.theme.primaryColor
                                                : context.customColor.text1,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          ),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStatePropertyAll<Color>(
                  context.customColor.text1,
                ),
                trackColor: WidgetStatePropertyAll<Color>(
                  context.customColor.text2,
                ),
                trackBorderColor: const WidgetStatePropertyAll<Color>(
                  Colors.transparent,
                ),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _rightScrollController,
                thickness: 6.r,
                trackVisibility: true,
                radius: Radius.circular(1000.r),
                child:
                    BlocBuilder<
                      SelectFilterAccountStatementCubit,
                      SelectFilterAccountStatementState
                    >(
                      builder: (context, mainState) {
                        return ListView.builder(
                          itemCount: mainState.years.length,
                          controller: _rightScrollController,
                          itemBuilder: (context, index) {
                            return AppGestureDetectorButton(
                              onTap: () {
                                context
                                    .read<SelectFilterAccountStatementCubit>()
                                    .setYear(mainState.years[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: index != 11
                                      ? Border(
                                          bottom: BorderSide(
                                            color: context.customColor.border,
                                          ),
                                        )
                                      : null,
                                ),
                                padding: EdgeInsets.all(16.r),
                                child:
                                    BlocSelector<
                                      SelectFilterAccountStatementCubit,
                                      SelectFilterAccountStatementState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.selectedYear ==
                                          state.years[index],
                                      builder: (context, state) {
                                        return Text(
                                          '${mainState.years[index]}',
                                          style: AppStyles.s12W500.copyWith(
                                            color: state
                                                ? context.theme.primaryColor
                                                : context.customColor.text1,
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
