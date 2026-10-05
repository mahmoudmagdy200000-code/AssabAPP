import 'dart:developer' as AppLogger;

import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/get_cashier/get_cashier_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/get_cashier/get_cashier_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../domain/entity/cashier_entity.dart';
import '../../../logic/choose_employee/choose_employee_cubit.dart';
import '../../../logic/choose_employee/choose_employee_state.dart';

class SelectResponsibleEmployeeBottomSheet extends StatelessWidget {
  const SelectResponsibleEmployeeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 40.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.chooseEmployees,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            12.verticalSpace,
            Text(
              context.tr.chooseEmployeesDesc,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            12.verticalSpace,
            const CustomDivider(),
            12.verticalSpace,
            Row(
              children: [
                AppSvg(assetName: AppAssets.search, width: 20.w),
                10.horizontalSpace,
                Expanded(
                  child: CustomTextField(
                    hintText: context.tr.searchForEmployeeByName,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            const CustomDivider(),
            12.verticalSpace,
            Expanded(
              child: BlocBuilder<GetCashierCubit, GetCashierState>(
                builder: (context, state) {
                  final cashiers = <CashierEntity>[];

                  if (state is GetCashierLoading) {
                    return const AppLoadingWidget();
                  } else if (state is GetCashierFailure) {
                    return AppFailureWidget(failure: state.failure);
                  } else if (state is GetCashierSuccess) {
                    cashiers.addAll(state.cashier);
                  }

                  if (cashiers.isEmpty) {
                    return Center(
                      child: Text(
                        context.tr.no_cashiers,
                        style: AppStyles.s16W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: cashiers.length,
                    itemBuilder: (context, index) {
                      return BlocSelector<
                        ChooseEmployeeCubit,
                        ChooseEmployeeState,
                        Map<CashierEntity, bool>
                      >(
                        selector: (state) => state.selectedEmployees,
                        builder: (context, selectState) {
                          final cashier = cashiers[index];
                          final isSelected = selectState[cashier] ?? false;

                          return AppGestureDetectorButton(
                            onTap: () {
                              final chooseEmployeeCubit = context
                                  .read<ChooseEmployeeCubit>();

                              if (isSelected) {
                                chooseEmployeeCubit.removeEmployee(cashier);
                                context
                                    .read<ValidationCubit>()
                                    .removeDynamicFields({
                                      cashier.id.toString(),
                                    });
                              } else {
                                chooseEmployeeCubit.selectEmployee(cashier);
                                context
                                    .read<ValidationCubit>()
                                    .addDynamicFields({cashier.id.toString()});
                              }
                            },
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppSvg(
                                      assetName: AppAssets.noProfile,
                                      width: 40.w,
                                    ),
                                    12.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cashier.name,
                                            style: AppStyles.s14W500.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          ),
                                          4.verticalSpace,
                                          Text(
                                            cashier.branch.name,
                                            style: AppStyles.s12W400.copyWith(
                                              color: context.customColor.text3,
                                            ),
                                          ),
                                          4.verticalSpace,
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                color:
                                                    context.customColor.border,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15.w,
                                              vertical: 10.h,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: CustomTextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      AppLogger.log(
                                                        'Cashier ID: ${cashier.id.toString()}',
                                                      );
                                                      context
                                                          .read<
                                                            ValidationCubit
                                                          >()
                                                          .validateFieldAndStoreValue(
                                                            fieldName: cashier
                                                                .id
                                                                .toString(),
                                                            value: value,
                                                            isValid: value
                                                                .isNotEmpty,
                                                          );
                                                    },
                                                  ),
                                                ),
                                                10.horizontalSpace,
                                                const SaudiRiyalSvgWidget(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    SelectionCircule(isSelected: isSelected),
                                  ],
                                ),
                                if (index != 4) ...[
                                  12.verticalSpace,
                                  const CustomDivider(),
                                  12.verticalSpace,
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            12.verticalSpace,
            BlocBuilder<ValidationCubit, ValidationState>(
              builder: (context, validationState) {
                return BlocBuilder<ChooseEmployeeCubit, ChooseEmployeeState>(
                  builder: (context, state) {
                    final chooseEmployeeState = state.selectedEmployees;

                    final validSelection = chooseEmployeeState.values
                        .where((e) => e)
                        .toList();

                    final validSelectionBool = validSelection.length >= 2;

                    final selectedCashierIds = chooseEmployeeState.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key.id.toString())
                        .toSet();

                    final textFieldIsValid = <bool>[];

                    for (final id in selectedCashierIds) {
                      AppLogger.log(
                        'Cashier fieldsValidity: ${validationState.fieldsValidity[id]}',
                      );

                      textFieldIsValid.add(
                        validationState.fieldsValidity[id] ?? false,
                      );
                    }

                    final allFieldsValid =
                        textFieldIsValid.isNotEmpty &&
                        textFieldIsValid.every((isValid) => isValid);

                    return AppButton(
                      onClick: () {
                        NavigationService.I.pop();
                      },
                      enabled: validSelectionBool && allFieldsValid,
                      borderRadius: BorderRadius.circular(15.r),
                      text: validSelectionBool
                          ? '${context.tr.confirm} ${validSelection.length} ${context.tr.selection}'
                          : context.tr.youNeedToSelectAtLeastTwoPeople,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
