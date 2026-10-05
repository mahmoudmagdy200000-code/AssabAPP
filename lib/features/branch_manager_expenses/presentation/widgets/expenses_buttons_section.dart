import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/custom_text_button.dart';

class ExpensesButtonsSection extends StatelessWidget {
  final void Function(int currentIndex) onClickBack;
  final void Function(int currentIndex) onClickSaveToDraft;
  final void Function(int currentIndex) onClickNextInvoice;
  final void Function() onClickSubmitInvoice;
  final bool Function(ValidationState state, int currentIndex) selector;

  const ExpensesButtonsSection({
    super.key,
    required this.onClickBack,
    required this.onClickSaveToDraft,
    required this.onClickNextInvoice,
    required this.onClickSubmitInvoice,
    required this.selector,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagingCubit, PagingState>(
      builder: (context, state) {
        final currentIndex = state.currentIndex;

        return Row(
          children: [
            if (currentIndex != 0) ...[
              Expanded(
                child: currentIndex == state.totalSteps - 1
                    ? CustomTextButton(
                        text: context.tr.saveToDraft,
                        onTap: () => onClickSaveToDraft(currentIndex),
                        textColor: context.customColor.text1,
                        borderRadius: 1000.r,
                        padding: EdgeInsets.symmetric(vertical: 17.r),
                      )
                    : CustomTextButton(
                        text: context.tr.back,
                        onTap: () => onClickBack(currentIndex),
                        textColor: context.customColor.text1,
                        borderRadius: 1000.r,
                        padding: EdgeInsets.symmetric(vertical: 17.r),
                      ),
              ),
              16.horizontalSpace,
            ],
            Expanded(
              child: BlocSelector<ValidationCubit, ValidationState, bool>(
                selector: (state) => selector(state, currentIndex),
                builder: (context, enableButton) {
                  final isLastStep = currentIndex == state.totalSteps - 1;

                  return AppButton(
                    onClick: () => isLastStep
                        ? onClickSubmitInvoice()
                        : onClickNextInvoice(currentIndex),
                    enabled: enableButton,
                    text: isLastStep
                        ? context.tr.submitInvoice
                        : context.tr.next,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
