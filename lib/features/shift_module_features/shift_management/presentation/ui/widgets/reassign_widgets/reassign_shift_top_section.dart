import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../../core/widgets/animated_container_of_paging_widget.dart';
import '../../../../../../../core/widgets/custom_paging_widget.dart';

class ReassignShiftTopSection extends StatelessWidget {
  final List titles;

  const ReassignShiftTopSection({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(titles.length, (index) {
            return Row(
              children: [
                CustomPagingWidget(
                  condition: index == currentIndex,
                  text: titles[index],
                  padding: EdgeInsets.symmetric(horizontal: 2.r, vertical: 5.r),
                ),
                AnimatedContainerOfPagingWidget(
                  condition: index == currentIndex,
                  width: 35.r,
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
