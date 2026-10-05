import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/branch_manager_requests/presentation/cubit/branch_approve_or_reject_modification/branch_approve_or_reject_modification_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/branch_approve_or_reject_modification/branch_approve_or_reject_modification_state.dart';
import '../../features/branch_manager_requests/presentation/cubit/reject_approve_delay/reject_approve_delay_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/reject_approve_delay/reject_approve_delay_state.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_request_reject_updated.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_requests_status_widget.dart';
import '../../features/branch_manager_requests/presentation/widgets/delay_approve_reject_success_bottom_sheet_widget.dart';
import '../../features/branch_manager_requests/presentation/widgets/delay_reject_bottom_sheet_widget.dart';
import '../../features/branch_manager_requests/presentation/widgets/modification_approved_success_view.dart';
import '../cubits/track_order/track_order_cubit.dart';
import '../widgets/order_track_view.dart';
import '../../shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import '../constants/app_assets.dart';
import '../cubits/validation/validation_cubit.dart';
import '../cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../services/navigation/navigation_service.dart';
import '../utils/app_bottom_sheet.dart';
import '../utils/app_dialog.dart';
import '../widgets/app_button_loading.dart';
import '../widgets/app_padding_widget.dart';
import '../widgets/app_svg.dart';
import '../widgets/custom_text_button.dart';
import 'requests_order_type_strategy.dart';

abstract class RequestsOrderStatusStrategy {
  Widget buildStatus(BuildContext context);

  Widget buildButtons(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return const SizedBox.shrink();
  }

  void addTrackView(BuildContext context, String orderId) {}

  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildRejectedWidgetForOrder(
    BuildContext context,
    CancelReasonInOrderResponse? cancelReason,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildModificationDetailsStatus(
    BuildContext context,
    CancelReasonResponse? cancelReason,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildModificationDetailsDelayRequest(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return const SizedBox.shrink();
  }

  Widget buildButtonsSectionInModificationDetails(
    BuildContext context, {
    required String orderId,
    required String cancelItemId,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildDelayedButtons(BuildContext context, String orderId) {
    return const SizedBox.shrink();
  }
}

class PendingStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pending,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildButtons(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPending(context);
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPendingDetails(context);
  }

  @override
  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPendingItem(context);
  }
}

class VarianceStatusStrategyImpl extends PendingStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.varianced,
      textColor: AppColors.orange,
      borderColor: AppColors.orange,
    );
  }
}

class EmergencyStatusStrategyImpl extends PendingStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.emergency,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
    );
  }
}

class NeedsApprovalSupplierStatusStrategyImpl
    extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.waitingForBuyersApproval,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPendingApproval(context);
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            context.tr.pending,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(assetName: AppAssets.wait, width: 12.r, height: 12.r),
        ],
      ),
    );
  }

  @override
  Widget buildModificationDetailsStatus(
    BuildContext context,
    CancelReasonResponse? cancelReason,
  ) {
    return Row(
      children: [
        30.horizontalSpace,
        Expanded(
          child: Text(
            context.tr.youModifiedThisItemPendingApprovalFromRequester,
            textAlign: TextAlign.center,
            style: AppStyles.s13W500.copyWith(color: AppColors.orange),
          ),
        ),
        30.horizontalSpace,
      ],
    );
  }
}

class NeedsApprovalBranchStatusStrategyImpl
    extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.pendingYourApproval,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPendingApproval(context);
  }

  @override
  Widget buildModificationDetailsStatus(
    BuildContext context,
    CancelReasonResponse? cancelReason,
  ) {
    return Row(
      children: [
        30.horizontalSpace,
        Expanded(
          child: Text(
            context.tr.supplierModifiedThisItemPendingYourApproval,
            textAlign: TextAlign.center,
            style: AppStyles.s13W500.copyWith(color: AppColors.orange),
          ),
        ),
        30.horizontalSpace,
      ],
    );
  }

  @override
  Widget buildButtonsSectionInModificationDetails(
    BuildContext context, {
    required String orderId,
    required String cancelItemId,
  }) {
    return AppPaddingWidget(
      top: 0,
      child:
          BlocConsumer<
            BranchApproveOrRejectModificationCubit,
            BranchApproveOrRejectModificationState
          >(
            listener: (context, state) {
              if (state is BranchApproveOrRejectModificationSuccess) {
                NavigationService.I.popToFirst();

                AppBottomSheet.customPageRoute(
                  context,
                  (context) => const ModificationApprovedSuccessView(),
                );
              } else if (state is BranchApproveOrRejectModificationFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            builder: (context, state) {
              if (state is BranchApproveOrRejectModificationLoading) {
                return const AppButtonLoading();
              }

              return Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.reject,
                      onTap: () {
                        final branchApproveOrRejectModificationCubit = context
                            .read<BranchApproveOrRejectModificationCubit>();

                        AppBottomSheet.customPageRoute(
                          context,
                          (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) =>
                                    ValidationCubit(requiredFields: {'reason'}),
                              ),
                              BlocProvider.value(
                                value: branchApproveOrRejectModificationCubit,
                              ),
                            ],
                            child: BranchRequestRejectUpdated(
                              title: context.tr.rejectQtyUpdate,
                              orderId: orderId,
                              itemId: cancelItemId,
                            ),
                          ),
                        );
                      },
                      borderRadius: 1000.r,
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      textColor: context.customColor.error,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.approve,
                      onTap: () {
                        context
                            .read<BranchApproveOrRejectModificationCubit>()
                            .approveModification(
                              orderId: orderId,
                              itemId: cancelItemId,
                            );
                      },
                      borderRadius: 1000.r,
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      textColor: context.customColor.reversedTextColor,
                      backgroundColor: context.theme.primaryColor,
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            context.tr.pending,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(assetName: AppAssets.wait, width: 12.r, height: 12.r),
        ],
      ),
    );
  }
}

class RejectedStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.rejected,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
    );
  }

  @override
  Widget buildRejectedWidgetForOrder(
    BuildContext context,
    CancelReasonInOrderResponse? cancelReason,
  ) {
    return Column(
      children: [
        RejectedWidget(
          withBorder: false,
          reason: cancelReason?.toCancelReasonResponse(),
        ),
        12.verticalSpace,
      ],
    );
  }
}

class PartialApprovedStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.partialApproved,
      textColor: const Color(0xff049899),
      borderColor: Colors.transparent,
      backgroundColor: const Color(0xffDFFEFF),
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onOrderBranchToBranchApproveDetails(context);
  }

  @override
  Widget buildButtons(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPartialOrFullyApproved(context);
  }
}

class FullyApprovedStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.fullyApproved,
      textColor: AppColors.darkGreen,
      borderColor: AppColors.darkGreen,
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onOrderBranchToBranchApproveDetails(context);
  }

  @override
  Widget buildButtons(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPartialOrFullyApproved(context);
  }
}

class PartialConfirmedStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.partialConfirmed,
      textColor: const Color(0xff049899),
      borderColor: Colors.transparent,
      backgroundColor: const Color(0xffDFFEFF),
    );
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            '${context.tr.newQuantity} $quantityConfirmed',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmedStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.confirmed,
      textColor: context.theme.primaryColor,
      borderColor: Colors.transparent,
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onConfirmedDetails(context);
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            context.tr.fullyApproved,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmedNeedTimeStatusStrategyImpl extends ConfirmedStatusStrategyImpl {
  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            '${context.tr.pending} + ${context.tr.restock}',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmedAlternativeProductStatusStrategyImpl
    extends ConfirmedStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.itemReplaced,
      textColor: context.customColor.text1,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.text2,
      icon: AppSvg(
        assetName: AppAssets.refresh,
        width: 12.r,
        colorFilter: ColorFilter.mode(
          context.customColor.text1,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            context.tr.replacement,
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class CanceledStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.canceled,
      backgroundColor: Colors.transparent,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
    );
  }
}

class CanceledModificationStatusStrategyImpl
    extends CanceledStatusStrategyImpl {
  @override
  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onCancelledItemModification(context);
  }

  @override
  Widget buildModificationDetailsStatus(
    BuildContext context,
    CancelReasonResponse? cancelReason,
  ) {
    return Column(
      children: [
        Row(
          children: [
            30.horizontalSpace,
            Expanded(
              child: Text(
                context
                    .tr
                    .modificationsRejectedItemHasBeenCanceledWillNotBeProcessed,
                textAlign: TextAlign.center,
                style: AppStyles.s13W500.copyWith(
                  color: context.customColor.error,
                ),
              ),
            ),
            30.horizontalSpace,
          ],
        ),
        10.verticalSpace,
        RejectedWidget(reason: cancelReason),
      ],
    );
  }
}

class CanceledByBranchStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.canceledByBranch,
      backgroundColor: Colors.transparent,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
    );
  }

  @override
  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onCancelledItemByBranch(context);
  }

  @override
  Widget buildRejectedWidgetForOrder(
    BuildContext context,
    CancelReasonInOrderResponse? cancelReason,
  ) {
    return Column(
      children: [
        RejectedWidget(
          withBorder: false,
          reason: cancelReason?.toCancelReasonResponse(),
        ),
        12.verticalSpace,
      ],
    );
  }
}

class CanceledBySupplierStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.canceledBySupplier,
      backgroundColor: Colors.transparent,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
    );
  }

  @override
  Widget buildButtonsItem(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onCancelledItemBySupplier(context);
  }

  @override
  Widget buildRejectedWidgetForOrder(
    BuildContext context,
    CancelReasonInOrderResponse? cancelReason,
  ) {
    return Column(
      children: [
        RejectedWidget(
          withBorder: false,
          reason: cancelReason?.toCancelReasonResponse(),
        ),
        12.verticalSpace,
      ],
    );
  }
}

class PreparingStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.preparing,
      textColor: context.customColor.text1,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.text2,
      icon: AppSvg(assetName: AppAssets.preparing, width: 12.r),
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onPreparingDetails(context);
  }

  @override
  void addTrackView(BuildContext context, String orderId) {
    final dynamicStepsCubit = context.read<DynamicStepsCubit>();
    if (dynamicStepsCubit.state.titles.isNotEmpty &&
        dynamicStepsCubit.state.titles[0] == context.tr.track) {
      return;
    }

    dynamicStepsCubit.insertStep(
      0,
      () => BlocProvider(
        create: (context) => getIt<TrackOrderCubit>(),
        child: OrderTrackView(orderId: orderId),
      ),
      context.tr.track,
    );
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            quantityConfirmed == requestedQty
                ? context.tr.fullyQuantity
                : '${context.tr.partial} ${context.tr.quantity} $quantityConfirmed',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class OutForDeliveryStatusStrategyImpl extends PreparingStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.outForDelivery,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
      backgroundColor: Colors.transparent,
      icon: AppSvg(
        assetName: AppAssets.transportDelivery,
        width: 12.r,
        colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
      ),
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onOutForDeliveryDetails(context);
  }
}

class DeliveredStatusStrategyImpl extends PreparingStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.delivered,
      textColor: AppColors.lightGreen,
      borderColor: context.customColor.border,
      backgroundColor: Colors.transparent,
      icon: AppSvg(
        assetName: AppAssets.transportDelivery,
        width: 12.r,
        colorFilter: const ColorFilter.mode(
          AppColors.lightGreen,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildButtons(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onDelivered(context);
  }
}

class DelayedStatusStrategyImpl extends PreparingStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.delayReported,
      textColor: context.customColor.text1,
      borderColor: context.customColor.border,
      backgroundColor: Colors.transparent,
      icon: Icon(
        Icons.access_time_rounded,
        size: 12.r,
        color: AppColors.orange,
      ),
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildModificationDetailsDelayRequest(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.buildModificationDetailsDelayPendingRequest(context);
  }

  @override
  Widget buildDelayedButtons(BuildContext context, String orderId) {
    return BlocProvider(
      create: (context) => getIt<RejectApproveDelayCubit>(),
      child: BlocConsumer<RejectApproveDelayCubit, RejectApproveDelayState>(
        listener: (context, state) {
          if (state is RejectApproveDelaySuccess) {
            NavigationService.I.popToFirst();

            AppBottomSheet.customPageRoute(
              context,
              (context) => DelayApproveRejectSuccessBottomSheetWidget(
                title: context.tr.delayRequestApproved,
                description: context
                    .tr
                    .theSupplierHasBeenNotifiedAllItemsWillNowFollowTheUpdatedDeliveryScheduleAsProposed,
              ),
            );
          } else if (state is RejectApproveRejectedDelaySuccess) {
            NavigationService.I.popToFirst();

            AppBottomSheet.customPageRoute(
              context,
              (context) => DelayApproveRejectSuccessBottomSheetWidget(
                title: context.tr.delayRequestRejected,
                description: context
                    .tr
                    .theSupplierHasBeenNotifiedThisOrderHasBeenCancelledDueToTheMissedDeliveryTimeline,
              ),
            );
          } else if (state is RejectApproveDelayFailure) {
            AppDialog.showErrorDialog(context: context, failure: state.failure);
          }
        },
        builder: (context, state) {
          if (state is RejectApproveDelayLoading) {
            return const AppButtonLoading();
          }

          return Row(
            children: [
              Expanded(
                child: CustomTextButton(
                  text: context.tr.reject,
                  borderRadius: 1000.r,
                  backgroundColor: Colors.transparent,
                  textColor: context.customColor.error,
                  padding: EdgeInsets.symmetric(vertical: 18.r),
                  onTap: () {
                    final cubit = context.read<RejectApproveDelayCubit>();

                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: cubit),
                          BlocProvider(
                            create: (context) =>
                                ValidationCubit(requiredFields: {'reason'}),
                          ),
                        ],
                        child: DelayRejectBottomSheetWidget(orderId: orderId),
                      ),
                    );
                  },
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomTextButton(
                  text: context.tr.approval,
                  borderRadius: 1000.r,
                  backgroundColor: context.theme.primaryColor,
                  textColor: context.customColor.reversedTextColor,
                  padding: EdgeInsets.symmetric(vertical: 18.r),
                  onTap: () {
                    context.read<RejectApproveDelayCubit>().approveDelay(
                      id: orderId,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DelayedApprovedStatusStrategyImpl extends DelayedStatusStrategyImpl {
  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.delayedDeliveryDetails(context);
  }

  @override
  Widget buildModificationDetailsDelayRequest(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.buildModificationDetailsDelayApprovedRequest(context);
  }

  @override
  Widget buildDelayedButtons(BuildContext context, String orderId) {
    return AppButton(
      onClick: () {},
      text: context.tr.delayApproved,
      borderRadius: BorderRadius.circular(20.r),
    );
  }
}

class DelayedRejectedStatusStrategyImpl extends DelayedStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.canceled,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget buildModificationDetailsDelayRequest(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.buildModificationDetailsDelayRejectedRequest(context);
  }

  @override
  Widget buildDelayedButtons(BuildContext context, String orderId) {
    return AppButton(
      onClick: () {},
      text: context.tr.delayRejected,
      borderRadius: BorderRadius.circular(20.r),
    );
  }
}

class CloseStatusStrategyImpl extends PreparingStatusStrategyImpl {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.closed,
      textColor: context.customColor.text1,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.text2,
    );
  }

  @override
  Widget buildButtonsDetails(
    BuildContext context,
    RequestsOrderTypeStrategy orderType,
  ) {
    return orderType.onClosedDetails(context);
  }

  @override
  Widget buildStatusItem(
    BuildContext context, {
    required int quantityConfirmed,
    required int requestedQty,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.reversedTextColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 8.r),
      margin: EdgeInsets.only(top: 8.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.tr.confirmed,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ),
          5.horizontalSpace,
          Text(
            quantityConfirmed == requestedQty
                ? context.tr.fullyQuantity
                : '${context.tr.partial} ${context.tr.quantity} $quantityConfirmed',
            style: AppStyles.s12W500.copyWith(color: context.customColor.text1),
          ),
          10.horizontalSpace,
          AppSvg(
            assetName: AppAssets.check,
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              AppColors.lightGreen,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class DraftStatusStrategyImpl extends RequestsOrderStatusStrategy {
  @override
  Widget buildStatus(BuildContext context) {
    return BranchRequestsStatusWidget(
      status: context.tr.draft,
      textColor: context.customColor.text1,
      borderColor: Colors.transparent,
      backgroundColor: context.customColor.text2,
      icon: AppSvg(
        assetName: AppAssets.edit,
        width: 12.w,
        height: 12.w,
        colorFilter: ColorFilter.mode(
          context.customColor.text1,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
