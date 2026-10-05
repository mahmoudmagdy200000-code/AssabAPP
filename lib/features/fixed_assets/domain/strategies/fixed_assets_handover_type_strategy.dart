import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_bottom_sheet.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/button_text_icon.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../presentation/cubit/confirm_active_handover_signature/confirm_active_handover_signature_cubit.dart';
import '../../presentation/cubit/confirm_active_handover_signature/confirm_active_handover_signature_state.dart';
import '../../presentation/cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart';
import '../../presentation/screens/fixed_assets_handover_sender_sing_success_screen.dart';
import '../enums/fixed_assets_handover_type_enum.dart';
import 'fixed_assets_handover_strategy.dart';

abstract class FixedAssetsHandoverTypeStrategy {
  static FixedAssetsHandoverTypeStrategy getStrategy(
    FixedAssetsHandoverTypeEnum type,
  ) {
    switch (type) {
      case FixedAssetsHandoverTypeEnum.sender:
        return SenderHandoverTypeStrategy();
      case FixedAssetsHandoverTypeEnum.receiver:
        return ReceiverHandoverTypeStrategy();
    }
  }

  FixedAssetsHandoverTypeEnum get type;

  Widget buildButtonDetailsWidget(
    BuildContext context, {
    required FixedAssetsHandoverStrategy status,
    required String handoverId,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildButtonPendingApprovalStatusHandoverWidget(
    BuildContext context, {
    required String handoverId,
  }) {
    return ButtonTextIcon(
      onTap: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsHandoverDetailsScreen,
          arguments: handoverId,
        );
      },
      label: context.tr.handoverDetailsAndQrCode,
      reversed: true,
      spaceBetweenTextAndIcon: 7,
      backgroundColor: context.customColor.reversedTextColor,
      borderRadius: BorderRadius.circular(1000.r),
      icon: AppSvg(
        assetName: AppAssets.arrowRight,
        colorFilter: ColorFilter.mode(
          context.customColor.text1,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget buildButtonPendingStatusHandoverWidget(
    BuildContext context, {
    required String handoverId,
  }) {
    return const SizedBox.shrink();
  }

  Widget buildButtonCompletedStatusHandoverWidget(
    BuildContext context, {
    required String handoverId,
  }) {
    return ButtonTextIcon(
      onTap: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsHandoverDetailsScreen,
          arguments: handoverId,
        );
      },
      label: context.tr.trackHandoverDetails,
      reversed: true,
      spaceBetweenTextAndIcon: 7,
      backgroundColor: context.customColor.reversedTextColor,
      borderRadius: BorderRadius.circular(1000.r),
      icon: AppSvg(
        assetName: AppAssets.arrowRight,
        colorFilter: ColorFilter.mode(
          context.customColor.text1,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class SenderHandoverTypeStrategy extends FixedAssetsHandoverTypeStrategy {
  @override
  FixedAssetsHandoverTypeEnum get type => FixedAssetsHandoverTypeEnum.sender;

  @override
  Widget buildButtonDetailsWidget(
    BuildContext context, {
    required FixedAssetsHandoverStrategy status,
    required String handoverId,
  }) {
    return status.buildButtonDetails(context, handoverId: handoverId);
  }

  @override
  Widget buildButtonPendingStatusHandoverWidget(
    BuildContext context, {
    required String handoverId,
  }) {
    return Row(
      spacing: 10.w,
      children: [
        Expanded(
          child: CustomTextButton(
            onTap: () {
              NavigationService.I.pushNamed(
                AppRouteName.fixedAssetsHandoverDetailsScreen,
                arguments: handoverId,
              );
            },
            text: context.tr.handoveDetails,
            backgroundColor: context.customColor.reversedTextColor,
            borderRadius: 1000.r,
            textColor: context.customColor.text1,
            padding: EdgeInsets.symmetric(vertical: 18.r, horizontal: 19.r),
          ),
        ),
        Expanded(
          child: BlocProvider(
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

                          return ButtonTextIcon(
                            onTap: () {
                              context
                                  .read<ConfirmActiveHandoverSignatureCubit>()
                                  .confirmActiveHandoverSessionSignatureSender(
                                    sessionId: handoverId,
                                  );
                            },
                            label: context.tr.signNow,
                            reversed: true,
                            spaceBetweenTextAndIcon: 7,
                            backgroundColor: context.theme.primaryColor,
                            borderRadius: BorderRadius.circular(1000.r),
                            textColor: context.customColor.reversedTextColor,
                            borderColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              vertical: 18.r,
                              horizontal: 19.r,
                            ),
                            icon: AppSvg(
                              assetName: AppAssets.arrowRight,
                              colorFilter: ColorFilter.mode(
                                context.customColor.reversedTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          );
                        },
                      ),
                ),
          ),
        ),
      ],
    );
  }
}

class ReceiverHandoverTypeStrategy extends FixedAssetsHandoverTypeStrategy {
  @override
  FixedAssetsHandoverTypeEnum get type => FixedAssetsHandoverTypeEnum.receiver;

  @override
  Widget buildButtonPendingStatusHandoverWidget(
    BuildContext context, {
    required String handoverId,
  }) {
    return ButtonTextIcon(
      onTap: () {
        NavigationService.I.pushNamed(
          AppRouteName.fixedAssetsHandoverDetailsScreen,
          arguments: handoverId,
        );
      },
      label: context.tr.trackHandoverDetails,
      reversed: true,
      spaceBetweenTextAndIcon: 7,
      backgroundColor: context.customColor.reversedTextColor,
      borderRadius: BorderRadius.circular(1000.r),
      icon: AppSvg(
        assetName: AppAssets.arrowRight,
        colorFilter: ColorFilter.mode(
          context.customColor.text1,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
