import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/time_lines_view.dart';
import 'package:assab/features/custody/presentation/widgets/custody_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custody_handover_cashier_details_screen_details_view.dart';

class CustodyHandoverToCashierDetailsScreen extends StatelessWidget {
  const CustodyHandoverToCashierDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text2,
      body: Column(
        children: [
          10.verticalSpace,
          CustodyAppBar(
            title: context.tr.cashHandover,
            subtitle: context.tr.viewDetailsTimelinesAndStatuses,
            titleStyle: AppStyles.s16W600.copyWith(
              color: context.customColor.text1,
            ),
            iconColor: context.customColor.text1,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.r, horizontal: 20.r),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(1000.r),
                    ),
                    padding: EdgeInsets.all(6.r),
                    child: Row(
                      children: List.generate(3, (index) {
                        final texts = [
                          context.tr.details,
                          context.tr.timelines,
                          context.tr.approval,
                        ];

                        return Expanded(
                          child: BlocSelector<PagingCubit, PagingState, bool>(
                            selector: (state) => state.currentIndex == index,
                            builder: (context, state) {
                              return CustomTextButton(
                                text: texts[index],
                                onTap: () {
                                  context.read<PagingCubit>().goToStep(index);
                                },
                                textColor: context.customColor.text1,
                                borderRadius: 1000.r,
                                borderColor: Colors.transparent,
                                backgroundColor: state
                                    ? context.customColor.reversedTextColor
                                    : Colors.transparent,
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  12.verticalSpace,
                  Expanded(
                    child: BlocSelector<PagingCubit, PagingState, int>(
                      selector: (state) => state.currentIndex,
                      builder: (context, state) {
                        return IndexedStack(
                          index: state,
                          children: [
                            const CustodyHandoverCashierDetailsScreenDetailsView(),
                            const TimeLinesView(timelines: []),
                            Center(child: Text(context.tr.approval)),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
