import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/select_priority/select_priority_cubit.dart';
import '../../../../core/cubits/select_priority/select_priority_state.dart';
import '../../../../core/strategies/priorities_strategy.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../data/models/purchase_create_order_request.dart';

class ChooseBranchSummaryViewPrioritySection extends StatelessWidget {
  final String fieldName;
  final PurchaseCreateOrderRequestBranch branchRequest;

  const ChooseBranchSummaryViewPrioritySection({
    super.key,
    required this.fieldName,
    required this.branchRequest,
  });

  List<PrioritiesStrategy> get _priorities => [
    NormalPriorityStrategy(),
    HighPriorityStrategy(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelTextField(text: context.tr.priority),
        BlocBuilder<SelectPriorityCubit, SelectPriorityState>(
          builder: (context, state) {
            return Row(
              children: List.generate(_priorities.length, (index) {
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextButton(
                          text: _priorities[index].priorityLabel(context),
                          textColor:
                              state.selectedPriority == _priorities[index]
                              ? _priorities[index].color
                              : context.customColor.text1,
                          borderColor:
                              state.selectedPriority?.priorityValue ==
                                  _priorities[index].priorityValue
                              ? _priorities[index].color
                              : context.customColor.border,
                          padding: EdgeInsets.symmetric(
                            vertical: 13.r,
                            horizontal: 20.r,
                          ),
                          onTap: () {
                            context.read<SelectPriorityCubit>().selectPriority(
                              _priorities[index],
                            );

                            context
                                .read<ValidationCubit>()
                                .validateFieldAndStoreValue(
                                  fieldName: fieldName,
                                  value: _priorities[index].priorityValue,
                                  isValid: true,
                                );

                            branchRequest.updatePriority(
                              _priorities[index].priorityValue,
                            );
                          },
                        ),
                      ),
                      if (index != _priorities.length - 1) 12.horizontalSpace,
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
