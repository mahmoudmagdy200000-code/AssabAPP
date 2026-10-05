import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/rejected_widget.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/branch_cancel_item/branch_cancel_item_state.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart';
import 'package:assab/features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_state.dart';
import 'package:assab/features/supplier_requests/presentation/widgets/supplier_requests_cancelations_details_bottom_sheet.dart';
import 'package:assab/shared/models/cancel_reason/cancel_reason_in_order_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/branch_manager_requests/data/models/direct_supplier_order_details_response.dart';
import '../../features/branch_manager_requests/data/models/orders_response.dart';
import '../../features/branch_manager_requests/data/models/reject_all_order_request.dart';
import '../../features/branch_manager_requests/presentation/cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/branch_approve_or_reject_modification/branch_approve_or_reject_modification_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/branch_cancel_item/branch_cancel_item_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/branch_get_cancel_reason/branch_get_cancel_reason_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/branch_get_modification/branch_get_modification_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/get_order_details/get_order_details_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/get_orders/get_orders_cubit.dart';
import '../../features/branch_manager_requests/presentation/cubit/select_branch_manager_approve_request/select_branch_manager_approve_request_cubit.dart';
import '../../features/branch_manager_requests/presentation/screens/request_details_screen.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_manager_requests_approve_request_bottom_sheet_widget.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_requests_cancelations_details_bottom_sheet.dart';
import '../../features/branch_manager_requests/presentation/widgets/branch_requests_modification_details_bottom_sheet.dart';
import '../../features/receive_goods/presentation/cubit/get_receive_order_inspection/get_receive_order_inspection_cubit.dart';
import '../../features/receive_goods/presentation/cubit/start_receive_order/start_receive_order_cubit.dart';
import '../../features/receive_goods/presentation/cubit/start_receive_order/start_receive_order_state.dart';
import '../../features/receive_goods/presentation/screens/receive_order_screen.dart';
import '../../features/receive_goods/presentation/screens/receive_order_success_screen.dart';
import '../../features/receive_goods/presentation/widgets/row_receive_and_review_order_buttons.dart';
import '../../features/returns_management/presentation/cubit/create_return/create_return_cubit.dart';
import '../../features/returns_management/presentation/screens/create_return_screen.dart';
import '../../features/supplier_requests/data/models/supplier_order_details_response.dart';
import '../../features/supplier_requests/data/models/supplier_orders_response.dart';
import '../../features/supplier_requests/presentation/cubit/supplier_get_cancellation_reason/supplier_get_cancellation_reason_cubit.dart';
import '../../features/supplier_requests/presentation/cubit/supplier_get_modification/supplier_get_modification_cubit.dart';
import '../../features/supplier_requests/presentation/cubit/supplier_start_track_order/supplier_start_track_order_cubit.dart';
import '../../features/supplier_requests/presentation/screens/supplier_mark_all_as_delivered_screen.dart';
import '../../features/supplier_requests/presentation/screens/supplier_mark_all_as_preparing_screen.dart';
import '../../features/supplier_requests/presentation/screens/supplier_mark_all_for_delivery_screen.dart';
import '../../features/supplier_requests/presentation/screens/supplier_report_delay.dart';
import '../../features/supplier_requests/presentation/widgets/delay_request_status_widget.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_approve_all_bottom_sheet_widget.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_main_actions_bottom_sheet_widget.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_reject_item_bottom_sheet_widget.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_reject_request_bottom_sheet_widget.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_rejected_success_bottom_sheet_widget.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_requests_modification_details_bottom_sheet.dart';
import '../../features/supplier_requests/presentation/widgets/supplier_view_cancellation_details_bottom_sheet.dart';
import '../cubits/choose_item/choose_item_cubit.dart';
import '../cubits/dynamic_steps/dynamic_steps_cubit.dart';
import '../cubits/paging_cubit/paging_cubit.dart';
import '../di/dependency_injection.dart';
import '../utils/app_bottom_sheet.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_text_button.dart';
import 'requests_order_status_strategy.dart';

abstract class RequestsOrderTypeStrategy {
  final RequestsOrderStatusStrategy statusStrategy;

  RequestsOrderTypeStrategy(this.statusStrategy);

  Widget buildStatus(BuildContext context) {
    return statusStrategy.buildStatus(context);
  }

  Widget buildButtons(BuildContext context) {
    return statusStrategy.buildButtons(context, this);
  }

  Widget buildButtonsDetails(BuildContext context) {
    return statusStrategy.buildButtonsDetails(context, this);
  }

  Widget buildButtonsItem(BuildContext context) {
    return statusStrategy.buildButtonsItem(context, this);
  }

  Widget onPending(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onPendingDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onPendingItem(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onPendingApproval(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onPartialOrFullyApproved(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onCancelledItem(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onCancelledItemByBranch(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onCancelledItemBySupplier(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onCancelledItemModification(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onCancelledByBranchDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onCancelledBySupplierDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onConfirmedDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onPreparingDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onOutForDeliveryDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onDelivered(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget delayedDeliveryDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onOrderBranchToBranchApproveDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget onClosedDetails(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildModificationDetailsDelayPendingRequest(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildModificationDetailsDelayApprovedRequest(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildModificationDetailsDelayRejectedRequest(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget buildDelayedButtons(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class BranchOrderTypeStrategy extends RequestsOrderTypeStrategy {
  final String orderId;

  BranchOrderTypeStrategy(super.statusStrategy, {required this.orderId});

  @override
  Widget onOrderBranchToBranchApproveDetails(BuildContext context) {
    return ButtonTextIcon(
      label: context.tr.receiveThisOrder,
      icon: AppSvg(
        assetName: AppAssets.box,
        colorFilter: ColorFilter.mode(
          context.customColor.reversedTextColor,
          BlendMode.srcIn,
        ),
      ),
      spaceBetweenTextAndIcon: 7.w,
      borderRadius: BorderRadius.circular(20.r),
      backgroundColor: context.theme.primaryColor,
      textColor: context.customColor.reversedTextColor,
      padding: EdgeInsets.symmetric(vertical: 18.r),
      onTap: () {
        NavigationService.I.popToFirst();

        NavigationService.I.pushNamed(AppRouteName.receiveGoodsScreen);
      },
    );
  }

  @override
  Widget onDelivered(BuildContext context) {
    return RowReceiveAndReviewOrderButtons(
      onReceiveTap: () async {
        await NavigationService.I.push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
                BlocProvider(create: (context) => DynamicStepsCubit()),
                BlocProvider(
                  create: (context) => ValidationCubit(
                    requiredFields: {'receiveGoodsItems', 'isVariance'},
                  ),
                ),
                BlocProvider(
                  create: (context) => getIt<GetReceiveOrderInspectionCubit>(),
                ),
                BlocProvider(
                  create: (context) => getIt<StartReceiveOrderCubit>(),
                ),
              ],
              child: ReceiveOrderScreen(orderId: orderId),
            ),
          ),
        );

        context.read<GetOrdersCubit>().getOrders();
      },
    );
  }

  @override
  Widget onPartialOrFullyApproved(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StartReceiveOrderCubit>(),
      child: Builder(
        builder: (c) {
          return BlocConsumer<StartReceiveOrderCubit, StartReceiveOrderState>(
            listener: (c, state) {
              if (state is StartReceiveOrderSuccess) {
                AppBottomSheet.customPageRoute(
                  context,
                  (context) => const ReceiveOrderSuccessScreen(),
                );
              } else if (state is StartReceiveOrderFailure) {
                AppDialog.showErrorDialog(
                  context: context,
                  failure: state.failure,
                );
              }
            },
            builder: (c, state) {
              if (state is StartReceiveOrderLoading) {
                return const AppButtonLoading();
              }

              return RowReceiveAndReviewOrderButtons(
                onReceiveTap: () {
                  c.read<StartReceiveOrderCubit>().startReceivingBranchOrder(
                    orderId: orderId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BranchRequestTypeStrategy extends RequestsOrderTypeStrategy {
  final OrderData request;

  BranchRequestTypeStrategy(super.statusStrategy, {required this.request});

  @override
  Widget onPending(BuildContext context) {
    return Column(
      children: [
        4.verticalSpace,
        const CustomDivider(),
        10.verticalSpace,
        Row(
          children: [
            Expanded(
              child: CustomTextButton(
                text: context.tr.approve,
                borderRadius: 1000.r,
                backgroundColor: context.theme.primaryColor,
                textColor: context.customColor.reversedTextColor,
                onTap: () async {
                  await AppBottomSheet.customPageRoute(
                    context,
                    (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              getIt<SelectBranchManagerApproveRequestCubit>(),
                        ),
                        BlocProvider(
                          create: (context) =>
                              getIt<ApproveOrRejectOrderCubit>(),
                        ),
                      ],
                      child:
                          BranchManagerRequestsApproveRequestBottomSheetWidget(
                            request: request,
                          ),
                    ),
                  );

                  if (context.mounted) {
                    context.read<GetOrdersCubit>().getOrders();
                  }
                },
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: CustomTextButton(
                text: context.tr.seeDetails,
                borderRadius: 1000.r,
                textColor: context.customColor.text1,
                onTap: () async {
                  await NavigationService.I.push(
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => PagingCubit(totalSteps: 3),
                          ),
                          BlocProvider(
                            create: (context) => DynamicStepsCubit(),
                          ),
                          BlocProvider(
                            create: (context) => getIt<GetOrderDetailsCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => ValidationCubit(
                              requiredFields: {'approval', 'timelines'},
                            ),
                          ),
                        ],
                        child: RequestDetailsScreen(
                          id: request.id,
                          strategy: request.orderType,
                          isBranchOrderTypeStrategy: false,
                        ),
                      ),
                    ),
                  );

                  if (context.mounted) {
                    context.read<GetOrdersCubit>().getOrders();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DirectSupplierRequestTypeStrategy extends RequestsOrderTypeStrategy {
  final DirectSupplierOrderDetailsResponse details;

  DirectSupplierRequestTypeStrategy(
    super.statusStrategy, {
    required this.details,
  });

  @override
  Widget onPendingDetails(BuildContext context) {
    return CustomTextButton(
      text: context.tr.cancelOrder,
      borderRadius: 1000.r,
      textColor: context.customColor.error,
      backgroundColor: context.customColor.reversedTextColor,
      onTap: () {
        AppBottomSheet.customPageRoute(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    ValidationCubit(requiredFields: {'reason'}),
              ),
              BlocProvider(create: (context) => getIt<BranchCancelItemCubit>()),
            ],
            child: Scaffold(
              body: BlocConsumer<BranchCancelItemCubit, BranchCancelItemState>(
                listener: (context, state) {
                  if (state is BranchCancelItemSuccess) {
                    NavigationService.I.popToFirst();

                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => SupplierRejectedSuccessBottomSheetWidget(
                        title: context.tr.orderCancelled,
                      ),
                    );
                  } else if (state is BranchCancelItemFailure) {
                    AppDialog.showErrorDialog(
                      context: context,
                      failure: state.failure,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BranchCancelItemLoading) {
                    return const AppLoadingWidget();
                  }

                  return SupplierRejectRequestBottomSheetWidget(
                    onClick: (reason) {
                      context.read<BranchCancelItemCubit>().cancelOrder(
                        orderId: details.requestSummary.id,
                        body: RejectAllOrderRequest(reason: reason),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget onClosedDetails(BuildContext context) {
    return ButtonTextIcon(
      onTap: () {
        NavigationService.I.popToFirst();

        NavigationService.I.push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
                BlocProvider(create: (context) => getIt<CreateReturnCubit>()),
                BlocProvider(
                  create: (context) => ValidationCubit(
                    requiredFields: {'requiredAction'},
                    optionalFields: {'note'},
                  ),
                ),
              ],
              child: CreateReturnScreen(details: details),
            ),
          ),
        );
      },
      label: context.tr.returnItems,
      reversed: true,
      icon: AppSvg(assetName: AppAssets.returnsManagement, width: 12.r),
      textColor: context.customColor.error,
      spaceBetweenTextAndIcon: 7.r,
    );
  }

  @override
  Widget buildModificationDetailsDelayPendingRequest(BuildContext context) {
    return DelayRequestStatusWidget(
      text: context.tr
          .supplierHasRequestedADeliveryDateTimeExtensionPendingYourApproval(
            details.requestSummary.delayDetails?.delayReportedAt ?? '',
          ),
      strategy: this,
      delayDetails: details.requestSummary.delayDetails!,
    );
  }

  @override
  Widget buildModificationDetailsDelayApprovedRequest(BuildContext context) {
    return DelayRequestStatusWidget(
      text: context.tr.newDateTimeExtensionApproved(
        details.requestSummary.delayDetails?.delayApprovedAt ?? '',
      ),
      strategy: this,
      textColor: AppColors.lightGreen,
      delayDetails: details.requestSummary.delayDetails!,
    );
  }

  @override
  Widget buildModificationDetailsDelayRejectedRequest(BuildContext context) {
    return DelayRequestStatusWidget(
      text: context.tr.newDateTimeExtensionRejected(
        details.requestSummary.delayDetails?.delayRejectedAt ?? '',
      ),
      strategy: this,
      textColor: context.customColor.error,
      delayDetails: details.requestSummary.delayDetails!,
      customWidget: RejectedWidget(
        reason: details.requestSummary.reasonForRejected
            ?.toCancelReasonResponse(),
      ),
    );
  }

  @override
  Widget buildDelayedButtons(BuildContext context) {
    return statusStrategy.buildDelayedButtons(
      context,
      details.requestSummary.id,
    );
  }
}

class DirectSupplierItemRequestTypeStrategy extends RequestsOrderTypeStrategy {
  final DirectSupplierOrderDetailsProductDetail item;
  final String orderId;

  DirectSupplierItemRequestTypeStrategy(
    super.statusStrategy, {
    required this.item,
    required this.orderId,
  });

  @override
  Widget onPendingItem(BuildContext context) {
    return CustomTextButton(
      text: context.tr.cancelThisItem,
      borderRadius: 1000.r,
      textColor: context.customColor.error,
      backgroundColor: context.customColor.reversedTextColor,
      onTap: () {
        AppBottomSheet.customPageRoute(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    ValidationCubit(requiredFields: {'reason'}),
              ),
              BlocProvider(create: (context) => getIt<BranchCancelItemCubit>()),
            ],
            child: Scaffold(
              body: BlocConsumer<BranchCancelItemCubit, BranchCancelItemState>(
                listener: (context, state) {
                  if (state is BranchCancelItemSuccess) {
                    NavigationService.I.popToFirst();

                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => SupplierRejectedSuccessBottomSheetWidget(
                        title: context.tr.itemCancelled,
                      ),
                    );
                  } else if (state is BranchCancelItemFailure) {
                    AppDialog.showErrorDialog(
                      context: context,
                      failure: state.failure,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BranchCancelItemLoading) {
                    return const AppLoadingWidget();
                  }

                  return SupplierRejectItemBottomSheetWidget(
                    itemName: item.itemName,
                    itemImage: '',
                    itemUnit: item.itemUnit,
                    requestedQty: item.requestedQty.toString(),
                    price: item.itemPrice.toString(),
                    totalPrice: item.totalPrice.toString(),
                    quality: item.quality.getString(context),
                    onClick: (String reason) {
                      context.read<BranchCancelItemCubit>().cancelItem(
                        orderId: orderId,
                        itemId: item.itemId,
                        body: RejectAllOrderRequest(reason: reason),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget onCancelledItemByBranch(BuildContext context) {
    return Column(
      children: [
        AppGestureDetectorButton(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr.duplicateAndChangeSource,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.horizontalSpace,
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
        ),
        10.verticalSpace,
        AppGestureDetectorButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr.viewCancellationDetails,
                textAlign: TextAlign.center,
                style: AppStyles.s12W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
              5.horizontalSpace,
              Icon(
                Icons.keyboard_arrow_down,
                size: 15.r,
                color: context.theme.primaryColor,
              ),
            ],
          ),
          onTap: () {
            AppBottomSheet.show(
              context,
              (context) => BlocProvider(
                create: (context) => getIt<BranchGetCancelReasonCubit>(),
                child: BranchRequestsCancelationsDetailsBottomSheet(
                  item: item,
                  orderId: orderId,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget onCancelledItemBySupplier(BuildContext context) {
    return Column(
      children: [
        AppGestureDetectorButton(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr.duplicateAndChangeSource,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.horizontalSpace,
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
        ),
        10.verticalSpace,
        AppGestureDetectorButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr.viewCancellationDetails,
                textAlign: TextAlign.center,
                style: AppStyles.s12W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
              5.horizontalSpace,
              Icon(
                Icons.keyboard_arrow_down,
                size: 15.r,
                color: context.theme.primaryColor,
              ),
            ],
          ),
          onTap: () {
            AppBottomSheet.show(
              context,
              (context) => BlocProvider(
                create: (context) => getIt<BranchGetCancelReasonCubit>(),
                child: BranchRequestsCancelationsDetailsBottomSheet(
                  item: item,
                  orderId: orderId,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget onPendingApproval(BuildContext context) {
    return CustomTextButton(
      text: context.tr.reviewModification,
      borderRadius: 1000.r,
      textColor: context.customColor.reversedTextColor,
      backgroundColor: context.theme.primaryColor,
      borderColor: context.theme.primaryColor,
      padding: EdgeInsets.symmetric(vertical: 14.r),
      onTap: () {
        AppBottomSheet.show(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<BranchGetModificationCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<BranchApproveOrRejectModificationCubit>(),
              ),
            ],
            child: BranchRequestsModificationDetailsBottomSheet(
              itemId: item.id,
              orderId: orderId,
              cancelItemId: item.itemId,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget onCancelledItemModification(BuildContext context) {
    return Column(
      children: [
        AppGestureDetectorButton(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: context.customColor.reversedTextColor,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: context.customColor.border),
            ),
            padding: EdgeInsets.all(12.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr.duplicateAndChangeSource,
                  textAlign: TextAlign.center,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                ),
                10.horizontalSpace,
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
        ),
        10.verticalSpace,
        AppGestureDetectorButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr.viewCancellationDetails,
                textAlign: TextAlign.center,
                style: AppStyles.s12W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
              5.horizontalSpace,
              Icon(
                Icons.keyboard_arrow_down,
                size: 15.r,
                color: context.theme.primaryColor,
              ),
            ],
          ),
          onTap: () {
            AppBottomSheet.show(
              context,
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => getIt<BranchGetModificationCubit>(),
                  ),
                  BlocProvider(
                    create: (context) =>
                        getIt<BranchApproveOrRejectModificationCubit>(),
                  ),
                ],
                child: BranchRequestsModificationDetailsBottomSheet(
                  itemId: item.id,
                  orderId: orderId,
                  cancelItemId: item.itemId,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SupplierRequestTypeStrategy extends RequestsOrderTypeStrategy {
  final SupplierOrderDetailsResponse request;

  SupplierRequestTypeStrategy(super.statusStrategy, {required this.request});

  @override
  Widget onPendingDetails(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextButton(
            text: context.tr.rejectAll,
            borderRadius: 15.r,
            textColor: context.customColor.error,
            backgroundColor: context.customColor.reversedTextColor,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          ValidationCubit(requiredFields: {'reason'}),
                    ),
                    BlocProvider(
                      create: (context) =>
                          getIt<SupplierConfirmOrRejectOrderOrItemCubit>(),
                    ),
                  ],
                  child: Scaffold(
                    body:
                        BlocConsumer<
                          SupplierConfirmOrRejectOrderOrItemCubit,
                          SupplierConfirmOrRejectOrderOrItemState
                        >(
                          listener: (context, state) {
                            if (state
                                is SupplierConfirmOrRejectOrderOrItemSuccess) {
                              NavigationService.I.popToFirst();

                              AppBottomSheet.customPageRoute(
                                context,
                                (context) =>
                                    SupplierRejectedSuccessBottomSheetWidget(
                                      title: context.tr.orderRejected,
                                    ),
                              );
                            } else if (state
                                is SupplierConfirmOrRejectOrderOrItemFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state
                                is SupplierConfirmOrRejectOrderOrItemLoading) {
                              return const AppLoadingWidget();
                            }

                            return SupplierRejectRequestBottomSheetWidget(
                              onClick: (reason) {
                                context
                                    .read<
                                      SupplierConfirmOrRejectOrderOrItemCubit
                                    >()
                                    .supplierCancelOrder(
                                      orderId: request.data.id,
                                      body: RejectAllOrderRequest(
                                        reason: reason,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomTextButton(
            text: context.tr.approveAll,
            borderRadius: 15.r,
            textColor: context.customColor.reversedTextColor,
            backgroundColor: context.theme.primaryColor,
            onTap: () {
              AppBottomSheet.show(
                context,
                (context) => BlocProvider(
                  create: (context) =>
                      getIt<SupplierConfirmOrRejectOrderOrItemCubit>(),
                  child: SupplierApproveAllBottomSheetWidget(
                    items: request.data.items,
                    orderId: request.data.id,
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
      ],
    );
  }

  @override
  Widget onConfirmedDetails(BuildContext context) {
    return CustomTextButton(
      text: context.tr.markAllAsPreparing,
      onTap: () {
        final items = request.data.items
            .where(
              (element) =>
                  (element.status is PartialConfirmedStatusStrategyImpl) ||
                  (element.status is ConfirmedStatusStrategyImpl) ||
                  (element.status is ConfirmedNeedTimeStatusStrategyImpl) ||
                  (element.status
                      is ConfirmedAlternativeProductStatusStrategyImpl),
            )
            .toList();

        AppBottomSheet.customPageRoute(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {}),
              ),
              BlocProvider(
                create: (context) => getIt<SupplierStartTrackOrderCubit>(),
              ),
            ],
            child: SupplierMarkAllAsPreparingScreen(
              items: items,
              orderId: request.data.id,
            ),
          ),
        );
      },
      padding: EdgeInsets.symmetric(vertical: 14.r),
      borderRadius: 12.r,
      backgroundColor: context.customColor.dark,
      textColor: context.customColor.reversedTextColor,
    );
  }

  @override
  Widget onCancelledByBranchDetails(BuildContext context) {
    return AppButton(
      onClick: () {},
      text: context.tr.orderRejectedByBranch,
      borderRadius: BorderRadius.circular(15.r),
      padding: EdgeInsets.symmetric(vertical: 14.r),
    );
  }

  @override
  Widget onCancelledBySupplierDetails(BuildContext context) {
    return AppButton(
      onClick: () {},
      text: context.tr.orderRejectedByYou,
      borderRadius: BorderRadius.circular(15.r),
      padding: EdgeInsets.symmetric(vertical: 14.r),
    );
  }

  @override
  Widget onPreparingDetails(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ButtonTextIcon(
            label: context.tr.reportDelay,
            icon: Icon(
              Icons.access_time_rounded,
              size: 16.r,
              color: context.theme.primaryColor,
            ),
            spaceBetweenTextAndIcon: 7,
            borderRadius: BorderRadius.circular(15.r),
            textColor: context.customColor.text1,
            backgroundColor: context.customColor.text2,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => getIt<MediaCubit>()),
                    BlocProvider(
                      create: (context) =>
                          getIt<SupplierStartTrackOrderCubit>(),
                    ),
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {'details', 'newTime'},
                      ),
                    ),
                  ],
                  child: SupplierReportDelay(orderId: request.data.id),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomTextButton(
            text: context.tr.markAllForDelivery,
            borderRadius: 15.r,
            textColor: context.customColor.reversedTextColor,
            backgroundColor: AppColors.orange,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {
                          'deliveryAddress',
                          'deliveryName',
                          'vehicleNumber',
                          'deliveryTime',
                        },
                        optionalFields: {'deliveryNotes'},
                      ),
                    ),
                    BlocProvider(create: (context) => getIt<MediaCubit>()),
                    BlocProvider(
                      create: (context) =>
                          getIt<SupplierStartTrackOrderCubit>(),
                    ),
                  ],
                  child: SupplierMarkAllForDeliveryScreen(
                    orderId: request.data.id,
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
      ],
    );
  }

  @override
  Widget onOutForDeliveryDetails(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ButtonTextIcon(
            label: context.tr.reportDelay,
            icon: Icon(
              Icons.access_time_rounded,
              size: 16.r,
              color: context.theme.primaryColor,
            ),
            spaceBetweenTextAndIcon: 7,
            borderRadius: BorderRadius.circular(15.r),
            textColor: context.customColor.text1,
            backgroundColor: context.customColor.text2,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => getIt<MediaCubit>()),
                    BlocProvider(
                      create: (context) => ValidationCubit(
                        requiredFields: {'details', 'newTime'},
                      ),
                    ),
                    BlocProvider(
                      create: (context) =>
                          getIt<SupplierStartTrackOrderCubit>(),
                    ),
                  ],
                  child: SupplierReportDelay(orderId: request.data.id),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomTextButton(
            text: context.tr.markAllAsDelivered,
            borderRadius: 15.r,
            textColor: context.customColor.reversedTextColor,
            backgroundColor: AppColors.lightGreen,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          ValidationCubit(requiredFields: {'file'}),
                    ),
                    BlocProvider(create: (context) => getIt<MediaCubit>()),
                    BlocProvider(
                      create: (context) =>
                          getIt<SupplierStartTrackOrderCubit>(),
                    ),
                  ],
                  child: SupplierMarkAllAsDeliveredScreen(
                    orderId: request.data.id,
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
      ],
    );
  }

  @override
  Widget delayedDeliveryDetails(BuildContext context) {
    return CustomTextButton(
      text: context.tr.markAllForDelivery,
      borderRadius: 15.r,
      textColor: context.customColor.reversedTextColor,
      backgroundColor: AppColors.orange,
      onTap: () {
        AppBottomSheet.customPageRoute(
          context,
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'deliveryAddress',
                    'deliveryName',
                    'vehicleNumber',
                    'deliveryTime',
                  },
                  optionalFields: {'deliveryNotes'},
                ),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(
                create: (context) => getIt<SupplierStartTrackOrderCubit>(),
              ),
            ],
            child: SupplierMarkAllForDeliveryScreen(orderId: request.data.id),
          ),
        );
      },
      padding: EdgeInsets.symmetric(vertical: 14.r),
    );
  }

  @override
  Widget buildModificationDetailsDelayPendingRequest(BuildContext context) {
    return DelayRequestStatusWidget(
      text: context.tr
          .youSubmittedADeliveryDateTimeExtensionPendingApprovalFromBranchName(
            request.delayDetails?.delayReportedAt ?? '',
            request.delayDetails?.branchManagerName ?? '',
          ),
      strategy: this,
      delayDetails: request.delayDetails!,
    );
  }

  @override
  Widget buildModificationDetailsDelayApprovedRequest(BuildContext context) {
    return DelayRequestStatusWidget(
      text: context.tr.newDateTimeExtensionApprovedByBranchName(
        request.delayDetails?.delayApprovedAt ?? '',
        request.delayDetails?.branchManagerName ?? '',
      ),
      strategy: this,
      textColor: AppColors.lightGreen,
      delayDetails: request.delayDetails!,
    );
  }

  @override
  Widget buildModificationDetailsDelayRejectedRequest(BuildContext context) {
    return DelayRequestStatusWidget(
      text: context.tr.newDateTimeExtensionRejected(
        request.delayDetails?.delayRejectedAt ?? '',
      ),
      strategy: this,
      textColor: context.customColor.error,
      delayDetails: request.delayDetails!,
      customWidget: RejectedWidget(
        reason: request.reasonForRejected?.toCancelReasonResponse(),
      ),
    );
  }
}

class SupplierItemRequestTypeStrategy extends RequestsOrderTypeStrategy {
  final SupplierOrderItem item;
  final String orderId;

  SupplierItemRequestTypeStrategy(
    super.statusStrategy, {
    required this.item,
    required this.orderId,
  });

  @override
  Widget onPendingItem(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextButton(
            text: context.tr.rejectItem,
            borderRadius: 1000.r,
            textColor: context.customColor.error,
            backgroundColor: context.customColor.reversedTextColor,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          ValidationCubit(requiredFields: {'reason'}),
                    ),
                    BlocProvider(
                      create: (context) =>
                          getIt<SupplierConfirmOrRejectOrderOrItemCubit>(),
                    ),
                  ],
                  child: Scaffold(
                    body:
                        BlocConsumer<
                          SupplierConfirmOrRejectOrderOrItemCubit,
                          SupplierConfirmOrRejectOrderOrItemState
                        >(
                          listener: (context, state) {
                            if (state
                                is SupplierConfirmOrRejectOrderOrItemSuccess) {
                              NavigationService.I.popToFirst();

                              AppBottomSheet.customPageRoute(
                                context,
                                (context) =>
                                    SupplierRejectedSuccessBottomSheetWidget(
                                      title: context.tr.itemRejected,
                                    ),
                              );
                            } else if (state
                                is SupplierConfirmOrRejectOrderOrItemFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state
                                is SupplierConfirmOrRejectOrderOrItemLoading) {
                              return const AppLoadingWidget();
                            }

                            return SupplierRejectItemBottomSheetWidget(
                              itemName: item.productName,
                              itemImage: '',
                              itemUnit: item.productUnit,
                              requestedQty: item.orderedQuantity.toString(),
                              price: item.unitPrice.toString(),
                              totalPrice: item.totalPrice.toString(),
                              quality: item.qualityLevel.getString(context),
                              onClick: (String reason) {
                                context
                                    .read<
                                      SupplierConfirmOrRejectOrderOrItemCubit
                                    >()
                                    .supplierCancelItem(
                                      orderId: orderId,
                                      itemId: item.productId,
                                      body: RejectAllOrderRequest(
                                        reason: reason,
                                      ),
                                    );
                              },
                            );
                          },
                        ),
                  ),
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: ButtonTextIcon(
            label: context.tr.mainActions,
            icon: Icon(
              Icons.more_vert,
              size: 15.r,
              color: context.customColor.reversedTextColor,
            ),
            borderRadius: BorderRadius.circular(1000.r),
            textColor: context.customColor.reversedTextColor,
            backgroundColor: context.theme.primaryColor,
            onTap: () {
              AppBottomSheet.customPageRoute(
                context,
                (context) => SupplierMainActionsBottomSheetWidget(
                  item: item,
                  orderId: orderId,
                ),
              );
            },
            padding: EdgeInsets.symmetric(vertical: 14.r),
          ),
        ),
      ],
    );
  }

  @override
  Widget onCancelledItem(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        AppBottomSheet.show(
          context,
          (context) => BlocProvider(
            create: (context) => getIt<SupplierGetCancellationReasonCubit>(),
            child: SupplierViewCancellationDetailsBottomSheet(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr.viewCancellationDetails,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.r,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget onCancelledItemByBranch(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        AppBottomSheet.show(
          context,
          (context) => BlocProvider(
            create: (context) => getIt<SupplierGetCancellationReasonCubit>(),
            child: SupplierRequestsCancelationsDetailsBottomSheet(
              item: item,
              orderId: orderId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr.viewCancellationDetails,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.r,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget onCancelledItemBySupplier(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        AppBottomSheet.show(
          context,
          (context) => BlocProvider(
            create: (context) => getIt<SupplierGetCancellationReasonCubit>(),
            child: SupplierRequestsCancelationsDetailsBottomSheet(
              item: item,
              orderId: orderId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr.viewCancellationDetails,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.r,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget onPendingApproval(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        AppBottomSheet.show(
          context,
          (context) => BlocProvider(
            create: (context) => getIt<SupplierGetModificationCubit>(),
            child: SupplierRequestsModificationDetailsBottomSheet(
              orderId: orderId,
              itemId: item.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr.viewModificationDetails,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.r,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget onCancelledItemModification(BuildContext context) {
    return AppGestureDetectorButton(
      onTap: () {
        AppBottomSheet.show(
          context,
          (context) => BlocProvider(
            create: (context) => getIt<SupplierGetModificationCubit>(),
            child: SupplierRequestsModificationDetailsBottomSheet(
              orderId: orderId,
              itemId: item.id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.customColor.reversedTextColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: context.customColor.border),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.tr.viewCancellationDetails,
              style: AppStyles.s14W500.copyWith(
                color: context.customColor.text1,
              ),
            ),
            10.horizontalSpace,
            Icon(
              Icons.keyboard_arrow_down,
              size: 18.r,
              color: context.customColor.text1,
            ),
          ],
        ),
      ),
    );
  }
}
