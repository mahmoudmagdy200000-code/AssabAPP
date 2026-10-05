import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/choose_item/choose_item_state.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/inventory/domain/strategies/wasted_problem_type_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WastedDamageDetailsProblemTypeSection extends StatelessWidget {
  final String itemId;

  const WastedDamageDetailsProblemTypeSection({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        spacing: 8.h,
        children: [
          LabelTextField(text: context.tr.problemType),
          Column(
            spacing: 8.h,
            children: List.generate(2, (index) {
              final icons = [AppAssets.waste, AppAssets.broken];
              final texts = [context.tr.waste, context.tr.damage];
              final problemsType = [
                WasteProblemTypeStrategy(),
                DamageProblemTypeStrategy(),
              ];

              return AppGestureDetectorButton(
                onTap: () {
                  final validationCubit = context.read<ValidationCubit>();

                  context.read<ChooseItemCubit>().selectItem(index);

                  validationCubit.validateFieldAndStoreTypedValue<
                    WastedProblemTypeStrategy
                  >(
                    fieldName: 'problemType_$itemId',
                    value: problemsType[index],
                    isValid: true,
                  );

                  if (index == 1) {
                    validationCubit.addDynamicFields({
                      'causeOfDamageType_$itemId',
                    });
                  } else {
                    // Switching to "waste": clear all damage-related keys.
                    final damageSectionKeys = {
                      'causeOfDamageType_$itemId',
                      'employees_$itemId',
                    };
                    validationCubit.removeDynamicFields(damageSectionKeys);

                    // Also remove typed values that the damage flow stored.
                    for (final key in [
                      'causeOfDamageType_$itemId',
                      'selectedEmployees_$itemId',
                      'employeeQuantities_$itemId',
                    ]) {
                      if (validationCubit.typedFieldExists(key)) {
                        validationCubit.removeTypedField(key);
                      }
                    }
                  }
                },
                child: BlocSelector<ChooseItemCubit, ChooseItemState, bool>(
                  selector: (state) => state.selectedIndex == index,
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: state
                              ? context.theme.primaryColor
                              : context.customColor.border,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.r,
                        vertical: 12.r,
                      ),
                      child: Row(
                        spacing: 10.w,
                        children: [
                          AppSvg(
                            assetName: icons[index],
                            width: 16.r,
                            colorFilter: ColorFilter.mode(
                              context.customColor.text3,
                              BlendMode.srcIn,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              texts[index],
                              style: AppStyles.s14W600.copyWith(
                                color: state
                                    ? context.theme.primaryColor
                                    : context.customColor.text3,
                              ),
                            ),
                          ),
                          SelectionCircule(isSelected: state),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
