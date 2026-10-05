import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/features/reset_password/data/models/send_otp_request_model.dart';
import 'package:assab/features/reset_password/presentation/cubits/send_otp/send_otp_cubit.dart';
import 'package:assab/features/reset_password/presentation/widgets/reset_password_bottom_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/auth_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_reg_exp.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../data/models/verify_otp_arguments.dart';
import '../widgets/reset_password_top_section.dart';

class ResetPasswordWithEmailScreen extends StatefulWidget {
  const ResetPasswordWithEmailScreen({super.key});

  @override
  State<ResetPasswordWithEmailScreen> createState() =>
      _ResetPasswordWithEmailScreenState();
}

class _ResetPasswordWithEmailScreenState
    extends State<ResetPasswordWithEmailScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    context.read<ValidationCubit>().validateField(
      'email',
      AppRegExp.emailValidator(value),
    );
  }

  void _goToResetWithPhone() {
    NavigationService.I.replaceWithNamed(
      AppRouteName.resetPasswordWithPhoneScreen,
    );
  }

  void _sendOtp() {
    context.read<SendOtpCubit>().branchManagerSendOtp(
      request: SendOtpRequestModel(
        identifier: _emailController.text,
        type: AuthType.email.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: AppPaddingWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ResetPasswordTopSection(
                title: context.tr.forgotYourPassword,
                textDesc: context.tr.forgotYourPasswordDesc,
              ),
              32.verticalSpace,
              BlocSelector<ValidationCubit, ValidationState, bool?>(
                selector: (state) => state.fieldsValidity['email'],
                builder: (context, state) {
                  return AppTextFormField(
                    controller: _emailController,
                    label: context.tr.registeredEmail,
                    hint: context.tr.hintEmail,
                    onChanged: _validateEmail,
                    error: context.read<ValidationCubit>().errorMsg(
                      state,
                      context.tr.emailNotValid,
                    ),
                  );
                },
              ),
              10.verticalSpace,
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: AppGestureDetectorButton(
                  onTap: _goToResetWithPhone,
                  child: Text(
                    context.tr.resetWithPhone,
                    style: AppStyles.s15W500.copyWith(
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
              ),
              64.verticalSpace,
              ResetPasswordBottomSection(
                onClickRequestOtp: _sendOtp,
                verifyOtpArgumentsBuilder: () => VerifyOtpArguments(
                  type: AuthType.email,
                  identifier: _emailController.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
