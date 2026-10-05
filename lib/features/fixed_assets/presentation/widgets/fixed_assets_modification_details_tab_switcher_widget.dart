import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/cubits/paging_cubit/paging_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FixedAssetsModificationDetailsTabSwitcherWidget extends StatelessWidget {
  const FixedAssetsModificationDetailsTabSwitcherWidget({super.key});

  List<String> tabTitles(BuildContext context) => [
    context.tr.details,
    context.tr.timelines,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PagingCubit, PagingState, int>(
      selector: (state) => state.currentIndex,
      builder: (context, currentIndex) {
        return ContainerCustomTextField(
          padding: EdgeInsets.all(6.r),
          borderRadius: BorderRadius.circular(1000.r),
          borderColor: Colors.transparent,
          child: Row(
            children: List.generate(tabTitles(context).length, (index) {
              return Expanded(
                child: CustomTextButton(
                  text: tabTitles(context)[index],
                  onTap: () => context.read<PagingCubit>().goToStep(index),
                  backgroundColor: currentIndex == index
                      ? context.customColor.reversedTextColor
                      : Colors.transparent,
                  borderColor: Colors.transparent,
                  textColor: currentIndex == index
                      ? context.customColor.text1
                      : context.customColor.text3,
                  borderRadius: 1000.r,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
