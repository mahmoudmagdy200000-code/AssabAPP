import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/custody_requests_status_enum.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/rejected_widget.dart';
import '../../data/models/brand_owner_requests_models.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_cubit.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_state.dart';
import '../widgets/brand_owner_reject_sales_transfer_bottom_sheet_widget.dart';

class BrandOwnerSalesTransferDetailsScreenDetailsView extends StatelessWidget {
  final UserTypeStrategy userTypeStrategy;
  final BrandOwnerSalesTransferDetailsModel details;
  final void Function()? onApproveRejectSuccess;
  final void Function()? onListRefresh;

  const BrandOwnerSalesTransferDetailsScreenDetailsView({
    super.key,
    required this.userTypeStrategy,
    required this.details,
    this.onApproveRejectSuccess,
    this.onListRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details.status == CustodyRequestsStatusEnum.rejected) ...[
                  RejectedWidget(reason: details.cancelReason),
                  14.verticalSpace,
                ],
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.tr.requestSummary,
                              style: AppStyles.s16W600.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            details.status.getLabel(context),
                            style: AppStyles.s12W500.copyWith(
                              color: details.status.getLabelColor(context),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      const CustomDivider(),
                      10.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.transferFrom,
                        details.summary.transferFrom,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.recipient,
                        details.summary.recipientName,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.handOverAmount,
                        details.summary.handoverAmount.toStringAsFixed(2),
                        isCurrency: true,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.handoverMethod,
                        details.summary.handoverMethod,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.handoverDate,
                        details.summary.handoverDate,
                      ),
                    ],
                  ),
                ),
                // if (details.details.additionalNotes != null &&
                //     details.details.additionalNotes!.isNotEmpty) ...[
                //   14.verticalSpace,
                //   Text(
                //     context.tr.additionalNotes,
                //     style: AppStyles.s14W400.copyWith(
                //       color: context.customColor.text3,
                //     ),
                //   ),
                //   4.verticalSpace,
                //   ContainerCustomTextField(
                //     width: double.infinity,
                //     child: Text(
                //       details.details.additionalNotes ?? '',
                //       style: AppStyles.s14W500.copyWith(
                //         color: context.customColor.text1,
                //       ),
                //     ),
                //   ),
                // ],
                14.verticalSpace,
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: context.customColor.border),
                  ),
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Sender Details',
                          style: AppStyles.s16W600.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                      ProfileImageWidget(width: 100.h, height: 100.h),
                      10.verticalSpace,
                      Text(
                        details.sender.name,
                        style: AppStyles.s15W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      5.verticalSpace,
                      Text(
                        details.sender.branchName,
                        style: AppStyles.s14W500.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (userTypeStrategy is BrandOwnerUserStrategy &&
            details.status == CustodyRequestsStatusEnum.pending) ...[
          20.verticalSpace,
          BlocProvider(
            create: (context) => getIt<BranchOwnerApproveRejectCubit>(),
            child:
                BlocListener<
                  BranchOwnerApproveRejectCubit,
                  BranchOwnerApproveRejectState
                >(
                  listener: (context, state) {
                    if (state is BranchOwnerApproveRejectSalesTransferSuccess) {
                      onListRefresh?.call();
                      onApproveRejectSuccess?.call();
                    } else if (state is BranchOwnerApproveRejectFailure) {
                      AppDialog.showErrorDialog(
                        context: context,
                        failure: state.failure,
                      );
                    }
                  },
                  child:
                      BlocBuilder<
                        BranchOwnerApproveRejectCubit,
                        BranchOwnerApproveRejectState
                      >(
                        builder: (context, state) {
                          if (state is BranchOwnerApproveRejectLoading) {
                            return const AppButtonLoading();
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.reject,
                                  onTap: () {
                                    final branchOwnerApproveRejectCubit =
                                        context
                                            .read<
                                              BranchOwnerApproveRejectCubit
                                            >();

                                    AppBottomSheet.showModal(
                                      context,
                                      isScrollControlled: true,
                                      (context) => BlocProvider.value(
                                        value: branchOwnerApproveRejectCubit,
                                        child:
                                            BrandOwnerRejectSalesTransferBottomSheetWidget(
                                              id: details.requestId,
                                            ),
                                      ),
                                    );
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 16.r),
                                  textColor: context.customColor.error,
                                  borderRadius: 20.r,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: CustomTextButton(
                                  text: context.tr.approve,
                                  onTap: () {
                                    context
                                        .read<BranchOwnerApproveRejectCubit>()
                                        .approveSalesTransfer(
                                          salesTransferId: details.requestId,
                                        );
                                  },
                                  padding: EdgeInsets.symmetric(vertical: 16.r),
                                  textColor:
                                      context.customColor.reversedTextColor,
                                  borderRadius: 20.r,
                                  backgroundColor: context.theme.primaryColor,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                ),
          ),
        ],

        /// TODO: Handle When Get Status From API In the future
        // 20.verticalSpace,
        // const EditAndResubmitButton(),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (isCurrency) const SaudiRiyalSvgWidget(),
              5.horizontalSpace,
              Flexible(
                child: Text(
                  value,
                  style: AppStyles.s14W500.copyWith(
                    color: context.customColor.text1,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
