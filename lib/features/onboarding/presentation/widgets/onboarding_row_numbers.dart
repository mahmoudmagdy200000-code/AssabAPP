import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/widgets/animated_container_of_paging_widget.dart';
import 'package:assab/core/widgets/custom_paging_widget.dart';
import 'package:assab/features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingRowNumbers extends StatelessWidget {
  const OnboardingRowNumbers({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final condition = index == context.watch<OnboardingCubit>().currentPage;

        return Row(
          children: [
            CustomPagingWidget(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: condition
                    ? Border.all(color: context.customColor.text2)
                    : null,
              ),
              condition: condition,
              text: '0${index + 1}',
            ),
            AnimatedContainerOfPagingWidget(condition: condition),
          ],
        );
      }),
    );
  }
}
