import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/styles/app_styles.dart';

class ExpenseDetailsTaps extends StatelessWidget {
  const ExpenseDetailsTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(1000.r),
      ),
      padding: EdgeInsets.all(6.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final titles = [
            context.tr.details,
            context.tr.timelines,
            context.tr.approval,
          ];

          return BlocSelector<PagingCubit, PagingState, int>(
            selector: (state) => state.currentIndex,
            builder: (context, currentIndex) {
              return AppGestureDetectorButton(
                onTap: () => context.read<PagingCubit>().goToStep(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: index == currentIndex
                        ? context.customColor.reversedTextColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 7.r,
                    horizontal: 20.r,
                  ),
                  child: Text(
                    titles[index],
                    style: AppStyles.s13W500.copyWith(
                      color: currentIndex == index
                          ? context.customColor.text1
                          : context.customColor.text3,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
