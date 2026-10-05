import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/widgets/custom_text_button.dart';

class DetailsTimelinesApprovalRowButtons extends StatelessWidget {
  final List<String> titles;

  const DetailsTimelinesApprovalRowButtons({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(6.r),
      margin: EdgeInsets.symmetric(horizontal: 20.r),
      child: BlocSelector<PagingCubit, PagingState, int>(
        selector: (state) => state.currentIndex,
        builder: (context, state) {
          return Row(
            children: List.generate(titles.length, (index) {
              return Expanded(
                child: CustomTextButton(
                  text: titles[index],
                  onTap: () {
                    context.read<PagingCubit>().goToStep(index);
                  },
                  backgroundColor: state == index
                      ? context.customColor.reversedTextColor
                      : Colors.transparent,
                  borderRadius: 1000.r,
                  borderColor: Colors.transparent,
                  textColor: state == index
                      ? context.customColor.text1
                      : context.customColor.text3,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
