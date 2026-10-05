import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/features/shift_module_features/shift_management/data/model/cashier_model.dart';
import 'package:assab/features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_info_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/cashier/cashier_update_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/filters/cashier_filter/cashier_status_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../../../../core/cubits/validation/validation_state.dart';
import '../../../../../../../core/services/navigation/navigation_service.dart';
import '../../../../../../../core/styles/app_styles.dart';
import '../../../../../../../core/utils/app_bottom_sheet.dart';
import '../../../../../../../core/utils/app_reg_exp.dart';
import '../../../../../../../core/widgets/app_button.dart';
import '../../../../../../../core/widgets/app_failure_widget.dart';
import '../../../../../../../core/widgets/app_loading_widget.dart';
import '../../../../../../../core/widgets/container_custom_text_field.dart';
import '../../../logic/add_cashier/get_available_cashier_shifts_cubit.dart';
import '../../../logic/add_cashier/get_branches_cubit.dart';
import '../../../logic/cashier/cashier_info_cubit.dart';
import '../../../logic/cashier/cashier_info_state.dart';
import '../add_cashier/branch_selector_bottom_sheet.dart';
import '../add_cashier/select_working_shifts.dart';
import 'cashier_info_container_widget.dart';
import 'cashier_info_editing_value_widget.dart';
import 'cashier_info_row_widget.dart';
import 'cashier_info_status_dropdown.dart';

class CashierProfileBottomSheet extends StatelessWidget {
  final String createdByName;
  final String formattedCreatedAt;
  final String cashierId;

  const CashierProfileBottomSheet({
    super.key,
    required this.createdByName,
    required this.formattedCreatedAt,
    required this.cashierId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CashierInfoCubit()),

        BlocProvider(
          create: (_) =>
              CashierUpdateCubit(getIt<ShiftManagementRepositoryImp>())
                ..getCashierDetails(
                  cashierId: cashierId,
                  openedFromChangeShiftButton: false,
                ),
        ),
      ],
      child: _CashierProfileView(
        createdByName: createdByName,
        formattedCreatedAt: formattedCreatedAt,
        cashierId: cashierId,
      ),
    );
    // return BlocProvider(
    //   create: (_) => CashierInfoCubit(),
    //   child: const _CashierProfileView(),
    // );
  }
}

Widget _CashierProfileView({
  required String createdByName,
  required String formattedCreatedAt,
  required String cashierId,
}) {
  return BlocConsumer<CashierUpdateCubit, CashierUpdateState>(
    listener: (context, cashierDetailsState) {
      if (cashierDetailsState is CashierDetailsFetchSuccess) {
        context.read<CashierInfoCubit>().initCashier(
          cashierDetailsState.cashier!,
        );
      }

      if (cashierDetailsState is CashierUpdateSuccess) {
        context.read<CashierInfoCubit>().initCashier(
          cashierDetailsState.cashier!,
        );

        context.read<CashierUpdateCubit>().getCashierDetails(
          cashierId: cashierId,
          openedFromChangeShiftButton: false,
        );
      }
      if (cashierDetailsState is CashierUpdateFailure) {
        AppDialog.showErrorDialog(
          context: context,
          failure: cashierDetailsState.failure,
        );
      }
    },
    builder: (context, cashierDetailsState) {
      if (cashierDetailsState is CashierDetailsFetchLoading) {
        return SizedBox(
          height: 550.h,
          child: const Center(child: AppLoadingWidget()),
        );
      }

      if (cashierDetailsState is CashierDetailsFetchFailure) {
        return Center(
          child: AppFailureWidget(
            failure: cashierDetailsState.failure,
            onRetry: () {
              context.read<CashierUpdateCubit>().getCashierDetails(
                cashierId: cashierId,
              );
            },
          ),
        );
      }

      return BlocBuilder<CashierInfoCubit, CashierInfoState>(
        builder: (context, state) {
          final cubit = context.read<CashierInfoCubit>();

          final cashier = state.cashier!;

          return SizedBox(
            width: double.maxFinite,
            height: 550.h,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.cashierProfile,
                            style: AppStyles.s20W500,
                          ),
                          10.verticalSpace,
                          Text(
                            cashier.status.label == CashierStatus.pending
                                ? context
                                      .tr
                                      .employeeProfileCreatedPendingActivation
                                : context.tr.quickAccessToProfileInfo,
                            style: AppStyles.s14W400,
                          ),
                          10.verticalSpace,

                          SizedBox(
                            width: double.maxFinite,
                            height: 90.h,
                            child: cashier.image != null
                                ? AppNetworkImage(image: cashier.image!)
                                : const AppSvg(assetName: AppAssets.noProfile),
                          ),

                          10.verticalSpace,

                          CashierInfoContainerWidget(
                            title: context.tr.accountDetails,
                            children: [
                              CashierInfoRowWidget(
                                title: context.tr.status_column,

                                value: state.isEditing
                                    ? null
                                    : cashier.status.label,

                                statusColor: state.isEditing
                                    ? null
                                    : cashier.status.textColor,

                                isStatus: !state.isEditing,

                                valueWidget: state.isEditing
                                    ? CashierStatusDropdown(
                                        value: cashier.status,
                                        onSelected: cubit.updateStatus,
                                      )
                                    : null,
                              ),
                              CashierInfoRowWidget(
                                title: context.tr.employeeNameTitle,
                                value: state.isEditing ? null : cashier.name,
                                valueWidget: state.isEditing
                                    ? CashierInfoEditingValueWidget(
                                        initValue: cashier.name,
                                        hintText: context.tr.employeeNameTitle,
                                        errorMsg: context.tr.fieldCannotBeEmpty,
                                        validationFieldName: 'cashierName',
                                        onChanged: (value) {
                                          context
                                              .read<ValidationCubit>()
                                              .validateFieldAndStoreValue(
                                                fieldName: 'cashierName',
                                                isValid: value.isNotEmpty,
                                                value: value,
                                              );
                                        },
                                      )
                                    : null,
                              ),
                              CashierInfoRowWidget(
                                title: context.tr.emailTitle,
                                value: state.isEditing ? null : cashier.email,
                                valueWidget: state.isEditing
                                    ? CashierInfoEditingValueWidget(
                                        initValue: cashier.email,
                                        hintText: context.tr.emailTitle,
                                        validationFieldName: 'email',
                                        errorMsg: context.tr.emailNotValid,
                                        onChanged: (value) {
                                          // onChanged: (value) => context
                                          context
                                              .read<ValidationCubit>()
                                              .validateFieldAndStoreValue(
                                                fieldName: 'email',
                                                isValid:
                                                    AppRegExp.emailValidator(
                                                      value,
                                                    ),
                                                value: value,
                                              );
                                        },
                                      )
                                    : null,
                              ),
                              CashierInfoRowWidget(
                                title: context.tr.roleTitle,
                                value: context.tr.cashier,
                              ),

                              if (cashier.status.label == CashierStatus.pending)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10.h,
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightYellow,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: AppColors.sBlack,
                                        size: 20.h,
                                      ),
                                      10.horizontalSpace,

                                      Expanded(
                                        child: Text(
                                          context
                                              .tr
                                              .employeeProfileCreatedPendingActivation,
                                          style: AppStyles.s13W400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),

                          10.verticalSpace,

                          CashierInfoContainerWidget(
                            title: context.tr.shiftDetails,
                            children: [
                              CashierInfoRowWidget(
                                title: context.tr.storeBranch,
                                value: state.isEditing
                                    ? null
                                    : cashier.branch.name,
                                valueWidget: state.isEditing
                                    ? BlocProvider(
                                        create: (_) => GetBranchesCubit(
                                          getIt<ShiftManagementRepositoryImp>(),
                                        ),
                                        child: SizedBox(
                                          width: 150.w,
                                          child: ContainerCustomTextField(
                                            backgroundColor: Colors.white,
                                            child: AppGestureDetectorButton(
                                              onTap: () => _openBranchSelector(
                                                context: context,
                                                onConfirm: cubit.updateBranch,
                                                initialBranchName:
                                                    cashier.branch.name,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        BlocSelector<
                                                          ValidationCubit,
                                                          ValidationState,
                                                          String?
                                                        >(
                                                          selector: (state) => state
                                                              .fieldsValue['storeBranch'],
                                                          builder:
                                                              (
                                                                context,
                                                                selectedBranch,
                                                              ) {
                                                                selectedBranch ??=
                                                                    cashier
                                                                        .branch
                                                                        .name;

                                                                if (selectedBranch !=
                                                                    cashier
                                                                        .branch
                                                                        .name) {
                                                                  selectedBranch =
                                                                      cashier
                                                                          .branch
                                                                          .name;
                                                                }
                                                                return Text(
                                                                  selectedBranch
                                                                          .isNotEmpty
                                                                      ? selectedBranch
                                                                      : context
                                                                            .tr
                                                                            .selectBranch,
                                                                  style: AppStyles.s14W400.copyWith(
                                                                    color:
                                                                        selectedBranch
                                                                            .isEmpty
                                                                        ? context
                                                                              .customColor
                                                                              .text3
                                                                        : context
                                                                              .customColor
                                                                              .text1,
                                                                  ),
                                                                );
                                                              },
                                                        ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: context
                                                        .customColor
                                                        .text1,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : null,
                                valueHasIcon: true,
                                iconSVGAsset: AppAssets.branchStoreSvg,
                                svgColor: AppColors.cyan,
                              ),

                              CashierInfoRowWidget(
                                title: context.tr.workDays,
                                value: context.tr.sundayThursday,
                              ),
                              CashierInfoRowWidget(
                                title: context.tr.shift,
                                value:
                                    (cashier.workingShifts == null ||
                                        cashier.workingShifts!.isEmpty)
                                    ? 'N/A'
                                    : null,

                                valueWidget:
                                    (cashier.workingShifts != null &&
                                        cashier.workingShifts!.isNotEmpty)
                                    ? state.isEditing
                                          ? SizedBox(
                                              width: 150.w,
                                              child: ContainerCustomTextField(
                                                backgroundColor: Colors.white,
                                                child: AppGestureDetectorButton(
                                                  onTap: () => _openShiftSelector(
                                                    context: context,
                                                    onAction: (shift) {
                                                      cubit.updateShift(shift);
                                                      NavigationService.I.pop();
                                                    },
                                                    initialShiftId:
                                                        (state
                                                                .cashier
                                                                ?.workingShifts
                                                                ?.isNotEmpty ??
                                                            false)
                                                        ? state
                                                              .cashier!
                                                              .workingShifts![0]
                                                              .id
                                                        : null,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            BlocSelector<
                                                              ValidationCubit,
                                                              ValidationState,
                                                              String?
                                                            >(
                                                              selector:
                                                                  (
                                                                    state,
                                                                  ) => state
                                                                      .fieldsValue['selectedShift'],
                                                              builder:
                                                                  (
                                                                    context,
                                                                    selectedShift,
                                                                  ) {
                                                                    final shiftName =
                                                                        (cashier.workingShifts !=
                                                                                null &&
                                                                            cashier.workingShifts!.isNotEmpty)
                                                                        ? cashier
                                                                              .workingShifts![0]
                                                                              .name
                                                                        : '';
                                                                    selectedShift ??=
                                                                        shiftName;

                                                                    if (selectedShift !=
                                                                        shiftName) {
                                                                      selectedShift =
                                                                          shiftName;
                                                                    }
                                                                    return Text(
                                                                      selectedShift
                                                                              .isNotEmpty
                                                                          ? selectedShift
                                                                          : context.tr.selectBranch,
                                                                      style: AppStyles.s14W400.copyWith(
                                                                        color:
                                                                            selectedShift.isEmpty
                                                                            ? context.customColor.text3
                                                                            : context.customColor.text1,
                                                                      ),
                                                                    );
                                                                  },
                                                            ),
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  (cashier.workingShifts !=
                                                              null &&
                                                          cashier
                                                              .workingShifts!
                                                              .isNotEmpty)
                                                      ? cashier
                                                            .workingShifts![0]
                                                            .name
                                                      : '-',
                                                  style: AppStyles.s13W500,
                                                ),
                                                Text(
                                                  (cashier.workingShifts !=
                                                              null &&
                                                          cashier
                                                              .workingShifts!
                                                              .isNotEmpty)
                                                      ? '${cashier.workingShifts![0].startTimeAmPm} - ${cashier.workingShifts![0].endTimeAmPm}'
                                                      : '-',
                                                  style: AppStyles.s13W500,
                                                ),
                                              ],
                                            )
                                    : null,
                              ),
                            ],
                          ),

                          10.verticalSpace,

                          CashierInfoContainerWidget(
                            title: context.tr.creationDetails,
                            children: [
                              CashierInfoRowWidget(
                                title: context.tr.createdBy,
                                value: createdByName,
                                valueHasIcon: true,
                                iconSVGAsset: AppAssets.noProfile,
                              ),
                              CashierInfoRowWidget(
                                title: context.tr.date_columns,
                                value: formattedCreatedAt,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (cashier.status.label != CashierStatus.pending)
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightGray,
                          blurRadius: 15.r,
                          spreadRadius: 2.h,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppGestureDetectorButton(
                          onTap: state.isEditing
                              ? cubit.cancelEdit
                              : () => _openShiftSelector(
                                  context: context,
                                  onAction: (shift) {
                                    cubit.updateShift(shift);
                                    context
                                        .read<CashierUpdateCubit>()
                                        .updateCashier(
                                          openedFromChangeShiftButton: true,
                                          newCashier: cubit.state.cashier!,
                                          originalCashier:
                                              cubit.state.originalCashier!,
                                        );
                                    NavigationService.I.pop();
                                  },
                                  initialShiftId:
                                      (cashier.workingShifts != null &&
                                          cashier.workingShifts!.isNotEmpty)
                                      ? (state
                                                    .cashier
                                                    ?.workingShifts
                                                    ?.isNotEmpty ==
                                                true
                                            ? state
                                                  .cashier!
                                                  .workingShifts![0]
                                                  .id
                                            : '-')
                                      : '',
                                ),
                          child: Container(
                            width: 160.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 15.h,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.lightBackground,
                              border: Border.all(
                                color: context.customColor.border,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: state.isEditing
                                ? Text(
                                    context.tr.cancel,
                                    style: AppStyles.s13W500.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  )
                                : _changeShiftButtonWidget(context),
                          ),
                        ),

                        cashierDetailsState is CashierUpdateLoading
                            ? AppButtonLoading(width: 160.w)
                            : AppButton(
                                width: 160.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 15.h,
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                                onClick: () {
                                  if (state.isEditing) {
                                    _updateCashier(context, cubit);
                                  } else {
                                    _enableEdit(context, cubit, cashier);
                                  }
                                },
                                text: state.isEditing
                                    ? context.tr.save
                                    : context.tr.profileSettings,
                                enabled: state.isEditing
                                    ? _validateSaveButton(context, cubit)
                                    : true,
                              ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

bool _validateSaveButton(BuildContext context, CashierInfoCubit cubit) {
  final validationCubit = context.read<ValidationCubit>();
  final nameIsValid = validationCubit.fieldIsValid('cashierName');
  final emailIsValid = validationCubit.fieldIsValid('email');

  print('loool $nameIsValid $emailIsValid');
  if (nameIsValid && emailIsValid) {
    final email = validationCubit.getFieldValue('email');
    final name = validationCubit.getFieldValue('cashierName');
    final branch = validationCubit.getFieldValue('storeBranch');
    final shift = validationCubit.getFieldValue('selectedShift');
    print('loool $email $name $branch $shift');
    return cubit.hasChanges(
      email: email,
      name: name,
      branchName: branch,
      shiftName: shift,
      status: cubit.state.cashier!.status,
    );
  }

  return false;
}

void _enableEdit(
  BuildContext context,
  CashierInfoCubit cubit,
  CashierEntity cashier,
) {
  context.read<ValidationCubit>().validateFieldAndStoreValue(
    fieldName: 'email',
    value: cashier.email,
    isValid: true,
  );

  context.read<ValidationCubit>().validateFieldAndStoreValue(
    fieldName: 'cashierName',
    value: cashier.name,
    isValid: true,
  );

  if (cashier.workingShifts != null && cashier.workingShifts!.isNotEmpty) {
    context.read<ValidationCubit>().validateFieldAndStoreValue(
      fieldName: 'selectedShift',
      value: cashier.workingShifts?[0].name ?? 'N/A',
      isValid: cashier.workingShifts == null ? false : true,
    );
  }

  context.read<ValidationCubit>().validateFieldAndStoreValue(
    fieldName: 'storeBranch',
    value: cashier.branch.name,
    isValid: true,
  );

  cubit.enableEdit();
}

Row _changeShiftButtonWidget(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      AppSvg(
        assetName: AppAssets.edit,
        width: 15.w,
        height: 15.h,
        colorFilter: const ColorFilter.mode(AppColors.sBlack, BlendMode.srcIn),
      ),

      10.horizontalSpace,

      Text(
        context.tr.changeShift,
        style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
      ),
    ],
  );
}

void _updateCashier(BuildContext context, CashierInfoCubit cubit) {
  final cashierName = context.read<ValidationCubit>().getFieldValue(
    'cashierName',
  );
  final email = context.read<ValidationCubit>().getFieldValue('email');

  cubit.updateEmail(email);
  cubit.updateName(cashierName);

  context.read<CashierUpdateCubit>().updateCashier(
    openedFromChangeShiftButton: false,
    newCashier: cubit.state.cashier!,
    originalCashier: cubit.state.originalCashier!,
  );
}

void _openBranchSelector({
  required BuildContext context,
  required Function(String, String) onConfirm,
  required String? initialBranchName,
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
      child: BranchSelectorBottomSheet(
        onConfirm: onConfirm,
        initialBranchName: initialBranchName,
      ),
    ),

    isScrollControlled: true,
  );
}

void _openShiftSelector({
  required BuildContext context,
  required Function(ShiftInfoDetailsEntity shift) onAction,
  required String? initialShiftId,
}) {
  final validationCubit = context.read<ValidationCubit>();

  AppBottomSheet.showModal(
    context,
    (context) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
        BlocProvider(
          create: (context) => GetAvailableCashierShiftsCubit(
            getIt<ShiftManagementRepositoryImp>(),
          ),
        ),

        BlocProvider.value(value: validationCubit),
      ],
      child: SelectWorkingShiftWidget(
        showButton: true,
        onAction: onAction,
        initialShiftId: initialShiftId,
      ),
    ),
    isScrollControlled: true,
  );
}
