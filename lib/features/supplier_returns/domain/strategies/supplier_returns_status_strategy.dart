import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../purchase/presentation/widgets/purchase_status_widget.dart';
import '../../../returns_management/presentation/widgets/item_return_rejection_details.dart';
import '../../../returns_management/presentation/widgets/item_return_status_widget.dart';
import '../../data/models/supplier_return_goods_details_response.dart';
import '../../presentation/cubit/supplier_approve_reject_return/supplier_approve_reject_return_cubit.dart';
import '../../presentation/cubit/supplier_approve_reject_return/supplier_approve_reject_return_state.dart';
import '../../presentation/widgets/supplier_reject_return_item_bottom_sheet_widgte.dart';

abstract class SupplierReturnsStatusStrategy {
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  );

  Widget buildStatusWidget(BuildContext context);

  Widget buildButtonsSection(BuildContext context, String id) {
    return const SizedBox.shrink();
  }
}

class PendingSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.pending,
      subtitle: context.tr.awaitingSupplierReview,
      description: context.tr.theReturnHasBeenSubmittedWaitingForTheSupplierTo,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.pendingYourApproval,
      backgroundColor: Colors.transparent,
      textColor: AppColors.orange,
      withBorder: true,
    );
  }

  @override
  Widget buildButtonsSection(BuildContext context, String id) {
    return BlocProvider(
      create: (context) => getIt<SupplierApproveRejectReturnCubit>(),
      child: Column(
        children: [
          20.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (c) {
                    return CustomTextButton(
                      text: c.tr.rejectReturn,
                      onTap: () {
                        final cubit = c
                            .read<SupplierApproveRejectReturnCubit>();

                        AppBottomSheet.customPageRoute(
                          c,
                          (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: cubit),
                              BlocProvider(
                                create: (context) =>
                                    ValidationCubit(requiredFields: {'reason'}),
                              ),
                            ],
                            child: SupplierRejectReturnItemBottomSheetWidgte(
                              id: id,
                            ),
                          ),
                        );
                      },
                      padding: EdgeInsets.symmetric(vertical: 18.r),
                      textColor: c.customColor.error,
                      borderRadius: 16.r,
                    );
                  },
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Builder(
                  builder: (context) {
                    return BlocConsumer<
                      SupplierApproveRejectReturnCubit,
                      SupplierApproveRejectReturnState
                    >(
                      listener: (context, state) {
                        if (state is SupplierApproveRejectReturnSuccess) {
                          NavigationService.I.popToFirst();
                        } else if (state
                            is SupplierApproveRejectReturnFailure) {
                          AppDialog.showErrorDialog(
                            context: context,
                            failure: state.failure,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SupplierApproveRejectReturnLoading) {
                          return const AppLoadingWidget();
                        }

                        return CustomTextButton(
                          text: context.tr.approveReturn,
                          onTap: () {
                            context
                                .read<SupplierApproveRejectReturnCubit>()
                                .approveReturn(id: id);
                          },
                          padding: EdgeInsets.symmetric(vertical: 18.r),
                          backgroundColor: context.theme.primaryColor,
                          textColor: context.customColor.reversedTextColor,
                          borderRadius: 16.r,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ApprovedSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.approved,
      subtitle: context.tr.resolvedRefundReceived,
      description: context.tr.youveBeenRefundedForThisReturn,
      textColor: AppColors.lightGreen,
      borderColor: AppColors.lightGreen,
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.approved,
      backgroundColor: Colors.transparent,
      textColor: context.theme.primaryColor,
      withBorder: true,
    );
  }
}

class RejectSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.rejectedByYou,
      subtitle: context.tr.returnRejected,
      description:
          context.tr.youveRejectedThisReturnRequestTheBuyerHasBeenNotified,
      textColor: context.customColor.error,
      borderColor: context.customColor.error,
      widget: RejectedWidget(
        reason: data.cancellation?.toCancelReasonResponse(),
      ),
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.rejectedByYou,
      backgroundColor: Colors.transparent,
      textColor: context.customColor.error,
      withBorder: true,
    );
  }
}

class PendingResolutionSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.pendingResolution,
      subtitle: context.tr.rejectionEscalated,
      description:
          context.tr.awaitingFinalDecisionFromBrandManagerOrFinanceTeam,
      textColor: AppColors.orange,
      borderColor: context.customColor.border,
      widget: Column(
        children: [
          Text(
            context.tr.escalatedOnDate(
              '${DateFormatter.formatDateMDY(data.escalatedAt)} - ${DateFormatter.formatTimeHM(data.escalatedAt)}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          ButtonTextIcon(
            onTap: () {
              AppBottomSheet.showModal(
                context,
                (context) => ItemReturnRejectionDetails(
                  cancelReason: data.cancellation?.toCancelReasonResponse(),
                ),
              );
            },
            label: context.tr.viewSuppliersRejectionDetails,
            reversed: true,
            icon: Icon(Icons.keyboard_arrow_down_outlined, size: 16.r),
            padding: EdgeInsets.symmetric(vertical: 10.r),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.pendingResolution,
      backgroundColor: Colors.transparent,
      textColor: AppColors.orange,
      withBorder: true,
    );
  }
}

class ResolvedByBrandManagerSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.resolvedByBrandManager,
      subtitle: context.tr.orderVarianceResolved,
      description: context.tr.brandManagerHasMarkedThisEscalationAsResolved,
      textColor: AppColors.lightGreen,
      borderColor: AppColors.lightGreen,
      widget: Column(
        children: [
          Text(
            context.tr.escalatedOnDate(
              '${DateFormatter.formatDateMDY(data.escalatedAt)} - ${DateFormatter.formatTimeHM(data.escalatedAt)}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          Text(
            context.tr.resolvedOnDate(
              '${DateFormatter.formatDateMDY(data.resolvedAt)} - ${DateFormatter.formatTimeHM(data.resolvedAt)}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          ButtonTextIcon(
            onTap: () {
              AppBottomSheet.showModal(
                context,
                (context) => ItemReturnRejectionDetails(
                  cancelReason: data.cancellation?.toCancelReasonResponse(),
                ),
              );
            },
            label: context.tr.viewSuppliersRejectionDetails,
            reversed: true,
            icon: Icon(Icons.keyboard_arrow_down_outlined, size: 16.r),
            padding: EdgeInsets.symmetric(vertical: 10.r),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.resolved,
      backgroundColor: Colors.transparent,
      textColor: AppColors.lightGreen,
      withBorder: true,
    );
  }
}

class RejectedByBrandManagerSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.rejectedByBrandManager,
      subtitle: context.tr.orderVarianceRejected,
      description: context.tr.brandManagerHasMarkedThisEscalationAsRejected,
      textColor: AppColors.red,
      borderColor: AppColors.red,
      widget: Column(
        children: [
          Text(
            context.tr.escalatedOnDate(
              '${DateFormatter.formatDateMDY(data.escalatedAt)} - ${DateFormatter.formatTimeHM(data.escalatedAt)}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          Text(
            context.tr.resolvedOnDate(
              '${DateFormatter.formatDateMDY(data.resolvedAt)} - ${DateFormatter.formatTimeHM(data.resolvedAt)}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),
          4.verticalSpace,
          ButtonTextIcon(
            onTap: () {
              AppBottomSheet.showModal(
                context,
                (context) => ItemReturnRejectionDetails(
                  cancelReason: data.cancellation?.toCancelReasonResponse(),
                ),
              );
            },
            label: context.tr.viewSuppliersRejectionDetails,
            reversed: true,
            icon: Icon(Icons.keyboard_arrow_down_outlined, size: 16.r),
            padding: EdgeInsets.symmetric(vertical: 10.r),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.rejected,
      backgroundColor: Colors.transparent,
      textColor: AppColors.red,
      withBorder: true,
    );
  }
}

class ClosedSupplierReturnsStatusStrategy
    extends SupplierReturnsStatusStrategy {
  @override
  Widget buildStatusDetailsWidget(
    BuildContext context,
    SupplierReturnGoodsDetailsData data,
  ) {
    return ItemReturnStatusWidget(
      status: context.tr.closed,
      description: context.tr.rejectionAndMarkedThisRequestAsClosed,
      textColor: context.customColor.text1,
      borderColor: AppColors.lightGreen,
      widget: Column(
        children: [
          Text(
            context.tr.acceptedOnDate(
              '${DateFormatter.formatDateMDY(data.closedAt)} - ${DateFormatter.formatTimeHM(data.closedAt)}',
            ),
            style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
          ),

          4.verticalSpace,
          ButtonTextIcon(
            onTap: () {
              AppBottomSheet.showModal(
                context,
                (context) => ItemReturnRejectionDetails(
                  cancelReason: data.cancellation?.toCancelReasonResponse(),
                ),
              );
            },
            label: context.tr.viewSuppliersRejectionDetails,
            reversed: true,
            icon: Icon(Icons.keyboard_arrow_down_outlined, size: 16.r),
            padding: EdgeInsets.symmetric(vertical: 10.r),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.closed,
      backgroundColor: context.customColor.text2,
      textColor: context.customColor.text1,
      withBorder: false,
    );
  }
}
