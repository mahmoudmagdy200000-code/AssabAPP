import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../../../core/widgets/selection_circule.dart';
import '../../domain/enums/fixed_assets_transfers_and_disposal_enum.dart';
import '../../domain/strategies/fixed_assets_transfers_and_disposal_strategy.dart';

class FixedAssetsTransfersAndDisposalRequestTypeSection
    extends StatelessWidget {
  const FixedAssetsTransfersAndDisposalRequestTypeSection({super.key});

  List<FixedAssetsTransfersAndDisposalStrategy> get strategies => [
    TransferToBranchFixedAssetsTransfersAndDisposalStrategy(),
    DisposalFixedAssetsTransfersAndDisposalStrategy(),
    ExternalTransferFixedAssetsTransfersAndDisposalStrategy(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelTextField(text: context.tr.requestType),
        BlocSelector<
          ValidationCubit,
          ValidationState,
          FixedAssetsTransfersAndDisposalEnum?
        >(
          selector: (state) =>
              state.getTypedValue<FixedAssetsTransfersAndDisposalEnum?>(
                'requestType',
              ),
          builder: (context, selectedType) {
            return Column(
              children: List.generate(strategies.length, (index) {
                final strategy = strategies[index];
                final isSelected = selectedType == strategy.type;

                if (isSelected) {
                  strategy.addValidationFields(context);
                } else {
                  strategy.removeValidationFields(context);
                }

                return AppGestureDetectorButton(
                  onTap: () {
                    context
                        .read<ValidationCubit>()
                        .validateFieldAndStoreTypedValue<
                          FixedAssetsTransfersAndDisposalEnum
                        >(
                          fieldName: 'requestType',
                          value: strategy.type,
                          isValid: true,
                        );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? context.theme.primaryColor
                            : context.customColor.border,
                      ),
                    ),
                    padding: EdgeInsets.all(12.r),
                    margin: EdgeInsets.only(
                      bottom: index == strategies.length - 1 ? 0 : 12.r,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SelectionCircule(isSelected: isSelected),
                            10.horizontalSpace,
                            Expanded(
                              child: Text(
                                strategy.labelText(context),
                                style: AppStyles.s14W400.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isSelected) ...[
                          10.verticalSpace,
                          strategy.buildRequestTypeWidget(context),
                        ],
                      ],
                    ),
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
