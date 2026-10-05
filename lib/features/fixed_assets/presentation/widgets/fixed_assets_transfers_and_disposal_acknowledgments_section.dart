import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../../../../core/widgets/app_svg_button.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/label_text_field.dart';

class FixedAssetsTransfersAndDisposalAcknowledgmentsSection
    extends StatelessWidget {
  const FixedAssetsTransfersAndDisposalAcknowledgmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelTextField(text: context.tr.acknowledgments),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: context.customColor.border),
          ),
          padding: EdgeInsets.all(12.r),
          child: Column(
            children: [
              Row(
                children: [
                  BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) =>
                        state.getTypedValue<bool>('acknowledgments1') ?? false,
                    builder: (context, state) {
                      return AppCheckBox(
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreTypedValue<bool>(
                                fieldName: 'acknowledgments1',
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
                      context.tr.iAcknowledgeTransferPolicy,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  AppSvgButton(assetName: AppAssets.receipt, onTap: () {}),
                ],
              ),
              6.verticalSpace,
              const CustomDivider(),
              6.verticalSpace,
              Row(
                children: [
                  BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (state) =>
                        state.getTypedValue<bool>('acknowledgments2') ?? false,
                    builder: (context, state) {
                      return AppCheckBox(
                        onChanged: (value) {
                          context
                              .read<ValidationCubit>()
                              .validateFieldAndStoreTypedValue<bool>(
                                fieldName: 'acknowledgments2',
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
                      context.tr.coordinatedWithReceivingBranch,
                      style: AppStyles.s14W400.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  AppSvgButton(assetName: AppAssets.receipt, onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
