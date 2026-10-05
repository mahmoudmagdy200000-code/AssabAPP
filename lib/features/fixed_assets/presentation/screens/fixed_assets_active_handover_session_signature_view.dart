import 'package:assab/core/constants/app_assets.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_colors.dart';
import 'package:assab/core/widgets/app_asset_image.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/features/fixed_assets/presentation/cubit/get_active_handover_session_signature/get_active_handover_session_signature_state.dart';
import 'package:assab/features/purchase/presentation/widgets/purchase_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/paging_cubit/paging_cubit.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_cubit.dart';
import '../cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_state.dart';
import '../cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart';
import '../cubit/get_active_handover_session_summary/get_active_handover_session_summary_cubit.dart';

class FixedAssetsActiveHandoverSessionSignatureView extends StatefulWidget {
  final String sessionId;

  const FixedAssetsActiveHandoverSessionSignatureView({
    super.key,
    required this.sessionId,
  });

  @override
  State<FixedAssetsActiveHandoverSessionSignatureView> createState() =>
      _FixedAssetsActiveHandoverSessionSignatureViewState();
}

class _FixedAssetsActiveHandoverSessionSignatureViewState
    extends State<FixedAssetsActiveHandoverSessionSignatureView> {
  late final FixedAssetsHandoverSessionRealtimeCubit _realtimeCubit;

  @override
  void initState() {
    super.initState();
    _realtimeCubit = context.read<FixedAssetsHandoverSessionRealtimeCubit>();
    _realtimeCubit.subscribe(sessionId: widget.sessionId);
  }

  void _onRetry(BuildContext context) {
    context
        .read<GetActiveHandoverSessionSignatureCubit>()
        .getActiveHandoverSessionSignature(sessionId: widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      FixedAssetsHandoverSessionRealtimeCubit,
      FixedAssetsHandoverSessionRealtimeState
    >(
      listenWhen: (previous, current) =>
          current is! FixedAssetsHandoverSessionRealtimeIdle,
      listener: (context, state) {
        if (state is FixedAssetsHandoverSessionRealtimeSenderSigned) {
          context
              .read<GetActiveHandoverSessionSignatureCubit>()
              .getActiveHandoverSessionSignature(
                sessionId: widget.sessionId,
                loading: false,
              );
        }
      },
      child:
          BlocBuilder<
            GetActiveHandoverSessionSignatureCubit,
            GetActiveHandoverSessionSignatureState
          >(
            builder: (context, state) {
              if (state is GetActiveHandoverSessionSignatureInit) {
                return const SizedBox.shrink();
              } else if (state is GetActiveHandoverSessionSignatureLoading) {
                return const AppLoadingWidget();
              } else if (state is GetActiveHandoverSessionSignatureFailure) {
                return AppFailureWidget(
                  failure: state.failure,
                  onRetry: () => _onRetry(context),
                );
              } else if (state is GetActiveHandoverSessionSignatureSuccess) {
                final response = state.response;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr.progressMap,
                              style: AppStyles.s16W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            5.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 8.r,
                                          crossAxisSpacing: 8.r,
                                          childAspectRatio: 3.5,
                                        ),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: response.progressItems.length,
                                    itemBuilder: (context, index) {
                                      final item =
                                          response.progressItems[index];

                                      return _buildProgressItem(
                                        context,
                                        label:
                                            index ==
                                                response.progressItems.length -
                                                    1
                                            ? context.tr.total
                                            : item.label,
                                        percent: item.percent,
                                      );
                                    },
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: '${context.tr.time}: ',
                                          style: AppStyles.s14W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: response.timeSpent,
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.theme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      RichText(
                                        text: TextSpan(
                                          text: '${context.tr.remaining}: ',
                                          style: AppStyles.s14W400.copyWith(
                                            color: context.customColor.text3,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  '(${response.remainingPercent}%)',
                                              style: AppStyles.s14W500.copyWith(
                                                color:
                                                    context.customColor.text1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              context.tr.partyConfirmations,
                              style: AppStyles.s16W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            15.verticalSpace,
                            AppAssetImage(
                              image: AppAssets.handoverSignature,
                              height: 120.h,
                              borderRadius: BorderRadius.zero,
                            ),
                            15.verticalSpace,
                            Text(
                              context.tr.handoverConfirmationDesc,
                              style: AppStyles.s14W400.copyWith(
                                color: context.customColor.text3,
                              ),
                            ),
                            20.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: context.customColor.border,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.r,
                                vertical: 8.r,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      AppCheckBox(
                                        onChanged: (value) {},
                                        value: response.sender.isSigned,
                                        selectedColor: AppColors.lightGreen,
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          '${response.sender.name} (${context.tr.handover})',
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      PurchaseStatusWidget(
                                        statusText: response.sender.isSigned
                                            ? context.tr.signed
                                            : context.tr.pending,
                                        textColor: response.sender.isSigned
                                            ? AppColors.lightGreen
                                            : AppColors.orange,
                                        backgroundColor: Colors.transparent,
                                        borderColor: context.customColor.border,
                                      ),
                                    ],
                                  ),
                                  10.verticalSpace,
                                  const CustomDivider(),
                                  10.verticalSpace,
                                  Row(
                                    children: [
                                      AppCheckBox(
                                        onChanged: (value) {},
                                        value: response.receiver.isSigned,
                                        selectedColor: AppColors.lightGreen,
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: Text(
                                          '${response.receiver.name} (${context.tr.recipient})',
                                          style: AppStyles.s13W400.copyWith(
                                            color: context.customColor.text4,
                                          ),
                                        ),
                                      ),
                                      5.horizontalSpace,
                                      PurchaseStatusWidget(
                                        statusText: response.receiver.isSigned
                                            ? context.tr.signed
                                            : context.tr.pending,
                                        textColor: response.receiver.isSigned
                                            ? AppColors.lightGreen
                                            : AppColors.orange,
                                        backgroundColor: Colors.transparent,
                                        borderColor: context.customColor.border,
                                      ),
                                    ],
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
                          child: AppButton(
                            text: context.tr.handoverSummary,
                            onClick: () {
                              context.read<PagingCubit>().nextStep();

                              context
                                  .read<GetActiveHandoverSessionSummaryCubit>()
                                  .getActiveHandoverSessionSummary(
                                    sessionId: widget.sessionId,
                                  );
                            },
                            padding: EdgeInsets.symmetric(vertical: 14.r),
                            enabled:
                                response.receiver.isSigned &&
                                response.sender.isSigned,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return AppLocalFailure(onRetry: () => _onRetry(context));
            },
          ),
    );
  }

  Widget _buildProgressItem(
    BuildContext context, {
    required String label,
    required int percent,
  }) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
        children: [
          TextSpan(
            text: '($percent%)',
            style: AppStyles.s14W500.copyWith(color: context.customColor.text1),
          ),
        ],
      ),
    );
  }
}
