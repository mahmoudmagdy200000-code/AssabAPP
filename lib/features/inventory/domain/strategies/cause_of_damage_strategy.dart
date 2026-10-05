import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../data/models/inventory_employee_response.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../presentation/cubit/get_inventory_employee/get_inventory_employee_cubit.dart';
import '../../presentation/widgets/wasted_me_and_other_employee_bottom_sheet.dart';
import '../../presentation/widgets/wasted_mixed_factors_employee_bottom_sheet.dart';

abstract class CauseOfDamageStrategy {
  static CauseOfDamageStrategy getStrategy(String value) {
    switch (value) {
      case 'i_was_responsible':
        return IWasResponsibleStrategy();
      case 'me_and_or_other_employees':
        return MeAndOrOtherEmployeesStrategy();
      case 'other_factor':
        return OtherFactorStrategy();
      case 'mixed_factors':
        return MixeFactorsStrategy();
      default:
        return IWasResponsibleStrategy();
    }
  }

  Widget buildLabel(BuildContext context);

  String get value;

  Widget buildWidget(
    BuildContext context, {
    String? itemId,
    WastedDamageItemData? item,
  }) {
    final key = itemId != null ? 'employees_$itemId' : 'employees';
    context.read<ValidationCubit>().removeDynamicFields({key});

    return const SizedBox.shrink();
  }

  Widget buildBottomSheetAddButton({
    required ChooseItemCubit chooseItemCubit,
    required ValidationCubit validationCubit,
    String? itemId,
  }) {
    return const SizedBox.shrink();
  }
}

class IWasResponsibleStrategy extends CauseOfDamageStrategy {
  @override
  String get value => 'i_was_responsible';

  @override
  Widget buildLabel(BuildContext context) {
    return Text(
      context.tr.iWasResponsible,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
    );
  }
}

class MeAndOrOtherEmployeesStrategy extends CauseOfDamageStrategy {
  @override
  String get value => 'me_and_or_other_employees';

  @override
  Widget buildLabel(BuildContext context) {
    return Text(
      context.tr.meAndOrOtherEmployees,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
    );
  }

  @override
  Widget buildBottomSheetAddButton({
    required ChooseItemCubit chooseItemCubit,
    required ValidationCubit validationCubit,
    String? itemId,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: validationCubit),
        BlocProvider(create: (context) => getIt<GetInventoryEmployeeCubit>()),
        BlocProvider.value(value: chooseItemCubit),
      ],
      child: WastedMeAndOtherEmployeeBottomSheet(itemId: itemId),
    );
  }
}

class OtherFactorStrategy extends CauseOfDamageStrategy {
  @override
  String get value => 'other_factor';

  @override
  Widget buildLabel(BuildContext context) {
    return Text(
      context.tr.otherFactor,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
    );
  }
}

class MixeFactorsStrategy extends CauseOfDamageStrategy {
  @override
  String get value => 'mixed_factors';

  @override
  Widget buildLabel(BuildContext context) {
    return Text(
      context.tr.mixeFactors,
      style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
    );
  }

  @override
  Widget buildWidget(
    BuildContext context, {
    String? itemId,
    WastedDamageItemData? item,
  }) {
    final validationCubit = context.read<ValidationCubit>();
    final empKey = itemId != null ? 'employees_$itemId' : 'employees';
    final selKey = itemId != null
        ? 'selectedEmployees_$itemId'
        : 'selectedEmployees';
    final qtyKey = itemId != null
        ? 'employeeQuantities_$itemId'
        : 'employeeQuantities';
    validationCubit.addDynamicFields({empKey});

    return AppGestureDetectorButton(
      onTap: () {
        validationCubit
            .validateFieldAndStoreTypedValue<List<InventoryEmployee>>(
              fieldName: selKey,
              value: [],
            );
        validationCubit.validateFieldAndStoreTypedValue<List<String>>(
          fieldName: qtyKey,
          value: [],
        );

        AppBottomSheet.customPageRoute(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: validationCubit),
              BlocProvider(
                create: (context) => getIt<GetInventoryEmployeeCubit>(),
              ),
            ],
            child: WastedMixedFactorsEmployeeBottomSheet(
              itemId: itemId,
              item: item,
            ),
          ),
        );
      },
      child: Column(
        children: [
          8.verticalSpace,
          ContainerCustomTextField(
            label: context.tr.responsibleEmployeess,
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
            borderRadius: BorderRadius.circular(12.r),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr.choose,
                    style: AppStyles.s12W500.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                ),
                5.horizontalSpace,
                Icon(Icons.keyboard_arrow_down_rounded, size: 20.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBottomSheetAddButton({
    required ChooseItemCubit chooseItemCubit,
    required ValidationCubit validationCubit,
    String? itemId,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: validationCubit),
        BlocProvider(create: (context) => getIt<GetInventoryEmployeeCubit>()),
      ],
      child: WastedMixedFactorsEmployeeBottomSheet(itemId: itemId),
    );
  }
}
