import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/animated_container_of_paging_widget.dart';
import '../../../../core/widgets/custom_paging_widget.dart';

class ReceiveOrderScreenTopSection extends StatelessWidget {
  final List<String> titles;

  const ReceiveOrderScreenTopSection({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PagingCubit, PagingState, int>(
      selector: (state) => state.currentIndex,
      builder: (context, currentIndex) {
        return SizedBox(
          height: 33.h,
          child: ListView.builder(
            itemCount: titles.length,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  CustomPagingWidget(
                    condition: index == currentIndex,
                    text: titles[index].toUpperCase(),
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
            },
          ),
        );
      },
    );
  }
}
