import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/date_formatter.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_svg.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/profile_image_widget.dart';
import 'package:assab/features/fixed_assets/presentation/cubit/complete__handover_session/complete__handover_session_state.dart';
import 'package:assab/features/fixed_assets/presentation/cubit/get_active_handover_session_summary/get_active_handover_session_summary_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../../../core/widgets/saudi_riyal_svg_widget.dart';
import '../cubit/complete__handover_session/complete__handover_session_cubit.dart';
import '../cubit/get_active_handover_session_summary/get_active_handover_session_summary_cubit.dart';
import 'fixed_assets_handover_success_screen.dart';

class FixedAssetsActiveHandoverSessionSummaryView extends StatelessWidget {
  final String sessionId;

  const FixedAssetsActiveHandoverSessionSummaryView({
    super.key,
    required this.sessionId,
  });

  void _retry(BuildContext context) {
    context
        .read<GetActiveHandoverSessionSummaryCubit>()
        .getActiveHandoverSessionSummary(sessionId: sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetActiveHandoverSessionSummaryCubit,
      GetActiveHandoverSessionSummaryState
    >(
      builder: (context, state) {
        if (state is GetActiveHandoverSessionSummaryInit) {
          return const SizedBox.shrink();
        } else if (state is GetActiveHandoverSessionSummaryLoading) {
          return const AppLoadingWidget();
        } else if (state is GetActiveHandoverSessionSummaryFailure) {
          return AppFailureWidget(
            failure: state.failure,
            onRetry: () => _retry(context),
          );
        } else if (state is GetActiveHandoverSessionSummarySuccess) {
          final summary = state.response;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.sessionResults,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: context.customColor.text2,
                            width: 6.r,
                          ),
                          color: context.customColor.reversedTextColor,
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          children: [
                            _buildRow(
                              context: context,
                              label: context.tr.date,
                              value:
                                  DateFormatter.formatDateMDY(
                                    DateTime.tryParse(summary.date),
                                  ) ??
                                  '-',
                              icon: AppSvg(
                                assetName: AppAssets.calendar,
                                width: 15.w,
                                colorFilter: ColorFilter.mode(
                                  context.customColor.text3,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.duration,
                              value: summary.duration,
                              icon: AppSvg(
                                assetName: AppAssets.clockSvg,
                                width: 15.w,
                                colorFilter: ColorFilter.mode(
                                  context.customColor.text3,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.assets,
                              value: summary.assetsCount.toString(),
                              icon: AppSvg(
                                assetName: AppAssets.fixedAssets,
                                width: 15.w,
                                colorFilter: ColorFilter.mode(
                                  context.customColor.text3,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.value,
                              value: summary.value.toString(),
                              showCurrency: true,
                              icon: AppSvg(
                                assetName: AppAssets.cash,
                                width: 15.w,
                                colorFilter: ColorFilter.mode(
                                  context.customColor.text3,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.accepted,
                              value:
                                  '${summary.acceptedCount} (${summary.acceptedPercentage}%)',
                              icon: AppSvg(
                                assetName: AppAssets.check,
                                width: 15.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.lightGreen,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.notes,
                              value: summary.noteCount.toString(),
                              icon: AppSvg(
                                assetName: AppAssets.warning,
                                width: 15.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.yellow,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.rejected,
                              value: summary.rejectedCount.toString(),
                              icon: Icon(
                                Icons.close,
                                size: 15.r,
                                color: context.customColor.error,
                              ),
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.photosTaken,
                              value: summary.photoTakenCount.toString(),
                              icon: Icon(
                                Icons.camera_alt,
                                size: 15.r,
                                color: context.theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        context.tr.recordedDiscrepancies,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.text2,
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: summary.recordedDiscrepancies.length,
                          itemBuilder: (context, index) {
                            final discrepancy =
                                summary.recordedDiscrepancies[index];

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: context.customColor.reversedTextColor,
                              ),
                              padding: EdgeInsets.all(12.r),
                              margin: EdgeInsets.only(
                                bottom:
                                    index ==
                                        summary.recordedDiscrepancies.length - 1
                                    ? 0
                                    : 8.r,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: AppNetworkImage(
                                          image: discrepancy.assetImageUrl,
                                          height: 100.r,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              discrepancy.assetName,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                            5.verticalSpace,
                                            Text(
                                              discrepancy.assetCode,
                                              style: AppStyles.s13W400.copyWith(
                                                color:
                                                    context.customColor.text3,
                                              ),
                                            ),
                                            5.verticalSpace,
                                            Text(
                                              discrepancy.zoneName,
                                              style: AppStyles.s13W400.copyWith(
                                                color:
                                                    context.customColor.text3,
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
                                  ButtonTextIcon(
                                    onTap: () {},
                                    label: context.tr.viewAttachedDiscrepancy,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 15.r,
                                      color: context.customColor.text4,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.r,
                                      vertical: 8.r,
                                    ),
                                    reversed: true,
                                    backgroundColor: context.customColor.text2,
                                    textColor: context.customColor.text4,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      10.verticalSpace,
                      Text(
                        context.tr.digitalSignatures,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.text2,
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: context.customColor.reversedTextColor,
                              ),
                              padding: EdgeInsets.all(8.r),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileImageWidget(width: 40.r, height: 40.r),
                                  10.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${summary.sender.name} (${context.tr.handover})',
                                                style: AppStyles.s15W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Flexible(
                                              child: Text(
                                                DateFormatter.formatTimeHM(
                                                      DateTime.tryParse(
                                                        summary.senderSignedAt,
                                                      ),
                                                    ) ??
                                                    '-',
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text4,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.verticalSpace,
                                        Text(
                                          context
                                              .tr
                                              .iConfirmHandoverWithNotedDiscrepancies,
                                          style: AppStyles.s13W400.copyWith(
                                            color: const Color(0xFF046B6B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: context.customColor.reversedTextColor,
                              ),
                              padding: EdgeInsets.all(8.r),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileImageWidget(width: 40.r, height: 40.r),
                                  10.horizontalSpace,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${summary.receiver.name} (${context.tr.recipient})',
                                                style: AppStyles.s15W500
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text1,
                                                    ),
                                              ),
                                            ),
                                            10.horizontalSpace,
                                            Flexible(
                                              child: Text(
                                                DateFormatter.formatTimeHM(
                                                      DateTime.tryParse(
                                                        summary
                                                            .receiverSignedAt,
                                                      ),
                                                    ) ??
                                                    '-',
                                                style: AppStyles.s12W400
                                                    .copyWith(
                                                      color: context
                                                          .customColor
                                                          .text4,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.verticalSpace,
                                        Text(
                                          context
                                              .tr
                                              .receivedAssetsWithRequiredDocumentation,
                                          style: AppStyles.s13W400.copyWith(
                                            color: const Color(0xFF046B6B),
                                          ),
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
                      10.verticalSpace,
                      Text(
                        context.tr.automaticDispatch,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: context.customColor.text2,
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Column(
                          children: [
                            _buildRow(
                              context: context,
                              label: context.tr.owner,
                              value: context.tr.fullReport,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.brandManager,
                              value: context.tr.executiveSummary,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.finance,
                              value: context.tr.assetValueUpdate,
                            ),
                            10.verticalSpace,
                            const CustomDivider(),
                            10.verticalSpace,
                            _buildRow(
                              context: context,
                              label: context.tr.message,
                              value: context.tr
                                  .handoverCompleteWithRecordedDiscrepancies(
                                    summary.rejectedCount,
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
                spacing: 12.w,
                children: [
                  Expanded(
                    child: CustomTextButton(
                      text: context.tr.back,
                      onTap: () {
                        context.read<PagingCubit>().previousStep();
                      },
                      borderRadius: 1000.r,
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      textColor: context.customColor.text1,
                    ),
                  ),
                  Expanded(
                    child:
                        BlocListener<
                          CompleteHandoverSessionCubit,
                          CompleteHandoverSessionState
                        >(
                          listener: (context, state) {
                            if (state is CompleteHandoverSessionSuccess) {
                              NavigationService.I.pop();

                              AppBottomSheet.customPageRoute(
                                context,
                                (context) =>
                                    const FixedAssetsHandoverSuccessScreen(),
                              );
                            } else if (state
                                is CompleteHandoverSessionFailure) {
                              AppDialog.showErrorDialog(
                                context: context,
                                failure: state.failure,
                              );
                            }
                          },
                          child:
                              BlocBuilder<
                                CompleteHandoverSessionCubit,
                                CompleteHandoverSessionState
                              >(
                                builder: (context, state) {
                                  if (state is CompleteHandoverSessionLoading) {
                                    return const AppButtonLoading();
                                  }

                                  return CustomTextButton(
                                    text: context.tr.completeHandover,
                                    onTap: () {
                                      context
                                          .read<CompleteHandoverSessionCubit>()
                                          .completeHandoverSession(
                                            sessionId: summary.sessionId,
                                          );
                                    },
                                    borderRadius: 1000.r,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.r,
                                    ),
                                    textColor:
                                        context.customColor.reversedTextColor,
                                    backgroundColor: context.theme.primaryColor,
                                  );
                                },
                              ),
                        ),
                  ),
                ],
              ),
            ],
          );
        }

        return AppLocalFailure(onRetry: () => _retry(context));
      },
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String label,
    required String value,
    Widget? icon,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              ?icon,
              if (icon != null) 5.horizontalSpace,
              Flexible(
                child: Text(
                  label,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCurrency) const SaudiRiyalSvgWidget(),
              2.horizontalSpace,
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
