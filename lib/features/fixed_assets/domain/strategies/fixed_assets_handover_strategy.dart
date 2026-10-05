import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/fixed_assets/presentation/cubit/confirm_active_handover_signature/confirm_active_handover_signature_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../purchase/presentation/widgets/purchase_status_widget.dart';
import '../../presentation/cubit/confirm_active_handover_signature/confirm_active_handover_signature_cubit.dart';
import '../../presentation/cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart';
import '../../presentation/screens/fixed_assets_handover_sender_sing_success_screen.dart';
import '../enums/fixed_assets_handover_enum.dart';
import 'fixed_assets_handover_type_strategy.dart';

abstract class FixedAssetsHandoverStrategy {
  static FixedAssetsHandoverStrategy getStrategy(
    FixedAssetsHandoverEnum status,
  ) {
    switch (status) {
      case FixedAssetsHandoverEnum.pendingApproval:
        return PendingApprovalHandoverStrategy();
      case FixedAssetsHandoverEnum.pending:
        return PendingHandoverStrategy();
      case FixedAssetsHandoverEnum.completed:
        return CompletedHandoverStrategy();
    }
  }

  FixedAssetsHandoverEnum get status;

  Widget buildRequestStatusWidget(BuildContext context);

  Widget buildStatusWidget(
    BuildContext context, {
    required String handoverId,
    required String recipientName,
    required FixedAssetsHandoverTypeStrategy type,
  });

  Widget buildStatusDetailsWidget(
    BuildContext context, {
    required String recipientName,
  });

  Widget buildButtonDetails(
    BuildContext context, {
    required String handoverId,
  }) {
    return const SizedBox.shrink();
  }
}

class PendingApprovalHandoverStrategy extends FixedAssetsHandoverStrategy {
  @override
  FixedAssetsHandoverEnum get status => FixedAssetsHandoverEnum.pendingApproval;

  @override
  Widget buildRequestStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.pendingApproval,
      textColor: AppColors.orange,
      backgroundColor: AppColors.orange.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildStatusWidget(
    BuildContext context, {
    required String handoverId,
    required String recipientName,
    required FixedAssetsHandoverTypeStrategy type,
  }) {
    return Container(
      width: double.infinity,
      color: context.customColor.text2,
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: context.tr.pendingApproval,
            backgroundColor: context.customColor.reversedTextColor,
            textColor: AppColors.orange,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverInitiated,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverRequestSent(recipientName),
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          const AppAssetImage(
            image: AppAssets.pendingApprovalFixedAssets,
            borderRadius: BorderRadius.zero,
          ),
          10.verticalSpace,
          type.buildButtonPendingApprovalStatusHandoverWidget(
            context,
            handoverId: handoverId,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusDetailsWidget(
    BuildContext context, {
    required String recipientName,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.customColor.text2,
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: context.tr.pendingApproval,
            backgroundColor: context.customColor.reversedTextColor,
            textColor: AppColors.orange,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverInitiated,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverRequestSent(recipientName),
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PendingHandoverStrategy extends FixedAssetsHandoverStrategy {
  @override
  FixedAssetsHandoverEnum get status => FixedAssetsHandoverEnum.pending;

  @override
  Widget buildRequestStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.pending,
      textColor: context.theme.primaryColor,
      backgroundColor: context.theme.primaryColor.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildStatusWidget(
    BuildContext context, {
    required String handoverId,
    required String recipientName,
    required FixedAssetsHandoverTypeStrategy type,
  }) {
    return Container(
      width: double.infinity,
      color: context.customColor.text2,
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: context.tr.pending,
            backgroundColor: context.customColor.reversedTextColor,
            textColor: context.theme.primaryColor,
          ),
          5.verticalSpace,
          Text(
            context.tr.signaturePending,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.recipientSignedHandover(recipientName),
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          const AppAssetImage(
            image: AppAssets.pendingFixedAssets,
            borderRadius: BorderRadius.zero,
          ),
          10.verticalSpace,
          type.buildButtonPendingStatusHandoverWidget(
            context,
            handoverId: handoverId,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusDetailsWidget(
    BuildContext context, {
    required String recipientName,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: context.tr.pending,
            backgroundColor: context.customColor.reversedTextColor,
            textColor: context.theme.primaryColor,
          ),
          5.verticalSpace,
          Text(
            context.tr.signaturePending,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.recipientSignedHandover(recipientName),
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildButtonDetails(
    BuildContext context, {
    required String handoverId,
  }) {
    return Column(
      children: [
        20.verticalSpace,
        BlocProvider(
          create: (context) => getIt<ConfirmActiveHandoverSignatureCubit>(),
          child:
              BlocListener<
                ConfirmActiveHandoverSignatureCubit,
                ConfirmActiveHandoverSignatureState
              >(
                listener: (context, state) {
                  if (state is ConfirmActiveHandoverSignatureSuccess) {
                    AppBottomSheet.customPageRoute(
                      context,
                      (context) => BlocProvider(
                        create: (context) =>
                            getIt<GetActiveHandoverSessionSignatureCubit>()
                              ..getActiveHandoverSessionSignature(
                                sessionId: handoverId,
                              ),
                        child: FixedAssetsHandoverSenderSingSuccessScreen(
                          sessionId: handoverId,
                        ),
                      ),
                    );
                  } else if (state is ConfirmActiveHandoverSignatureFailure) {
                    AppDialog.showErrorDialog(
                      context: context,
                      failure: state.failure,
                    );
                  }
                },
                child:
                    BlocBuilder<
                      ConfirmActiveHandoverSignatureCubit,
                      ConfirmActiveHandoverSignatureState
                    >(
                      builder: (context, state) {
                        if (state is ConfirmActiveHandoverSignatureLoading) {
                          return const AppButtonLoading();
                        }

                        return AppButton(
                          onClick: () {
                            context
                                .read<ConfirmActiveHandoverSignatureCubit>()
                                .confirmActiveHandoverSessionSignatureSender(
                                  sessionId: handoverId,
                                );
                          },
                          text: context.tr.signNow,
                          enabled: true,
                        );
                      },
                    ),
              ),
        ),
      ],
    );
  }
}

class CompletedHandoverStrategy extends FixedAssetsHandoverStrategy {
  @override
  FixedAssetsHandoverEnum get status => FixedAssetsHandoverEnum.completed;

  @override
  Widget buildRequestStatusWidget(BuildContext context) {
    return PurchaseStatusWidget(
      statusText: context.tr.completed,
      textColor: AppColors.lightGreen,
      backgroundColor: AppColors.lightGreen.withValues(alpha: 0.1),
    );
  }

  @override
  Widget buildStatusWidget(
    BuildContext context, {
    required String handoverId,
    required String recipientName,
    required FixedAssetsHandoverTypeStrategy type,
  }) {
    return Container(
      width: double.infinity,
      color: context.customColor.text2,
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: context.tr.completed,
            backgroundColor: context.customColor.reversedTextColor,
            textColor: AppColors.lightGreen,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverCompleted,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverCompletedDesc,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          type.buildButtonCompletedStatusHandoverWidget(
            context,
            handoverId: handoverId,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStatusDetailsWidget(
    BuildContext context, {
    required String recipientName,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: context.customColor.border),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Column(
        children: [
          PurchaseStatusWidget(
            statusText: context.tr.completed,
            backgroundColor: context.customColor.reversedTextColor,
            textColor: AppColors.lightGreen,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverCompleted,
            style: AppStyles.s16W500.copyWith(color: context.customColor.text1),
            textAlign: TextAlign.center,
          ),
          5.verticalSpace,
          Text(
            context.tr.handoverCompletedDesc,
            style: AppStyles.s13W400.copyWith(color: context.customColor.text3),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
