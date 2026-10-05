import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart';
import 'package:assab/features/branch_manager_requests/presentation/cubit/select_branch_manager_delivery_time/select_branch_manager_delivery_time_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/select_branch_manager_delivery_time_enum.dart';
import '../../domain/strategies/approve_or_reject_order_strategy.dart';
import '../cubit/approve_or_reject_order/approve_or_reject_order_state.dart';
import '../cubit/select_branch_manager_delivery_time/select_branch_manager_delivery_time_cubit.dart';
import 'request_approved_success_bottom_sheet_widget.dart';

class BranchManagerRequestsDeliveryTimeBottomSheetWidget
    extends StatelessWidget {
  final ApproveOrRejectOrderStrategy strategy;
  final void Function()? onConfirmButtonSuccess;

  const BranchManagerRequestsDeliveryTimeBottomSheetWidget({
    super.key,
    required this.strategy,
    this.onConfirmButtonSuccess,
  });

  void _selectDeliveryTime(
    BuildContext context,
    SelectBranchManagerDeliveryTimeEnum selectDeliveryTime,
  ) {
    context.read<SelectBranchManagerDeliveryTimeCubit>().selectDeliveryTime(
      selectDeliveryTime,
    );

    strategy.updateReadyTime(selectDeliveryTime.value);
  }

  @override
  Widget build(BuildContext context) {
    return AppPaddingWidget(
      top: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppGestureDetectorButton(
                onTap: () => NavigationService.I.pop(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 6.r,
                  ),
                  child: Row(
                    children: [
                      AppSvg(assetName: AppAssets.arrowLeft, width: 12.w),
                      5.horizontalSpace,
                      Text(
                        context.tr.changeChoice,
                        style: AppStyles.s12W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Text(
            context.tr.deliveryTime,
            style: AppStyles.s20W600.copyWith(color: context.customColor.text1),
          ),
          12.verticalSpace,
          Text(
            context.tr.chooseWhenThisOrderWillBeDelivered,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
          16.verticalSpace,
          const CustomDivider(),
          16.verticalSpace,
          LabelTextField(text: context.tr.orderWillBeReadyIn),
          12.verticalSpace,
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.r,
              crossAxisSpacing: 10.r,
              childAspectRatio: 3.5,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final texts = [
                '30 ${context.tr.mins}',
                '1 ${context.tr.hr}',
                '2 ${context.tr.hrs}',
                '3 ${context.tr.hrs}+',
              ];

              final deliveryTimes = [
                SelectBranchManagerDeliveryTimeEnum.min30,
                SelectBranchManagerDeliveryTimeEnum.hour1,
                SelectBranchManagerDeliveryTimeEnum.hour2,
                SelectBranchManagerDeliveryTimeEnum.hour3,
              ];

              return BlocSelector<
                SelectBranchManagerDeliveryTimeCubit,
                SelectBranchManagerDeliveryTimeState,
                bool
              >(
                selector: (state) =>
                    state.selectedDeliveryTime == deliveryTimes[index],
                builder: (context, state) {
                  return CustomTextButton(
                    text: texts[index],
                    textColor: state
                        ? context.theme.primaryColor
                        : context.customColor.text4,
                    borderColor: state
                        ? context.theme.primaryColor
                        : context.customColor.border,
                    onTap: () {
                      _selectDeliveryTime(context, deliveryTimes[index]);
                    },
                  );
                },
              );
            },
          ),
          const Spacer(),
          BlocBuilder<
            SelectBranchManagerDeliveryTimeCubit,
            SelectBranchManagerDeliveryTimeState
          >(
            builder: (context, selectBranchManagerDeliveryTimeState) {
              return BlocConsumer<
                ApproveOrRejectOrderCubit,
                ApproveOrRejectOrderState
              >(
                listener: (context, state) {
                  if (state is ApproveOrRejectOrderSuccess) {
                    NavigationService.I.popToFirst();

                    onConfirmButtonSuccess?.call();

                    AppBottomSheet.pageRoute(
                      context,
                      (context) => const Expanded(
                        child: RequestApprovedSuccessBottomSheetWidget(),
                      ),
                    );
                  } else if (state is ApproveOrRejectOrderFailure) {
                    AppDialog.showErrorDialog(
                      context: context,
                      failure: state.failure,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ApproveOrRejectOrderLoading) {
                    return const AppButtonLoading();
                  }

                  return AppButton(
                    onClick: () {
                      strategy.execute(context);
                    },
                    text: context.tr.approveAllRequest,
                    enabled:
                        selectBranchManagerDeliveryTimeState
                            .selectedDeliveryTime !=
                        SelectBranchManagerDeliveryTimeEnum.non,
                    borderRadius: BorderRadius.circular(17.r),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
