import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/shift_module_features/shift_management/presentation/ui/screens/variance_detect_me_and_or_view.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/variance_detect_mixed_factors_view.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/variance_detect_other_factor_view.dart';

const _reasonForVariance = 'reasonForVariance';
const _attachments = 'attachments';

abstract class VarianceStrategy {
  Widget fieldsWidget() {
    return const SizedBox.shrink();
  }

  void addValidationFields(BuildContext context) {}

  String label(BuildContext context);

  String get type;
}

class IWasResponsibleVarianceStrategy extends VarianceStrategy {
  @override
  String label(BuildContext context) => context.tr.iWasResponsible;

  @override
  String get type => 'self';
}

class MeAndOrVarianceStrategy implements VarianceStrategy {
  @override
  Widget fieldsWidget() {
    return const VarianceDetectMeAndOrView();
  }

  @override
  void addValidationFields(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    validationCubit.addDynamicFields({});

    validationCubit.toggleFieldRequirement(
      _reasonForVariance,
      isRequired: false,
    );
    validationCubit.toggleFieldRequirement(_attachments, isRequired: false);
  }

  @override
  String label(BuildContext context) => context.tr.meAndOrOtherEmployees;

  @override
  String get type => 'self_and_others';
}

class OtherFactorVarianceStrategy implements VarianceStrategy {
  @override
  Widget fieldsWidget() {
    return const VarianceDetectOtherFactorView();
  }

  @override
  void addValidationFields(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({'causeOfVariance'});
  }

  @override
  String label(BuildContext context) => context.tr.otherFactor;

  @override
  String get type => 'other_factors';
}

class MixedFactorVarianceStrategy implements VarianceStrategy {
  @override
  Widget fieldsWidget() {
    return const VarianceDetectMixedFactorsView();
  }

  @override
  void addValidationFields(BuildContext context) {
    context.read<ValidationCubit>().addDynamicFields({'causeOfVariance'});
  }

  @override
  String label(BuildContext context) => context.tr.mixeFactors;

  @override
  String get type => 'mixed';
}
