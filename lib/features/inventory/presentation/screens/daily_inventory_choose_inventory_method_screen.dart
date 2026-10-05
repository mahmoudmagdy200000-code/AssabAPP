import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/choose_item/choose_item_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/extensions/widget_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/features/inventory/data/models/daily_inventory_items_response.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../purchase/presentation/widgets/purchase_item_image.dart';
import '../../data/models/daily_inventory_local_model.dart';
import '../../domain/strategies/inventory_user_type.dart';
import '../cubit/create_inventory/create_inventory_cubit.dart';
import '../widgets/inventory_employee_list_bottom_sheet_widget.dart';
import 'daily_assign_to_staff_inventory.dart';

class DailyInventoryChooseInventoryMethodScreen extends StatelessWidget {
  final List<DailyInventoryItem> items;

  const DailyInventoryChooseInventoryMethodScreen({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.text6,
      body: Column(
        children: [
          PurchaseAppBar(
            title: context.tr.dailyQuickInventory,
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
                    context.tr.chooseInventoryMethodForTodaysInventory(
                      items.length.toString(),
                    ),
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
                    context.tr.selectedProductsForTodaysInventory(
                      items.length.toString(),
                    ),
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ).sliverBoxAdapter,
                  10.verticalSpace.sliverBoxAdapter,
                  SliverList.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              PurchaseItemImage(image: item.itemLogo),
                              12.horizontalSpace,
                              Text(
                                item.itemName,
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                            ],
                          ),
                          if (index != items.length - 1) 6.verticalSpace,
                        ],
                      );
                    },
                  ),
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
                  context.tr.performInventoryYourselfAsBranchManager,
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
                        text: context.tr.speedAndEfficiency,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.directControl,
                      ),
                      _dotText(
                        context: context,
                        text: context.tr.completeResponsibility,
                      ),
                    ],
                  ),
                ),
                8.verticalSpace,
                CustomTextButton(
                  text: context.tr.startMyself,
                  onTap: () {
                    NavigationService.I.pushNamed(
                      AppRouteName.dailyPersonalInventory,
                      arguments: DailyInventoryLocalModel(
                        items: items,
                        userType: InventoryUserTypeBranchManager(),
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
                  context.tr.chooseAStaffToPerformInventory,
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
                        text: context.tr.reviewOptionalBeforeSending,
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
                                BlocSelector<
                                  ValidationCubit,
                                  ValidationState,
                                  bool
                                >(
                                  selector: (state) =>
                                      state.fieldsValidity['isSelected'] ??
                                      false,
                                  builder: (context, state) {
                                    return AppButton(
                                      text: context.tr.chooseStaffFirst,
                                      enabled: state,
                                      onClick: () {
                                        final validationCubit = context
                                            .read<ValidationCubit>();

                                        NavigationService.I.push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MultiBlocProvider(
                                                  providers: [
                                                    BlocProvider.value(
                                                      value: validationCubit,
                                                    ),
                                                    BlocProvider(
                                                      create: (context) =>
                                                          getIt<
                                                            CreateInventoryCubit
                                                          >(),
                                                    ),
                                                  ],
                                                  child:
                                                      DailyAssignToStaffInventory(
                                                        items: items,
                                                      ),
                                                ),
                                          ),
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
