import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/network_file_preview_widget.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:assab/features/branch_manager_expenses/data/models/attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/custody_requests_status_enum.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/rejected_widget.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_cubit.dart';
import '../../../brand_owner_requests/presentation/cubits/branch_owner_approve_reject_state.dart';
import '../../../brand_owner_requests/presentation/widgets/brand_owner_reject_custody_bottom_sheet_widget.dart';
import '../../data/models/custody_request_details_response.dart';
import '../cubit/custody_get_requets/custody_get_requets_cubit.dart';

class CustodyRequestDetailsScreenDetailsView extends StatelessWidget {
  final CustodyRequestDetailsData details;
  final UserTypeStrategy userTypeStrategy;
  final void Function()? onApproveRejectSuccess;

  const CustodyRequestDetailsScreenDetailsView({
    super.key,
    required this.details,
    required this.userTypeStrategy,
    this.onApproveRejectSuccess,
  });

  String _getFileType(String url) {
    if (url.endsWith('.pdf')) {
      return 'PDF';
    } else if (url.endsWith('.doc') || url.endsWith('.docx')) {
      return 'Word';
    } else if (url.endsWith('.xls') || url.endsWith('.xlsx')) {
      return 'Excel';
    } else if (url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.endsWith('.png') ||
        url.endsWith('.gif')) {
      return 'Image';
    } else {
      return 'File';
    }
  }

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
                        context.tr.requestedAmount,
                        details.details.requestedAmount.toStringAsFixed(2),
                        isCurrency: true,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.purpose,
                        details.details.purpose,
                      ),
                      8.verticalSpace,
                      const CustomDivider(),
                      8.verticalSpace,
                      _buildDetailRow(
                        context,
                        context.tr.preferredReceiptMethod,
                        details.details.preferredReceiptMethod,
                      ),
                      8.verticalSpace,
                    ],
                  ),
                ),
                if (details.details.attachments.isNotEmpty) ...[
                  14.verticalSpace,
                  Text(
                    '${context.tr.attachments} (${details.details.attachments.length})',
                    style: AppStyles.s14W600.copyWith(
                      color: context.customColor.text1,
                    ),
                  ),
                  8.verticalSpace,
                  NetworkFilePreviewWidget(
                    attachmentModel: AttachmentModel(
                      id: '',
                      fileName: details.details.attachments[0].filename,
                      fileType: _getFileType(
                        details.details.attachments[0].url,
                      ),
                      fileSize: 0,
                      url: details.details.attachments[0].url,
                      uploadedAt: details.details.attachments[0].uploadedAt,
                    ),
                  ),
                ],
                if (details.details.additionalNotes != null &&
                    details.details.additionalNotes!.isNotEmpty) ...[
                  14.verticalSpace,
                  Text(
                    context.tr.additionalNotes,
                    style: AppStyles.s14W400.copyWith(
                      color: context.customColor.text3,
                    ),
                  ),
                  4.verticalSpace,
                  ContainerCustomTextField(
                    width: double.infinity,
                    child: Text(
                      details.details.additionalNotes ?? '',
                      style: AppStyles.s14W500.copyWith(
                        color: context.customColor.text1,
                      ),
                    ),
                  ),
                ],
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
                    if (state
                        is BranchOwnerApproveRejectCustodyRequestSuccess) {
                      context
                          .read<CustodyGetRequetsCubit>()
                          .getCustodyRequests();
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
                                    final custodyGetRequetsCubit = context
                                        .read<CustodyGetRequetsCubit>();

                                    AppBottomSheet.showModal(
                                      context,
                                      isScrollControlled: true,
                                      (context) => BlocProvider.value(
                                        value: branchOwnerApproveRejectCubit,
                                        child:
                                            BrandOwnerRejectCustodyBottomSheetWidget(
                                              id: details.requestId,
                                              onSuccess: () {
                                                custodyGetRequetsCubit
                                                    .getCustodyRequests();
                                                onApproveRejectSuccess?.call();
                                              },
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
                                        .approveCustodyRequest(
                                          requestId: details.requestId,
                                          onSuccess: () {
                                            context
                                                .read<CustodyGetRequetsCubit>()
                                                .getCustodyRequests();
                                            onApproveRejectSuccess?.call();
                                          },
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
      children: [
        Expanded(
          child: Text(
            label,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
          ),
        ),
        10.horizontalSpace,
        if (isCurrency) const SaudiRiyalSvgWidget(),
        5.horizontalSpace,
        Text(
          value,
          style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
        ),
      ],
    );
  }
}
