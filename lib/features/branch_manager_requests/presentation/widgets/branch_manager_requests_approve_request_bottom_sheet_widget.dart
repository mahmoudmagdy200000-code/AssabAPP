import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/enums/approve_request_type_enum.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/selection_circule.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/select_branch_manager_approve_request/select_branch_manager_approve_request_state.dart';
import 'package:assab/features/branch_manager_requests/presentation/widgets/reject_request_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/approve_all_order_request.dart';
import '../../data/models/orders_response.dart';
import '../../domain/strategies/approve_or_reject_order_strategy.dart';
import '../cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart';
import '../cubit/select_branch_manager_approve_request/select_branch_manager_approve_request_cubit.dart';
import '../cubit/select_branch_manager_delivery_time/select_branch_manager_delivery_time_cubit.dart';
import 'branch_manager_requests_delivery_time_bottom_sheet_widget.dart';
import 'partial_approval_bottom_sheet_widget.dart';

class BranchManagerRequestsApproveRequestBottomSheetWidget
    extends StatelessWidget {
  final OrderData request;

  const BranchManagerRequestsApproveRequestBottomSheetWidget({
    super.key,
    required this.request,
  });

  void _selectApproveRequestType(
    BuildContext context,
    ApproveRequestTypeEnum approveRequestType,
  ) {
    context
        .read<SelectBranchManagerApproveRequestCubit>()
        .selectApproveRequestType(approveRequestType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWidget(
        top: 50.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr.approveRequest,
              style: AppStyles.s20W600.copyWith(
                color: context.customColor.text1,
              ),
            ),
            12.verticalSpace,
            Text(
              context.tr.selectOneOfTheOptionsBelowToApproveThisRequest,
              style: AppStyles.s14W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            16.verticalSpace,
            const CustomDivider(),
            16.verticalSpace,
            BlocSelector<
              SelectBranchManagerApproveRequestCubit,
              SelectBranchManagerApproveRequestState,
              bool
            >(
              selector: (state) =>
                  state.approveRequestType == ApproveRequestTypeEnum.approveAll,
              builder: (context, state) {
                return _buildOptionItem(
                  context: context,
                  title: context.tr.approveAll,
                  selected: state,
                  desc: context
                      .tr
                      .all3RequestedProductsQuantitiesWillBeApprovedWhenYou,
                  onTap: () => _selectApproveRequestType(
                    context,
                    ApproveRequestTypeEnum.approveAll,
                  ),
                );
              },
            ),
            16.verticalSpace,
            BlocSelector<
              SelectBranchManagerApproveRequestCubit,
              SelectBranchManagerApproveRequestState,
              bool
            >(
              selector: (state) =>
                  state.approveRequestType ==
                  ApproveRequestTypeEnum.partialApproval,
              builder: (context, state) {
                return _buildOptionItem(
                  context: context,
                  title: context.tr.partialApproval,
                  selected: state,
                  desc: context.tr.chooseWhatProductQuantitiesToApprove,
                  onTap: () => _selectApproveRequestType(
                    context,
                    ApproveRequestTypeEnum.partialApproval,
                  ),
                );
              },
            ),
            16.verticalSpace,
            BlocSelector<
              SelectBranchManagerApproveRequestCubit,
              SelectBranchManagerApproveRequestState,
              bool
            >(
              selector: (state) =>
                  state.approveRequestType == ApproveRequestTypeEnum.rejectAll,
              builder: (context, state) {
                return _buildOptionItem(
                  context: context,
                  title: context.tr.rejectAll,
                  selected: state,
                  desc: context.tr.thisRequestWillBeRejectedWhenYouClickConfirm,
                  onTap: () => _selectApproveRequestType(
                    context,
                    ApproveRequestTypeEnum.rejectAll,
                  ),
                );
              },
            ),
            const Spacer(),
            BlocSelector<
              SelectBranchManagerApproveRequestCubit,
              SelectBranchManagerApproveRequestState,
              ApproveRequestTypeEnum
            >(
              selector: (state) => state.approveRequestType,
              builder: (context, state) {
                return AppButton(
                  onClick: () {
                    final approveOrRejectOrderCubit = context
                        .read<ApproveOrRejectOrderCubit>();

                    AppBottomSheet.pageRoute(context, (context) {
                      switch (state) {
                        case ApproveRequestTypeEnum.non:
                          return const SizedBox.shrink();
                        case ApproveRequestTypeEnum.approveAll:
                          return _branchManagerRequestsDeliveryTimeBottomSheetWidget(
                            context,
                            approveOrRejectOrderCubit,
                          );
                        case ApproveRequestTypeEnum.partialApproval:
                          return _branchManagerRequestsPartialApprovalBottomSheetWidget(
                            context,
                            approveOrRejectOrderCubit,
                          );
                        case ApproveRequestTypeEnum.rejectAll:
                          return _branchManagerRequestsRejectRequestBottomSheetWidget(
                            context,
                            approveOrRejectOrderCubit,
                          );
                      }
                    });
                  },
                  enabled: state != ApproveRequestTypeEnum.non,
                  text: context.tr.next,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required BuildContext context,
    required String title,
    required String desc,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    return AppGestureDetectorButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? context.theme.primaryColor
                : context.customColor.border,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.s16W500.copyWith(
                      color: selected
                          ? context.theme.primaryColor
                          : context.customColor.text1,
                    ),
                  ),
                ),
                10.horizontalSpace,
                SelectionCircule(isSelected: selected),
              ],
            ),
            6.verticalSpace,
            Text(
              desc,
              style: AppStyles.s13W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _branchManagerRequestsDeliveryTimeBottomSheetWidget(
    BuildContext context,
    ApproveOrRejectOrderCubit approveOrRejectOrderCubit,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SelectBranchManagerDeliveryTimeCubit>(),
        ),
        BlocProvider.value(value: approveOrRejectOrderCubit),
      ],
      child: Expanded(
        child: BranchManagerRequestsDeliveryTimeBottomSheetWidget(
          strategy: ApproveAllOrderStrategy(
            orderId: request.id,
            body: ApproveAllOrderRequest(),
          ),
        ),
      ),
    );
  }

  Widget _branchManagerRequestsPartialApprovalBottomSheetWidget(
    BuildContext context,
    ApproveOrRejectOrderCubit approveOrRejectOrderCubit,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SelectBranchManagerDeliveryTimeCubit>(),
        ),
        BlocProvider.value(value: approveOrRejectOrderCubit),
        BlocProvider(create: (context) => ValidationCubit(requiredFields: {})),
      ],
      child: Expanded(
        child: PartialApprovalBottomSheetWidget(request: request),
      ),
    );
  }

  Widget _branchManagerRequestsRejectRequestBottomSheetWidget(
    BuildContext context,
    ApproveOrRejectOrderCubit approveOrRejectOrderCubit,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SelectBranchManagerDeliveryTimeCubit>(),
        ),
        BlocProvider.value(value: approveOrRejectOrderCubit),
        BlocProvider(
          create: (context) => ValidationCubit(requiredFields: {'reason'}),
        ),
      ],
      child: Expanded(
        child: RejectRequestBottomSheetWidget(orderId: request.id),
      ),
    );
  }
}
