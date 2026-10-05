import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../../../../core/widgets/label_text_field.dart';
import '../../domain/enums/fixed_assets_transfers_and_disposal_enum.dart';

class FixedAssetsTransfersAndDisposalTransferDetailsSection
    extends StatelessWidget {
  const FixedAssetsTransfersAndDisposalTransferDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      ValidationCubit,
      ValidationState,
      FixedAssetsTransfersAndDisposalEnum?
    >(
      selector: (state) {
        return state.getTypedValue<FixedAssetsTransfersAndDisposalEnum>(
          'requestType',
        );
      },
      builder: (context, state) {
        if (state != FixedAssetsTransfersAndDisposalEnum.transferToBranch) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            LabelTextField(
              text: context.tr.transferDetails,
              isLabelOptional: false,
              isLabelRequired: false,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: context.customColor.border),
              ),
              padding: EdgeInsets.all(12.r),
              child: Row(
                children: [
                  BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) =>
                        state.getTypedValue<bool>('transferDetails') ?? false,
                    builder: (context, state) {
                      return AppCheckBox(
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreTypedValue<bool>(
                                fieldName: 'transferDetails',
                                value: value,
                                isValid: value,
                              );
                        },
                        value: state,
                      );
                    },
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      context.tr.skipConfirmationAlreadyAgreedWithReceiver,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
