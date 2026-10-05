import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/features/inventory/presentation/cubit/get_inventory_employee/get_inventory_employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/inventory_employee_response.dart';
import '../../data/models/wasted_damage_items_response.dart';
import '../../domain/strategies/cause_of_damage_strategy.dart';
import 'wasted_me_and_other_employee_bottom_sheet.dart';

class WastedCauseOfDamageBottomSheet extends StatelessWidget {
  final String? itemId;
  final WastedDamageItemData? item;

  const WastedCauseOfDamageBottomSheet({super.key, this.itemId, this.item});

  String _key(String base) => itemId != null ? '${base}_$itemId' : base;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.causeOfDamage,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            12.verticalSpace,
            const CustomDivider(),
            12.verticalSpace,
            _buildCauseItem(
              context: context,
              asset: AppAssets.personSvg,
              label: context.tr.iWasResponsible,
              desc:
                  context.tr.theDamageWasDueToMyOwnActionsMistakesOrMishandling,
              onTap: () {
                final validationCubit = context.read<ValidationCubit>();
                validationCubit
                    .validateFieldAndStoreTypedValue<List<InventoryEmployee>>(
                      fieldName: _key('selectedEmployees'),
                      value: [],
                    );

                validationCubit.validateFieldAndStoreTypedValue<List<String>>(
                  fieldName: _key('employeeQuantities'),
                  value: [],
                );

                validationCubit
                    .validateFieldAndStoreTypedValue<CauseOfDamageStrategy>(
                      fieldName: _key('causeOfDamageType'),
                      value: IWasResponsibleStrategy(),
                      isValid: true,
                    );

                NavigationService.I.pop();
              },
            ),
            12.verticalSpace,
            const CustomDivider(),
            20.verticalSpace,
            _buildCauseItem(
              context: context,
              asset: AppAssets.team,
              label: context.tr.meAndOrOtherEmployees,
              desc:
                  context.tr.theDamageWasCausedBySomethingBeyondEmployeeControl,
              onTap: () {
                final validationCubit = context.read<ValidationCubit>();

                validationCubit
                    .validateFieldAndStoreTypedValue<List<InventoryEmployee>>(
                      fieldName: _key('selectedEmployees'),
                      value: [],
                    );
                validationCubit.validateFieldAndStoreTypedValue<List<String>>(
                  fieldName: _key('employeeQuantities'),
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
                    child: WastedMeAndOtherEmployeeBottomSheet(
                      itemId: itemId,
                      item: item,
                    ),
                  ),
                );
              },
            ),
            12.verticalSpace,
            const CustomDivider(),
            20.verticalSpace,
            _buildCauseItem(
              context: context,
              asset: AppAssets.bookCheck,
              label: context.tr.otherFactor,
              desc:
                  context.tr.theDamageWasCausedBySomethingBeyondEmployeeControl,
              onTap: () {
                final validationCubit = context.read<ValidationCubit>();
                validationCubit
                    .validateFieldAndStoreTypedValue<List<InventoryEmployee>>(
                      fieldName: _key('selectedEmployees'),
                      value: [],
                    );
                validationCubit.validateFieldAndStoreTypedValue<List<String>>(
                  fieldName: _key('employeeQuantities'),
                  value: [],
                );
                validationCubit
                    .validateFieldAndStoreTypedValue<CauseOfDamageStrategy>(
                      fieldName: _key('causeOfDamageType'),
                      value: OtherFactorStrategy(),
                      isValid: true,
                    );
                NavigationService.I.pop();
              },
            ),
            12.verticalSpace,
            const CustomDivider(),
            20.verticalSpace,
            _buildCauseItem(
              context: context,
              asset: AppAssets.edit,
              label: context.tr.mixeFactors,
              desc:
                  context.tr.theDamageResultedFromACombinationOfEmployeeActions,
              onTap: () {
                final validationCubit = context.read<ValidationCubit>();
                validationCubit
                    .validateFieldAndStoreTypedValue<List<InventoryEmployee>>(
                      fieldName: _key('selectedEmployees'),
                      value: [],
                    );
                validationCubit.validateFieldAndStoreTypedValue<List<String>>(
                  fieldName: _key('employeeQuantities'),
                  value: [],
                );
                validationCubit
                    .validateFieldAndStoreTypedValue<CauseOfDamageStrategy>(
                      fieldName: _key('causeOfDamageType'),
                      value: MixeFactorsStrategy(),
                      isValid: true,
                    );

                NavigationService.I.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCauseItem({
    required BuildContext context,
    required String asset,
    required String label,
    required String desc,
    required VoidCallback onTap,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.w,
        children: [
          AppSvg(
            assetName: asset,
            width: 16.r,
            colorFilter: ColorFilter.mode(
              context.customColor.text3,
              BlendMode.srcIn,
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      Text(
                        desc,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                24.horizontalSpace,
                AppSvg(
                  assetName: AppAssets.arrowRight,
                  colorFilter: ColorFilter.mode(
                    context.customColor.text1,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
