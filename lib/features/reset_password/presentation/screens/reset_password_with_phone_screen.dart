import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/styles/app_styles.dart';
import 'package:assab/core/utils/app_reg_exp.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/core/widgets/app_text_form_field.dart';
import 'package:assab/features/reset_password/data/models/verify_otp_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/auth_type.dart';
import '../../../../core/enums/text_form_type.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../data/models/send_otp_request_model.dart';
import '../cubits/send_otp/send_otp_cubit.dart';
import '../widgets/reset_password_bottom_section.dart';
import '../widgets/reset_password_top_section.dart';

class ResetPasswordWithPhoneScreen extends StatefulWidget {
  const ResetPasswordWithPhoneScreen({super.key});

  @override
  State<ResetPasswordWithPhoneScreen> createState() =>
      _ResetPasswordWithPhoneScreenState();
}

class _ResetPasswordWithPhoneScreenState
    extends State<ResetPasswordWithPhoneScreen> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhone(String value) {
    context.read<ValidationCubit>().validateField(
      'phone',
      AppRegExp.phoneValidator(value),
    );
  }

  void _goToResetWithEmail() {
    NavigationService.I.replaceWithNamed(
      AppRouteName.resetPasswordWithPhoneScreen,
    );
  }

  void _sendOtp() {
    context.read<SendOtpCubit>().branchManagerSendOtp(
      request: SendOtpRequestModel(
        identifier: '+966${_phoneController.text}',
        type: AuthType.phone.value,
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
                selector: (state) => state.fieldsValidity['phone'],
                builder: (context, state) {
                  return AppTextFormField(
                    controller: _phoneController,
                    label: context.tr.registeredPhone,
                    hint: context.tr.hintPhone,
                    textFormType: TextFormType.phone,
                    onChanged: _validatePhone,
                    error: context.read<ValidationCubit>().errorMsg(
                      state,
                      context.tr.phoneNotValid,
                    ),
                  );
                },
              ),
              10.verticalSpace,
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: AppGestureDetectorButton(
                  onTap: _goToResetWithEmail,
                  child: Text(
                    context.tr.resetWithEmail,
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
                  type: AuthType.phone,
                  identifier: '+966${_phoneController.text}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
