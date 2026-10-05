import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../../../core/cubits/paging_cubit/paging_state.dart';
import '../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/custom_text_button.dart';
import '../widgets/shift_management_from_app_bar.dart';

class DynamicMultiStepScreen extends StatefulWidget {
  final List<Widget> screens;
  final List<Set<String>> validationFieldsPerStep;
  final String title;
  final VoidCallback? onLastStep;
  final Widget topSectionWidget;

  const DynamicMultiStepScreen({
    super.key,
    required this.screens,
    required this.validationFieldsPerStep,
    required this.title,
    required this.topSectionWidget,
    this.onLastStep,
  });

  @override
  State<DynamicMultiStepScreen> createState() => _DynamicMultiStepScreenState();
}

class _DynamicMultiStepScreenState extends State<DynamicMultiStepScreen> {
  void _changeView(BuildContext context) =>
      context.read<PagingCubit>().nextStep();
  void _goBackView(BuildContext context) =>
      context.read<PagingCubit>().previousStep();

  void _updateValidationFields(
    BuildContext context,
    int currentIndex,
    bool isNext,
  ) {
    final validationCubit = context.read<ValidationCubit>();
    if (currentIndex < 0 ||
        currentIndex >= widget.validationFieldsPerStep.length) {
      return;
    }

    if (isNext) {
      validationCubit.removeDynamicFields(
        widget.validationFieldsPerStep[currentIndex],
      );
    } else {
      validationCubit.addDynamicFields(
        widget.validationFieldsPerStep[currentIndex],
      );
    }
  }

  void _onNextButtonPressed(BuildContext context, int currentIndex) {
    final isLastStep = currentIndex == widget.screens.length - 1;

    if (isLastStep) {
      widget.onLastStep?.call();
    } else {
      _changeView(context);
      _updateValidationFields(context, currentIndex, true);
    }
  }

  void _onBackButtonPressed(BuildContext context, int currentIndex) {
    if (currentIndex == 0) return;
    _goBackView(context);
    _updateValidationFields(context, currentIndex - 1, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            ShiftManagementFromAppBar(text: context.tr.reassign_shift),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      widget.topSectionWidget,
                      14.verticalSpace,
                      Expanded(
                        child: BlocBuilder<PagingCubit, PagingState>(
                          builder: (context, state) {
                            return IndexedStack(
                              index: state.currentIndex,
                              children: widget.screens,
                            );
                          },
                        ),
                      ),
                      16.verticalSpace,
                      BlocBuilder<PagingCubit, PagingState>(
                        builder: (context, state) {
                          final currentIndex = state.currentIndex;

                          return Row(
                            children: [
                              if (currentIndex != 0) ...[
                                Expanded(
                                  child: CustomTextButton(
                                    text: context.tr.back,
                                    onTap: () => _onBackButtonPressed(
                                      context,
                                      currentIndex,
                                    ),
                                    textColor: context.customColor.text1,
                                    borderRadius: 1000.r,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 17.r,
                                    ),
                                  ),
                                ),
                                16.horizontalSpace,
                              ],
                              Expanded(
                                child:
                                    BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      bool
                                    >(
                                      selector: (state) => state.enableButton,
                                      builder: (context, enableButton) {
                                        return AppButton(
                                          onClick: () => _onNextButtonPressed(
                                            context,
                                            currentIndex,
                                          ),
                                          enabled: enableButton,
                                          text:
                                              currentIndex ==
                                                  widget.screens.length - 1
                                              ? context.tr.reassign_shift
                                              : context.tr.next,
                                        );
                                      },
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
