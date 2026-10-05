import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_item_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/daily_inventory_type_enum.dart';
import '../../../../core/helpers/shared_preferences_helper.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../purchase/presentation/widgets/purchase_app_bar.dart';
import '../../data/models/daily_inventory_items_response.dart';
import '../../data/models/daily_inventory_request.dart';
import '../cubit/create_inventory/create_inventory_cubit.dart';
import '../cubit/create_inventory/create_inventory_state.dart';
import 'inventory_success_screen.dart';

class DailyAssignToStaffInventory extends StatelessWidget {
  final List<DailyInventoryItem> items;

  const DailyAssignToStaffInventory({super.key, required this.items});

  DailyInventoryRequest _dailyInventoryRequest(BuildContext context) {
    return DailyInventoryRequest(
      assignedToType: DailyInventoryTypeEnum.staff,
      assignedToId:
          context.read<ValidationCubit>().state.fieldsValue['employeeId'] ?? '',
      items: items
          .map(
            (item) => DailyInventoryItemRequest(
              itemId: item.itemId,
              quantity:
                  double.tryParse(
                    context
                            .read<ValidationCubit>()
                            .state
                            .fieldsValue['quantity_${item.id}'] ??
                        '0',
                  ) ??
                  0,
              note: context
                  .read<ValidationCubit>()
                  .state
                  .fieldsValue['note_${item.id}'],
            ),
          )
          .toList(),
    );
  }

  void _createDailyInventory(BuildContext context) {
    context.read<CreateInventoryCubit>().createDailyInventory(
      id: '',
      request: _dailyInventoryRequest(context),
    );
  }

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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.teamMemberAssigned,
                            style: AppStyles.s20W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            context.tr.theyWillReceiveTaskAndSubmitQuantity,
                            style: AppStyles.s14W400.copyWith(
                              color: context.customColor.text3,
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(1000.r),
                            ),
                            padding: EdgeInsets.all(8.r),
                            child: Row(
                              children: [
                                const ProfileImageWidget(),
                                12.horizontalSpace,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BlocSelector<
                                        ValidationCubit,
                                        ValidationState,
                                        String
                                      >(
                                        selector: (state) =>
                                            state.fieldsValue['employeeName'] ??
                                            '-',
                                        builder: (context, state) {
                                          return Text(
                                            state,
                                            style: AppStyles.s14W600.copyWith(
                                              color: context.customColor.text1,
                                            ),
                                          );
                                        },
                                      ),
                                      // Row(
                                      //   children: [
                                      //     SupplierStatusWidget(
                                      //       status: context.tr.online,
                                      //       iconAssetName: AppAssets.online,
                                      //       borderColor: AppColors.lightGreen,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            context.tr.nextSteps,
                            style: AppStyles.s16W600.copyWith(
                              color: context.customColor.text1,
                            ),
                          ),
                          8.verticalSpace,
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: context.customColor.border,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.r,
                              vertical: 12.r,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.staffCompletesTheCount,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  context.tr.youReviewAndConfirm,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  context.tr.dataIsSentToTheAccountant,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  context
                                      .tr
                                      .salesInputIsSyncedFromExternalSystem,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  context
                                      .tr
                                      .discrepancyReportWillFollowWithinHours,
                                  style: AppStyles.s13W400.copyWith(
                                    color: context.customColor.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          12.verticalSpace,
                          Container(
                            decoration: BoxDecoration(
                              color: context.customColor.text2,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 16.r,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr.dailyQuickInventory,
                                  style: AppStyles.s16W600.copyWith(
                                    color: context.customColor.text1,
                                  ),
                                ),
                                12.verticalSpace,
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        context.customColor.reversedTextColor,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.r,
                                    vertical: 8.r,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 4.w,
                                            height: 70.h,
                                            color: context.theme.primaryColor,
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${context.tr.note}💡',
                                                  style: AppStyles.s14W600
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text1,
                                                      ),
                                                ),
                                                Text(
                                                  context
                                                      .tr
                                                      .productsPreSelectedByManagement,
                                                  style: AppStyles.s14W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text3,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      10.verticalSpace,
                                      const CustomDivider(),
                                      10.verticalSpace,
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: items.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 20.r,
                                            ),
                                            child: Row(
                                              children: [
                                                PurchaseItemImage(
                                                  image: items[index].itemLogo,
                                                ),
                                                5.horizontalSpace,
                                                Expanded(
                                                  child: Text(
                                                    items[index].itemName,
                                                    style: AppStyles.s14W500
                                                        .copyWith(
                                                          color: context
                                                              .customColor
                                                              .text1,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: ButtonTextIcon(
                          label: context.tr.changeMethod,
                          onTap: () {
                            NavigationService.I.pop();
                          },
                          padding: EdgeInsets.symmetric(vertical: 18.r),
                          textColor: context.customColor.text1,
                          borderRadius: BorderRadius.circular(18.r),
                          icon: const AppSvg(assetName: AppAssets.edit),
                          spaceBetweenTextAndIcon: 7.w,
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child:
                            BlocConsumer<
                              CreateInventoryCubit,
                              CreateInventoryState
                            >(
                              listener: (context, state) {
                                if (state is CreateInventorySuccess) {
                                  NavigationService.I.popUntil(
                                    (p1) =>
                                        p1.settings.name ==
                                        AppRouteName.inventoryScreen,
                                  );

                                  AppBottomSheet.customPageRoute(
                                    context,
                                    (context) => InventorySuccessScreen(
                                      title:
                                          context.tr.dailyInventoryReassigned,
                                      desc: context
                                          .tr
                                          .yourDailyInventoryCountHasBeenSuccessfullySubmitted,
                                    ),
                                  );
                                } else if (state is CreateInventoryFailure) {
                                  AppDialog.showErrorDialog(
                                    context: context,
                                    failure: state.failure,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is CreateInventoryLoading) {
                                  return const AppButtonLoading();
                                }

                                return AppButton(
                                  onClick: () {
                                    _createDailyInventory(context);
                                  },
                                  text: context.tr.assignNow,
                                  enabled: true,
                                  padding: EdgeInsets.symmetric(vertical: 18.r),
                                  borderRadius: BorderRadius.circular(18.r),
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
