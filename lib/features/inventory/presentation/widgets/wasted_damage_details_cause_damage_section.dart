import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/inventory/domain/strategies/cause_of_damage_strategy.dart';
import 'package:assab/features/inventory/presentation/widgets/wasted_cause_of_damage_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'wasted_damage_details_responsible_employees_widget.dart';
import '../../data/models/wasted_damage_items_response.dart';

class WastedDamageDetailsCauseDamageSection extends StatelessWidget {
  final String? itemId;
  final WastedDamageItemData? item;

  const WastedDamageDetailsCauseDamageSection({
    super.key,
    this.itemId,
    this.item,
  });

  String _key(String base) => itemId != null ? '${base}_$itemId' : base;

  void _handleOpenCauseOfDamageBottomSheet(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.show(
      context,
      (context) => MultiBlocProvider(
        providers: [BlocProvider.value(value: validationCubit)],
        child: WastedCauseOfDamageBottomSheet(itemId: itemId, item: item),
      ),
    );
  }

  void _handleAddResponsibleEmployee(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();
    final chooseItemCubit = context.read<ChooseItemCubit>();

    final CauseOfDamageStrategy? causeOfDamageStrategy = validationCubit.state
        .getTypedValue<CauseOfDamageStrategy>(_key('causeOfDamageType'));

    if (causeOfDamageStrategy == null) {
      return;
    }

    AppBottomSheet.customPageRoute(
      context,
      (context) => causeOfDamageStrategy.buildBottomSheetAddButton(
        validationCubit: validationCubit,
        chooseItemCubit: chooseItemCubit,
        itemId: itemId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChooseItemCubit>(),
      child: Column(
        children: [
          8.verticalSpace,
          Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.assignResponsibility,
                  style: AppStyles.s12W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                9.verticalSpace,
                AppGestureDetectorButton(
                  onTap: () => _handleOpenCauseOfDamageBottomSheet(context),
                  child: ContainerCustomTextField(
                    label: context.tr.causeOfDamage,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 10.r,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              BlocSelector<
                                ValidationCubit,
                                ValidationState,
                                CauseOfDamageStrategy?
                              >(
                                selector: (state) =>
                                    state.getTypedValue<CauseOfDamageStrategy>(
                                      _key('causeOfDamageType'),
                                    ),
                                builder: (context, state) {
                                  return state?.buildLabel(context) ??
                                      Text(
                                        context.tr.choose,
                                        style: AppStyles.s12W400.copyWith(
                                          color: context.customColor.text3,
                                        ),
                                      );
                                },
                              ),
                        ),
                        5.horizontalSpace,
                        Icon(Icons.keyboard_arrow_down_rounded, size: 20.r),
                      ],
                    ),
                  ),
                ),
                BlocSelector<
                  ValidationCubit,
                  ValidationState,
                  CauseOfDamageStrategy?
                >(
                  selector: (state) =>
                      state.getTypedValue<CauseOfDamageStrategy>(
                        _key('causeOfDamageType'),
                      ),
                  builder: (context, state) {
                    return state?.buildWidget(
                          context,
                          itemId: itemId,
                          item: item,
                        ) ??
                        const SizedBox.shrink();
                  },
                ),
                BlocBuilder<ValidationCubit, ValidationState>(
                  builder: (context, validationState) {
                    final selectedEmployees =
                        validationState.getTypedValue<List<dynamic>>(
                          _key('selectedEmployees'),
                        ) ??
                        [];

                    if (selectedEmployees.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        10.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: LabelTextField(
                                text: context.tr.responsibleEmployeess,
                              ),
                            ),
                            10.horizontalSpace,
                            ButtonTextIcon(
                              label: context.tr.add,
                              icon: AppSvg(
                                assetName: AppAssets.add,
                                width: 12.r,
                                colorFilter: ColorFilter.mode(
                                  context.theme.primaryColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              textColor: context.theme.primaryColor,
                              borderColor: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(10.r),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              onTap: () =>
                                  _handleAddResponsibleEmployee(context),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                WastedDamageDetailsResponsibleEmployeesWidget(
                  itemId: itemId,
                  item: item,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
