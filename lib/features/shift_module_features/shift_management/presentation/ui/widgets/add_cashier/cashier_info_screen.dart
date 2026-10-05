import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_reg_exp.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_field.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/add_cashier/add_cashier_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/di/dependency_injection.dart';
import '../../../../data/repository/shift_management_repository_imp.dart';
import '../../../logic/add_cashier/get_branches_cubit.dart';
import 'branch_selector_bottom_sheet.dart';

class AddCashierInfoWidget extends StatelessWidget {
  const AddCashierInfoWidget({
    super.key,
    required this.fullNameController,
    required this.emailController,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10.h,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr.employeeRole,
                style: AppStyles.s14W500.copyWith(
                  color: context.customColor.text1,
                ),
              ),

              10.verticalSpace,

              Container(
                decoration: BoxDecoration(
                  color: context.customColor.text2,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: context.customColor.border),
                ),
                padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 16.r),
                child: CustomTextField(
                  hintText: context.tr.cashier,
                  isEnabled: false,
                ),
              ),
            ],
          ),

          ContainerCustomTextField(
            label: context.tr.cashierFullName,
            backgroundColor: Colors.white,
            child: CustomTextField(
              maxLength: 30,
              hintText: context.tr.firstNameLastName,
              controller: fullNameController,
              onChanged: (value) {
                context.read<ValidationCubit>().validateFieldAndStoreValue(
                  fieldName: 'cashierName',
                  value: value,
                  isValid: true,
                );
              },
            ),
          ),

          BlocSelector<ValidationCubit, ValidationState, bool?>(
            selector: (state) => state.fieldsValidity['email'],
            builder: (context, state) {
              final isValid = state;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContainerCustomTextField(
                    label: context.tr.cashierEmail,
                    backgroundColor: Colors.white,
                    borderColor: isValid == null || isValid
                        ? null
                        : context.customColor.error,
                    child: CustomTextField(
                      maxLength: 30,
                      hintText: context.tr.hintEmail,
                      controller: emailController,
                      onChanged: (value) => context
                          .read<ValidationCubit>()
                          .validateFieldAndStoreValue(
                            fieldName: 'email',
                            isValid: AppRegExp.emailValidator(value),
                            value: value,
                          ),
                    ),
                  ),

                  isValid == null || isValid
                      ? const SizedBox.shrink()
                      : Column(
                          children: [
                            10.verticalSpace,
                            Text(
                              context.tr.emailNotValid,
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.error,
                              ),
                            ),
                          ],
                        ),
                ],
              );
            },
          ),

          ContainerCustomTextField(
            label: context.tr.storeBranchLabel,
            backgroundColor: Colors.white,
            child: AppGestureDetectorButton(
              onTap: () => _openBranchSelector(
                context: context,
                onConfirm: (name, id) {
                  context.read<AddCashierCubit>().storeBranch = name;
                  context.read<AddCashierCubit>().selectedBranchId = id;
                },
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocSelector<ValidationCubit, ValidationState, String?>(
                          selector: (state) => state.fieldsValue['storeBranch'],
                          builder: (context, selectedBranch) {
                            selectedBranch ??= '';
                            return Text(
                              selectedBranch.isNotEmpty
                                  ? selectedBranch
                                  : context.tr.selectBranch,
                              style: AppStyles.s14W400.copyWith(
                                color: selectedBranch.isEmpty
                                    ? context.customColor.text3
                                    : context.customColor.text1,
                              ),
                            );
                          },
                        ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.customColor.text1,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openBranchSelector({
    required BuildContext context,
    required Function(String, String) onConfirm,
  }) {
    final validationCubit = context.read<ValidationCubit>();

    AppBottomSheet.showModal(
      context,
      (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                GetBranchesCubit(getIt<ShiftManagementRepositoryImp>()),
          ),
          BlocProvider.value(value: validationCubit),
        ],
        child: BranchSelectorBottomSheet(onConfirm: onConfirm),
      ),

      isScrollControlled: true,
    );
  }
}
