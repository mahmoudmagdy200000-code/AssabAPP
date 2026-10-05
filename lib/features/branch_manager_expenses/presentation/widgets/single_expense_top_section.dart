import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/animated_container_of_paging_widget.dart';
import '../../../../core/widgets/custom_paging_widget.dart';

class SingleExpenseTopSection extends StatelessWidget {
  const SingleExpenseTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final title = <String>[
      context.tr.details,
      context.tr.items,
      context.tr.payment,
      context.tr.summary,
    ];

    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
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
                  width: 40.r,
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
