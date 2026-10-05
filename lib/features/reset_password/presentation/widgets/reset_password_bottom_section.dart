import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../data/models/verify_otp_arguments.dart';
import '../cubits/send_otp/send_otp_cubit.dart';
import '../cubits/send_otp/send_otp_state.dart';

class ResetPasswordBottomSection extends StatelessWidget {
  final VoidCallback onClickRequestOtp;
  final VerifyOtpArguments Function() verifyOtpArgumentsBuilder;

  const ResetPasswordBottomSection({
    super.key,
    required this.onClickRequestOtp,
    required this.verifyOtpArgumentsBuilder,
  });

  void _whenSuccessSendOtp(SendOtpState state) {
    NavigationService.I.replaceWithNamed(
      AppRouteName.verifyResetPasswordScreen,
      arguments: verifyOtpArgumentsBuilder(),
    );
  }

  void _sendOtpListener(BuildContext context, SendOtpState state) {
    if (state is SendOtpSuccess) {
      _whenSuccessSendOtp(state);
    } else if (state is SendOtpFailure) {
      AppDialog.showErrorDialog(context: context, failure: state.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, validationState) {
            return BlocConsumer<SendOtpCubit, SendOtpState>(
              listener: _sendOtpListener,
              builder: (context, state) {
                if (state is SendOtpLoading) {
                  return const AppButtonLoading();
                }

                return AppButton(
                  onClick: onClickRequestOtp,
                  enabled: validationState.enableButton,
                  text: context.tr.requestOTP,
                );
              },
            );
          },
        ),
        // 10.verticalSpace,
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       context.tr.lastReset,
        //       style: AppStyles.s11W400.copyWith(
        //         color: context.customColor.text3,
        //       ),
        //     ),
        //     6.horizontalSpace,
        //     Text(
        //       '12 days ago',
        //       style: AppStyles.s11W500.copyWith(
        //         color: context.customColor.text6,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
