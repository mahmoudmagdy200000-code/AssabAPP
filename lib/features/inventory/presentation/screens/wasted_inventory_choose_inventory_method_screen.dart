import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/daily_inventory_type_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/inventory/data/models/create_wast_and_damage_request.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/create_inventory/create_inventory_cubit.dart';
import '../cubit/create_waste_damage/create_waste_damage_cubit.dart';
import '../cubit/create_waste_damage/create_waste_damage_state.dart';
import '../widgets/inventory_employee_list_bottom_sheet_widget.dart';
import 'inventory_success_screen.dart';
import 'wasted_mandatory_awareness_screen.dart';

class WastedInventoryChooseInventoryMethodScreen extends StatelessWidget {
  const WastedInventoryChooseInventoryMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.wasteAndDamageRegistration,
            subtitle:
                '${DateFormatter.formatDateMDY(DateTime.now())} | ${getIt<SharedPreferencesHelper>().getString('u_name')} (${context.tr.branch})',
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: CustomScrollView(
                slivers: [
                  Text(
                    context.tr.chooseRegistrationMethod,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text4,
                    ),
                  ).sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  _buildPersonalInventoryCard(context).sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  _buildAssignStaffCard(context).sliverBoxAdapter,
                  12.verticalSpace.sliverBoxAdapter,
                  Text(
                    context.tr.quickStatistics,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  Container(
                    decoration: BoxDecoration(
                      color: context.customColor.text2,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.calendar,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text3,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              context.tr.thisMonthSoFarMonth('June 2024'),
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              _buildRow(
                                context: context,
                                title: context.tr.totalWaste,
                                value: '150',
                                isCurrency: true,
                              ),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: context.tr.totalDamage,
                                value: '75',
                                isCurrency: true,
                              ),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: context.tr.numberOfIncidents,
                                value: context.tr.countOfIncidents(12),
                              ),
                              10.verticalSpace,
                              _buildRow(
                                context: context,
                                title: context.tr.savedDrafts,
                                value: context.tr.countOfDraft(1),
                              ),
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            AppSvg(
                              assetName: AppAssets.viewReports,
                              width: 16.r,
                              colorFilter: ColorFilter.mode(
                                context.customColor.text3,
                                BlendMode.srcIn,
                              ),
                            ),
                            5.horizontalSpace,
                            Text(
                              context.tr.comparisonWithPreviousMonth,
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ],
                        ),
                        10.verticalSpace,
                        Container(
                          decoration: BoxDecoration(
                            color: context.customColor.reversedTextColor,
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            spacing: 8.h,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          context.tr.wastes,
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      const AppSvg(
                                        assetName: AppAssets.greenOver,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        '15%',
                                        style: AppStyles.s12W500.copyWith(
                                          color: AppColors.lightGreen,
                                        ),
                                      ),
                                    ],
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    context.tr.decreaseFromLastHour
                                        .toUpperCase(),
                                    style: AppStyles.s10W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          context.tr.damages,
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      const AppSvg(
                                        assetName: AppAssets.redShort,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        '8%',
                                        style: AppStyles.s12W500.copyWith(
                                          color: context.customColor.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                  6.verticalSpace,
                                  Text(
                                    context.tr.increaseFromLastHour
                                        .toUpperCase(),
                                    style: AppStyles.s10W600.copyWith(
                                      color: context.customColor.text1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  Row(
                    children: [
                      Container(
                        width: 5.w,
                        height: 55.h,
                        color: context.theme.primaryColor,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${context.tr.note}💡',
                              style: AppStyles.s14W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              context
                                  .tr
                                  .mandatoryAwarenessScreenWillAppearAfterSelection,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).sliverBoxAdapter,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dotText({required BuildContext context, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.circle, size: 3.r, color: context.customColor.text4),
        7.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text4),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInventoryCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSvg(assetName: AppAssets.personSvg),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.personalInventory,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                6.verticalSpace,
                Text(
                  context.tr.registerWasteDamageYourselfAsBranchManager,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                8.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const AppSvg(assetName: AppAssets.crownSvg),
                          8.horizontalSpace,
                          Text(
                            context.tr.advantages,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      _dotText(
                        context: context,
                        text: context.tr.directResponsibility,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.accuracyInClassification,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.speedInDecisionMaking,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.noAdditionalApprovalNeeded,
                      ),
                    ],
                  ),
                ),
                8.verticalSpace,
                CustomTextButton(
                  text: context.tr.startMyself,
                  onTap: () {
                    final validationCubit = context.read<ValidationCubit>();

                    NavigationService.I.push(
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: validationCubit),
                            BlocProvider(
                              create: (context) =>
                                  getIt<CreateInventoryCubit>(),
                            ),
                          ],
                          child: WastedMandatoryAwarenessScreen(
                            userType: InventoryUserTypeBranchManager(),
                          ),
                        ),
                      ),
                    );
                  },
                  borderRadius: 1000.r,
                  backgroundColor: context.theme.primaryColor,
                  textColor: context.customColor.reversedTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String value,
    bool isCurrency = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        if (isCurrency) const SaudiRiyalSvgWidget(),
        2.horizontalSpace,
        Text(
          value,
          style: AppStyles.s13W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }

  Widget _buildAssignStaffCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.customColor.border),
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 16.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvg(assetName: AppAssets.noCashiers, width: 20.r),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr.assignStaff,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                6.verticalSpace,
                Text(
                  context.tr.chooseAStaffToRegisterWasteDamage,
                  style: AppStyles.s13W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
                8.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const AppSvg(assetName: AppAssets.crownSvg),
                          8.horizontalSpace,
                          Text(
                            context.tr.assignmentDetails,
                            style: AppStyles.s14W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      _dotText(
                        context: context,
                        text: context.tr.assignedStaff,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.responsibilityRemainsWithYouAsManager,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.reviewMandatoryBeforeSending,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.signatureInYourNameAsManager,
                      ),
                    ],
                  ),
                ),
                8.verticalSpace,
                MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {
                          'employeeId',
                          'employeeName',
                          'isSelected',
                        },
                      ),
                    ),
                    BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
                  ],
                  child: Builder(
                    builder: (c) {
                      return AppGestureDetectorButton(
                        onTap: () {
                          final validationCubit = c.read<ValidationCubit>();
                          final chooseItemCubit = c.read<ChooseItemCubit>();

                          chooseItemCubit.initTempSelection();

                          AppBottomSheet.pageRoute(
                            c,
                            (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: chooseItemCubit),
                                BlocProvider.value(value: validationCubit),
                              ],
                              child: const Expanded(
                                child: InventoryEmployeeListBottomSheetWidget(),
                              ),
                            ),
                          );
                        },
                        child: BlocSelector<ValidationCubit, ValidationState, String?>(
                          selector: (state) =>
                              state.fieldsValue['employeeName'],
                          builder: (context, state) {
                            return Column(
                              children: [
                                ContainerCustomTextField(
                                  label: context.tr.employeeStaff,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state ?? context.tr.choose,
                                          style: AppStyles.s12W400.copyWith(
                                            color: state == null
                                                ? context.customColor.text3
                                                : context.customColor.text1,
                                            fontWeight: state == null
                                                ? FontWeight.w400
                                                : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: context.customColor.text1,
                                        size: 16.r,
                                      ),
                                    ],
                                  ),
                                ),
                                8.verticalSpace,
                                BlocConsumer<
                                  CreateWasteDamageCubit,
                                  CreateWasteDamageState
                                >(
                                  listener: (context, state) {
                                    if (state is CreateWasteDamageSuccess) {
                                      NavigationService.I.popUntil(
                                        (p1) =>
                                            p1.settings.name ==
                                            AppRouteName.inventoryScreen,
                                      );
                                      AppBottomSheet.customPageRoute(
                                        context,
                                        (context) => InventorySuccessScreen(
                                          title: context.tr.reportSaved,
                                          desc: context.tr.reportSavedDesc,
                                        ),
                                      );
                                    } else if (state
                                        is CreateWasteDamageFailure) {
                                      AppDialog.showErrorDialog(
                                        context: context,
                                        failure: state.failure,
                                      );
                                    }
                                  },
                                  builder: (context, createState) {
                                    if (createState
                                        is CreateWasteDamageLoading) {
                                      return const AppButtonLoading();
                                    }
                                    return BlocSelector<
                                      ValidationCubit,
                                      ValidationState,
                                      bool
                                    >(
                                      selector: (state) =>
                                          state.fieldsValidity['isSelected'] ??
                                          false,
                                      builder: (context, isValid) {
                                        return AppButton(
                                          text: context.tr.chooseStaffFirst,
                                          enabled: isValid,
                                          onClick: () {
                                            final employeeId =
                                                context
                                                    .read<ValidationCubit>()
                                                    .state
                                                    .fieldsValue['employeeId'] ??
                                                '';
                                            context
                                                .read<CreateWasteDamageCubit>()
                                                .createWasteDamageReport(
                                                  request:
                                                      CreateWastAndDamageRequest(
                                                        assignedToType:
                                                            DailyInventoryTypeEnum
                                                                .staff
                                                                .value,
                                                        assignedToId:
                                                            employeeId,
                                                        items: [],
                                                      ),
                                                );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
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
