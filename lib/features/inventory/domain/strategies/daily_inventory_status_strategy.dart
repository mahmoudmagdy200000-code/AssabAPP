import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';
import '../../data/models/daily_inventory_list_response.dart';
import '../../data/models/inventory_confirm_staff_task_request.dart';
import '../../data/models/wasted_damage_list_response.dart';
import '../../presentation/cubit/inventory_approve_reject_staff_submition/inventory_approve_reject_staff_submition_cubit.dart';
import '../../presentation/widgets/inventory_confirm_staff_task_bottom_sheet.dart';
import '../enums/inventory_status_enum.dart';

abstract class DailyInventoryStatusStrategy {
  static DailyInventoryStatusStrategy getStrategy(InventoryStatusEnum status) {
    switch (status) {
      case InventoryStatusEnum.pending:
        return PendingDailyInventoryStatusStrategy();
      case InventoryStatusEnum.completed:
      case InventoryStatusEnum.approved:
        return CompletedDailyInventoryStatusStrategy();
      case InventoryStatusEnum.rejected:
        return RejectedDailyInventoryStatusStrategy();
    }
  }

  Widget buildStatus(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildStatusDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildStatusDetailsStaff(
    BuildContext context, {
    required DailyInventoryListResponseSession details,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildDetailsActionToStaffButtons(
    BuildContext context,
    DailyInventoryListResponseSession details,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildStatusWasteDamageDetails(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildStatusWasteDamageDetailsStaff(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildWasteDamageDetailsActionToStaffButtons(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return const SizedBox.shrink();
  }
}

class PendingDailyInventoryStatusStrategy extends DailyInventoryStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pending,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildStatusDetails(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pending,
      textColor: AppColors.orange,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatusDetailsStaff(
    BuildContext context, {
    required DailyInventoryListResponseSession details,
  }) {
    return BranchRequestsStatusWidget(
      status: details.isStaffInventored
          ? 'Staff Assigned'
          : 'Pending Staff Assignment',
      textColor: AppColors.orange,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatusWasteDamageDetails(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BranchRequestsStatusWidget(
                status: context.tr.pendingReview,
                textColor: AppColors.darkOrange,
                borderColor: Colors.transparent,
                backgroundColor: context.customColor.reversedTextColor,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            context.tr.reportSubmitted,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.reportSubmittedDesc(details.creator.name),
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWasteDamageDetailsStaff(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BranchRequestsStatusWidget(
                status: details.isStaffInventored
                    ? 'Staff Assigned'
                    : 'Pending Staff Assignment',
                textColor: AppColors.darkOrange,
                borderColor: Colors.transparent,
                backgroundColor: context.customColor.reversedTextColor,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            context.tr.reportSubmitted,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            details.isStaffInventored
                ? 'A staff member has been assigned to inventory this item, please wait for them to complete the inventory process.'
                : context.tr.pendingStaffAssignmentDesc,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDetailsActionToStaffButtons(
    BuildContext context,
    DailyInventoryListResponseSession details,
  ) {
    return BlocListener<
      InventoryApproveRejectStaffSubmitionCubit,
      InventoryApproveRejectStaffSubmitionState
    >(
      listener: (context, state) {
        if (state is InventoryApproveRejectStaffSubmitionSuccess) {
          NavigationService.I.pop();

          AppSnackBar.showSuccess(context, 'Request submitted successfully');
        } else if (state is InventoryApproveRejectStaffSubmitionFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<
            InventoryApproveRejectStaffSubmitionCubit,
            InventoryApproveRejectStaffSubmitionState
          >(
            builder: (context, state) {
              if (state is InventoryApproveRejectStaffSubmitionLoading) {
                return const AppButtonLoading();
              }

              return CustomTextButton(
                text: context.tr.submitRequest,
                onTap: () {
                  final inventoryApproveRejectStaffSubmitionCubit = context
                      .read<InventoryApproveRejectStaffSubmitionCubit>();
                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => InventoryConfirmStaffTaskBottomSheet(
                      title: 'Daily Inventory',
                      description:
                          'Are you sure you want to submit a request to assign a staff member to inventory this session?',
                      items: details.items
                          .map(
                            (e) =>
                                InventoryConfirmStaffTaskBottomSheetArguments(
                                  itemId: e.id,
                                  itemName: e.item.name,
                                  itemQuantity: e.quantityInventory,
                                  image: '',
                                ),
                          )
                          .toList(),
                      onConfirm: (updatedItems) {
                        inventoryApproveRejectStaffSubmitionCubit
                            .confirmDailyForStaff(
                              sessionId: details.id,
                              request: InventoryConfirmStaffTaskRequest(
                                items: updatedItems
                                    .map(
                                      (e) => InventoryConfirmStaffTaskItem(
                                        itemId: e.itemId,
                                        quantity: e.itemQuantity,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                      },
                    ),
                  );
                },
                backgroundColor: context.theme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.r),
                borderColor: Colors.transparent,
                borderRadius: 12.r,
                textColor: context.customColor.reversedTextColor,
              );
            },
          ),
    );
  }

  @override
  Widget buildWasteDamageDetailsActionToStaffButtons(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return BlocListener<
      InventoryApproveRejectStaffSubmitionCubit,
      InventoryApproveRejectStaffSubmitionState
    >(
      listener: (context, state) {
        if (state is InventoryApproveRejectStaffSubmitionSuccess) {
          NavigationService.I.pop();

          AppSnackBar.showSuccess(context, 'Request submitted successfully');
        } else if (state is InventoryApproveRejectStaffSubmitionFailure) {
          AppDialog.showErrorDialog(context: context, failure: state.failure);
        }
      },
      child:
          BlocBuilder<
            InventoryApproveRejectStaffSubmitionCubit,
            InventoryApproveRejectStaffSubmitionState
          >(
            builder: (context, state) {
              if (state is InventoryApproveRejectStaffSubmitionLoading) {
                return const AppButtonLoading();
              }

              return CustomTextButton(
                text: context.tr.submitRequest,
                onTap: () {
                  final inventoryApproveRejectStaffSubmitionCubit = context
                      .read<InventoryApproveRejectStaffSubmitionCubit>();
                  AppBottomSheet.customPageRoute(
                    context,
                    (context) => InventoryConfirmStaffTaskBottomSheet(
                      title: 'Wasted/Damaged Inventory',
                      description:
                          'Are you sure you want to submit a request to assign a staff member to inventory this wasted/damaged report?',
                      items: details.items
                          .map(
                            (e) =>
                                InventoryConfirmStaffTaskBottomSheetArguments(
                                  itemId: e.id,
                                  itemName: e.item.name,
                                  itemQuantity: e.quantityWasted.toInt(),
                                  image: '',
                                ),
                          )
                          .toList(),
                      onConfirm: (updatedItems) {
                        inventoryApproveRejectStaffSubmitionCubit
                            .confirmWasteDamageForStaff(
                              reportId: details.id,
                              request: InventoryConfirmStaffTaskRequest(
                                items: updatedItems
                                    .map(
                                      (e) => InventoryConfirmStaffTaskItem(
                                        itemId: e.itemId,
                                        quantity: e.itemQuantity,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                      },
                    ),
                  );
                },
                backgroundColor: context.theme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.r),
                borderColor: Colors.transparent,
                borderRadius: 12.r,
                textColor: context.customColor.reversedTextColor,
              );
            },
          ),
    );
  }
}

class CompletedDailyInventoryStatusStrategy
    extends DailyInventoryStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildStatusDetails(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatusDetailsStaff(
    BuildContext context, {
    required DailyInventoryListResponseSession details,
  }) {
    return BranchRequestsStatusWidget(
      status: context.tr.completed,
      textColor: AppColors.lightGreen,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatusWasteDamageDetails(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BranchRequestsStatusWidget(
                status: context.tr.completed,
                textColor: AppColors.lightGreen,
                borderColor: Colors.transparent,
                backgroundColor: context.customColor.reversedTextColor,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            context.tr.reportApproved,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.reportApprovedDesc,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWasteDamageDetailsStaff(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BranchRequestsStatusWidget(
                status: context.tr.completed,
                textColor: AppColors.lightGreen,
                borderColor: Colors.transparent,
                backgroundColor: context.customColor.reversedTextColor,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            context.tr.reportApproved,
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.reportApprovedDesc,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class RejectedDailyInventoryStatusStrategy
    extends DailyInventoryStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.rejected,
      textColor: AppColors.red,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildStatusDetails(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.rejected,
      textColor: AppColors.red,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatusDetailsStaff(
    BuildContext context, {
    required DailyInventoryListResponseSession details,
  }) {
    return BranchRequestsStatusWidget(
      status: context.tr.rejected,
      textColor: AppColors.red,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget buildStatusWasteDamageDetails(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BranchRequestsStatusWidget(
                status: context.tr.rejected,
                textColor: AppColors.red,
                borderColor: Colors.transparent,
                backgroundColor: context.customColor.reversedTextColor,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            'Report Rejected',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            'Your report has been rejected, please edit and resubmit it.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWasteDamageDetailsStaff(
    BuildContext context,
    WastedDamageListDetails details,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: context.customColor.text2,
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BranchRequestsStatusWidget(
                status: context.tr.rejected,
                textColor: AppColors.red,
                borderColor: Colors.transparent,
                backgroundColor: context.customColor.reversedTextColor,
              ),
            ],
          ),
          5.verticalSpace,
          Text(
            'Report Rejected',
            style: AppStyles.s14W600.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            'Your report has been rejected, please edit and resubmit it.',
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
