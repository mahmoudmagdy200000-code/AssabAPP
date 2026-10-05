import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_check_box.dart';
import '../../../../core/widgets/app_failure_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_local_failure.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../purchase/presentation/widgets/purchase_status_widget.dart';
import '../cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart';
import '../cubit/get_active_handover_session_signature/get_active_handover_session_signature_state.dart';

class FixedAssetsHandoverSenderSingSuccessScreen extends StatelessWidget {
  final String sessionId;
  const FixedAssetsHandoverSenderSingSuccessScreen({
    super.key,
    required this.sessionId,
  });

  void _onRetry(BuildContext context) {
    context
        .read<GetActiveHandoverSessionSignatureCubit>()
        .getActiveHandoverSessionSignature(sessionId: sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColor.dark,
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(isTransparent: true),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.activeHandoverSession,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.reversedTextColor,
                        ),
                      ),
                      Text(
                        context.tr.activeHandoverFromTo(
                          'response.fromEmployeeName',
                          'response.toEmployeeName',
                        ),
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.customColor.reversedTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              padding: EdgeInsets.all(16.r),
              child:
                  BlocBuilder<
                    GetActiveHandoverSessionSignatureCubit,
                    GetActiveHandoverSessionSignatureState
                  >(
                    builder: (context, state) {
                      if (state is GetActiveHandoverSessionSignatureInit) {
                        return const SizedBox.shrink();
                      } else if (state
                          is GetActiveHandoverSessionSignatureLoading) {
                        return const AppLoadingWidget();
                      } else if (state
                          is GetActiveHandoverSessionSignatureFailure) {
                        return AppFailureWidget(
                          failure: state.failure,
                          onRetry: () => _onRetry(context),
                        );
                      } else if (state
                          is GetActiveHandoverSessionSignatureSuccess) {
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
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: context.customColor.border,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.r,
                                        vertical: 8.r,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            itemCount:
                                                response.progressItems.length,
                                            itemBuilder: (context, index) {
                                              final item =
                                                  response.progressItems[index];

                                              return _buildProgressItem(
                                                context,
                                                label:
                                                    index ==
                                                        response
                                                                .progressItems
                                                                .length -
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
                                                  style: AppStyles.s14W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text3,
                                                      ),
                                                  children: [
                                                    TextSpan(
                                                      text: response.timeSpent,
                                                      style: AppStyles.s14W500
                                                          .copyWith(
                                                            color: context
                                                                .theme
                                                                .primaryColor,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              RichText(
                                                text: TextSpan(
                                                  text:
                                                      '${context.tr.remaining}: ',
                                                  style: AppStyles.s14W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text3,
                                                      ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '(${response.remainingPercent}%)',
                                                      style: AppStyles.s14W500
                                                          .copyWith(
                                                            color: context
                                                                .customColor
                                                                .text1,
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
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
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
                                                selectedColor:
                                                    AppColors.lightGreen,
                                              ),
                                              10.horizontalSpace,
                                              Expanded(
                                                child: Text(
                                                  '${response.sender.name} (${context.tr.handover})',
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              PurchaseStatusWidget(
                                                statusText:
                                                    response.sender.isSigned
                                                    ? context.tr.signed
                                                    : context.tr.pending,
                                                textColor:
                                                    response.sender.isSigned
                                                    ? AppColors.lightGreen
                                                    : AppColors.orange,
                                                backgroundColor:
                                                    Colors.transparent,
                                                borderColor:
                                                    context.customColor.border,
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
                                                value:
                                                    response.receiver.isSigned,
                                                selectedColor:
                                                    AppColors.lightGreen,
                                              ),
                                              10.horizontalSpace,
                                              Expanded(
                                                child: Text(
                                                  '${response.receiver.name} (${context.tr.recipient})',
                                                  style: AppStyles.s13W400
                                                      .copyWith(
                                                        color: context
                                                            .customColor
                                                            .text4,
                                                      ),
                                                ),
                                              ),
                                              5.horizontalSpace,
                                              PurchaseStatusWidget(
                                                statusText:
                                                    response.receiver.isSigned
                                                    ? context.tr.signed
                                                    : context.tr.pending,
                                                textColor:
                                                    response.receiver.isSigned
                                                    ? AppColors.lightGreen
                                                    : AppColors.orange,
                                                backgroundColor:
                                                    Colors.transparent,
                                                borderColor:
                                                    context.customColor.border,
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
                            CustomTextButton(
                              text: context.tr.handoverSummary,
                              onTap: () {
                                NavigationService.I.pop();
                              },
                              backgroundColor: context.theme.primaryColor,
                              borderColor: Colors.transparent,
                              borderRadius: 1000.r,
                              textColor: context.customColor.reversedTextColor,
                              padding: EdgeInsets.symmetric(vertical: 15.r),
                            ),
                          ],
                        );
                      }

                      return AppLocalFailure(onRetry: () => _onRetry(context));
                    },
                  ),
            ),
          ),
        ],
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
