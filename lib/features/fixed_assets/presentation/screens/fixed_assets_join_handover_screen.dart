import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/widgets/app_back_button.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_check_box.dart';
import 'package:assab/core/widgets/app_failure_widget.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:assab/core/widgets/app_local_failure.dart';
import 'package:assab/core/widgets/app_network_image.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/button_text_icon.dart';
import 'package:assab/core/widgets/container_custom_text_field.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/label_text_field.dart';
import 'package:assab/core/widgets/saudi_riyal_svg_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/fixed_assets_join_handover_session_details_response.dart';
import '../cubit/fixd_assets_join_handover/fixd_assets_join_handover_cubit.dart';
import '../cubit/fixd_assets_join_handover/fixd_assets_join_handover_state.dart';
import '../cubit/get_join_handover_session_details/get_join_handover_session_details_cubit.dart';
import '../cubit/get_join_handover_session_details/get_join_handover_session_details_state.dart';
import '../widgets/fixed_assets_detailed_list_zones_handover_bottom_sheet_widget.dart';

class FixedAssetsJoinHandoverScreen extends StatelessWidget {
  final String sessionId;

  const FixedAssetsJoinHandoverScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final validationCubit = context.read<ValidationCubit>();

    return Scaffold(
      body: Column(
        children: [
          AppPaddingWidget(
            top: 30.r,
            child: Row(
              children: [
                const AppBackButton(),
                10.verticalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr.joinHandoverSession,
                        style: AppStyles.s16W500.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                      Text(
                        context.tr.joinHandoverSessionDesc,
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
              color: context.customColor.text2,
              child: Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                margin: EdgeInsets.only(top: 20.r),
                padding: EdgeInsets.all(16.r),
                child:
                    BlocBuilder<
                      GetJoinHandoverSessionDetailsCubit,
                      GetJoinHandoverSessionDetailsState
                    >(
                      builder: (context, state) {
                        if (state is GetJoinHandoverSessionDetailsLoading) {
                          return const AppLoadingWidget();
                        } else if (state
                            is GetJoinHandoverSessionDetailsFailure) {
                          return AppFailureWidget(
                            failure: state.failure,
                            onRetry: () {
                              context
                                  .read<GetJoinHandoverSessionDetailsCubit>()
                                  .getJoinHandoverSessionDetails(
                                    sessionId: sessionId,
                                  );
                            },
                          );
                        } else if (state
                            is GetJoinHandoverSessionDetailsSuccess) {
                          return _buildSessionDetails(
                            context,
                            response: state.response,
                            validationCubit: validationCubit,
                          );
                        }

                        return AppLocalFailure(
                          onRetry: () {
                            context
                                .read<GetJoinHandoverSessionDetailsCubit>()
                                .getJoinHandoverSessionDetails(
                                  sessionId: sessionId,
                                );
                          },
                        );
                      },
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetails(
    BuildContext context, {
    required FixedAssetsJoinHandoverSessionDetailsResponse response,
    required ValidationCubit validationCubit,
  }) {
    final formattedDate =
        DateFormatter.formatDateMDY(response.sessionDate) ?? '-';
    final zonesAndAssets =
        '${response.totalZones} ${context.tr.zones} | ${response.totalAssets} ${context.tr.assets}';

    return Column(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppNetworkImage(
                    image: response.sessionImageUrl,
                    width: 60.r,
                    height: 60.r,
                    borderRadius: BorderRadius.zero,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${context.tr.sessionCode}:',
                          style: AppStyles.s13W400.copyWith(
                            color: context.customColor.text3,
                          ),
                        ),
                        Text(
                          response.sessionCode,
                          style: AppStyles.s16W500.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Text(
                context.tr.sessionInfo,
                style: AppStyles.s12W400.copyWith(
                  color: context.customColor.text3,
                ),
              ),
              5.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: context.customColor.reversedTextColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: context.customColor.text2,
                    width: 10.r,
                  ),
                ),
                padding: EdgeInsets.all(10.r),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppNetworkImage(
                          image: response.handoverByImageUrl,
                          width: 40.r,
                          height: 40.r,
                          borderRadius: BorderRadius.circular(1000.r),
                        ),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${context.tr.handoverBy}: ${response.handoverByName}',
                                style: AppStyles.s14W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              Text(
                                response.branchName,
                                style: AppStyles.s12W400.copyWith(
                                  color: context.customColor.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    const CustomDivider(),
                    5.verticalSpace,
                    _buildRow(
                      context,
                      title: context.tr.date,
                      value: formattedDate,
                    ),
                    5.verticalSpace,
                    _buildRow(
                      context,
                      title: context.tr.zonesAndAssets,
                      value: zonesAndAssets,
                    ),
                    5.verticalSpace,
                    _buildRow(
                      context,
                      title: context.tr.value,
                      value: response.totalValue.toStringAsFixed(0),
                      showCurrency: true,
                    ),
                    5.verticalSpace,
                    ContainerCustomTextField(
                      width: double.infinity,
                      child: Text(
                        response.note,
                        style: AppStyles.s12W400.copyWith(
                          color: context.customColor.text1,
                        ),
                      ),
                    ),
                    5.verticalSpace,
                    const CustomDivider(),
                    5.verticalSpace,
                    ButtonTextIcon(
                      onTap: () {
                        AppBottomSheet.show(
                          context,
                          (context) =>
                              FixedAssetsDetailedListZonesHandoverBottomSheetWidget(
                                includedZones: response.includedZones,
                              ),
                        );
                      },
                      label: context.tr.assetListForReview,
                      reversed: true,
                      spaceBetweenTextAndIcon: 7,
                      borderColor: context.theme.primaryColor,
                      textColor: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(1000.r),
                      padding: EdgeInsets.symmetric(vertical: 14.r),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: context.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              LabelTextField(text: context.tr.recipientConfirmations),
              5.verticalSpace,
              BlocBuilder<ValidationCubit, ValidationState>(
                builder: (context, validationState) {
                  final policyConfirmed =
                      validationState.fieldsValidity['confirmTransferPolicy'] ==
                      true;

                  return Row(
                    children: [
                      AppCheckBox(
                        onChanged: (value) {
                          validationCubit.validateField(
                            'confirmTransferPolicy',
                            value == true,
                          );
                        },
                        value: policyConfirmed,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.iAcknowledgeTransferPolicy,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              10.verticalSpace,
              BlocBuilder<ValidationCubit, ValidationState>(
                builder: (context, validationState) {
                  final reviewedAssets =
                      validationState
                          .fieldsValidity['confirmReviewedAssetList'] ==
                      true;

                  return Row(
                    children: [
                      AppCheckBox(
                        onChanged: (value) {
                          validationCubit.validateField(
                            'confirmReviewedAssetList',
                            value == true,
                          );
                        },
                        value: reviewedAssets,
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: Text(
                          context.tr.iReviewedAssetList,
                          style: AppStyles.s12W400.copyWith(
                            color: context.customColor.text1,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        20.verticalSpace,
        BlocListener<FixdAssetsJoinHandoverCubit, FixdAssetsJoinHandoverState>(
          listener: (context, state) {
            if (state is FixdAssetsJoinHandoverSuccess) {
              NavigationService.I.pop();

              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsActiveHandoverSessionScreen,
                arguments: response.sessionId.toString(),
              );
            } else if (state is FixdAssetsJoinHandoverFailure) {
              AppDialog.showErrorDialog(
                context: context,
                failure: state.failure,
              );
            }
          },
          child:
              BlocBuilder<
                FixdAssetsJoinHandoverCubit,
                FixdAssetsJoinHandoverState
              >(
                builder: (context, state) {
                  if (state is FixdAssetsJoinHandoverLoading) {
                    return const AppButtonLoading();
                  }

                  return BlocSelector<ValidationCubit, ValidationState, bool>(
                    selector: (validationState) {
                      final policyConfirmed =
                          validationState
                              .fieldsValidity['confirmTransferPolicy'] ==
                          true;
                      final reviewedAssets =
                          validationState
                              .fieldsValidity['confirmReviewedAssetList'] ==
                          true;

                      return policyConfirmed && reviewedAssets;
                    },
                    builder: (context, enableButton) {
                      return AppButton(
                        onClick: () {
                          if (!enableButton) {
                            return;
                          }

                          context
                              .read<FixdAssetsJoinHandoverCubit>()
                              .joinHandoverSession(
                                sessionId: response.sessionId,
                              );
                        },
                        text: context.tr.joinSession,
                        enabled: enableButton,
                      );
                    },
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String title,
    required String value,
    bool showCurrency = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: AppStyles.s14W400.copyWith(color: context.customColor.text3),
          ),
        ),
        5.horizontalSpace,
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
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
