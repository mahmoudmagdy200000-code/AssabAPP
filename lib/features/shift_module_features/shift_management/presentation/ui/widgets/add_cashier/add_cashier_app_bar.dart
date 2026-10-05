import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/animated_container_of_paging_widget.dart';
import 'package:assab/core/widgets/custom_paging_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCashierTopSection extends StatelessWidget {
  const AddCashierTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final title = <String>[
      context.tr.info,
      context.tr.workingShift,
      context.tr.summary,
    ];

    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) {
            return Row(
              children: [
                CustomPagingWidget(
                  condition: index == currentIndex,
                  text: title[index],
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.r,
                    vertical: 5.r,
                  ),
                ),
                AnimatedContainerOfPagingWidget(
                  condition: index == currentIndex,
                  width: 80.r,
                  color: context.theme.primaryColor,
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
