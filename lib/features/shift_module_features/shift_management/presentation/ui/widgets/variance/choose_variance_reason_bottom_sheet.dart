import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/helpers/variance_strategy.dart';
import '../../../logic/choose_variance_reason/choose_variance_reason_cubit.dart';
import 'choose_variance_reason_widgte.dart';

class ChooseVarianceReasonBottomSheet extends StatelessWidget {
  const ChooseVarianceReasonBottomSheet({super.key});

  void _selectVarianceReason(
    BuildContext context,
    VarianceStrategy varianceStrategy,
  ) {
    context.read<ChooseVarianceReasonCubit>().setVarianceStrategy(
      varianceStrategy,
    );

    final validationCubit = context.read<ValidationCubit>();

    validationCubit.validateFieldAndStoreValue(
      fieldName: 'responsibilityType',
      value: varianceStrategy.type,
      isValid: true,
    );

    switch (varianceStrategy.type) {
      case 'self':
        validationCubit.toggleFieldRequirement('reason', isRequired: false);
        validationCubit.removeDynamicFields({'responsibleEmployees'});
        break;
      case 'self_and_others':
        validationCubit.addDynamicFields({'responsibleEmployees'});
        validationCubit.toggleFieldRequirement('reason', isRequired: false);
        break;
      case 'other_factors':
        validationCubit.toggleFieldRequirement('reason', isRequired: true);
        validationCubit.removeDynamicFields({'responsibleEmployees'});
        break;
      case 'mixed':
        validationCubit.addDynamicFields({'responsibleEmployees'});
        validationCubit.toggleFieldRequirement('reason', isRequired: false);
        break;
    }

    NavigationService.I.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      child: Column(
        children: [
          Text(
            context.tr.chooseVarianceReason,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          40.verticalSpace,
          ChooseVarianceReasonWidget(
            assetName: AppAssets.personSvg,
            title: context.tr.iWasResponsible,
            desc: context.tr.iWasResponsibleDesc,
            onTap: () => _selectVarianceReason(
              context,
              IWasResponsibleVarianceStrategy(),
            ),
          ),
          15.verticalSpace,
          const CustomDivider(),
          15.verticalSpace,
          ChooseVarianceReasonWidget(
            assetName: AppAssets.team,
            title: context.tr.meAndOrOtherEmployees,
            desc: context.tr.meAndOrOtherEmployeesDesc,
            onTap: () =>
                _selectVarianceReason(context, MeAndOrVarianceStrategy()),
          ),
          15.verticalSpace,
          const CustomDivider(),
          15.verticalSpace,
          ChooseVarianceReasonWidget(
            assetName: AppAssets.bookCheck,
            title: context.tr.otherFactor,
            desc: context.tr.otherFactorDesc,
            onTap: () =>
                _selectVarianceReason(context, OtherFactorVarianceStrategy()),
          ),
          15.verticalSpace,
          const CustomDivider(),
          15.verticalSpace,
          ChooseVarianceReasonWidget(
            assetName: AppAssets.edit,
            title: context.tr.mixeFactors,
            desc: context.tr.mixedFactorsDesc,
            onTap: () =>
                _selectVarianceReason(context, MixedFactorVarianceStrategy()),
          ),
        ],
      ),
    );
  }
}
