import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/features/reset_password/presentation/widgets/verify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/routing/app_route_name.dart';
import '../../../../core/services/navigation/navigation_service.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_button_loading.dart';
import '../../data/models/create_new_password_arguments.dart';
import '../../data/models/send_otp_request_model.dart';
import '../../data/models/verify_otp_arguments.dart';
import '../../data/models/verify_otp_request_model.dart';
import '../bloc/verify_otp/verify_otp_bloc.dart';
import '../bloc/verify_otp/verify_otp_event.dart';
import '../bloc/verify_otp/verify_otp_state.dart';

class VerifyResetPasswordBottomSection extends StatefulWidget {
  final VerifyOtpArguments verifyOtpArguments;

  const VerifyResetPasswordBottomSection({
    super.key,
    required this.verifyOtpArguments,
  });

  @override
  State<VerifyResetPasswordBottomSection> createState() =>
      _VerifyResetPasswordBottomSectionState();
}

class _VerifyResetPasswordBottomSectionState
    extends State<VerifyResetPasswordBottomSection> {
  late final TextEditingController _n1controller;
  late final TextEditingController _n2controller;
  late final TextEditingController _n3controller;
  late final TextEditingController _n4controller;
  late final TextEditingController _n5controller;
  late final TextEditingController _n6controller;
  List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _n1controller = TextEditingController();
    _n2controller = TextEditingController();
    _n3controller = TextEditingController();
    _n4controller = TextEditingController();
    _n5controller = TextEditingController();
    _n6controller = TextEditingController();

    _controllers = [
      _n1controller,
      _n2controller,
      _n3controller,
      _n4controller,
      _n5controller,
      _n6controller,
    ];

    context.read<VerifyOtpBloc>().add(VerifyOtpTicked());
  }

  @override
  void dispose() {
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }

    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleFocus({required String value, required int index}) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyOtp(VerifyOtpRequestModel verifyOtpRequestModel) {
    UserTypeService.selectedUserTypeStrategy!.verifyOtp(
      context,
      verifyOtpRequestModel,
    );

    NavigationService.I.replaceWithNamed(
      AppRouteName.createNewPasswordScreen,
      arguments: CreateNewPasswordArguments(
        identifier: widget.verifyOtpArguments.identifier,
      ),
    );
  }

  void _verifyOtpListener(BuildContext context, VerifyOtpState state) {
    if (state is VerifyOtpSuccess) {
      NavigationService.I.replaceWithNamed(
        AppRouteName.createNewPasswordScreen,
        arguments: CreateNewPasswordArguments(
          identifier: widget.verifyOtpArguments.identifier,
        ),
      );
    } else if (state is VerifyOtpFailure) {
      AppDialog.showErrorDialog(context: context, failure: state.failure);
    }
  }

  void _resenOtp(VerifyOtpArguments verifyOtpArguments) {
    UserTypeService.selectedUserTypeStrategy!.resendOtp(
      context,
      SendOtpRequestModel(
        identifier: verifyOtpArguments.identifier,
        type: verifyOtpArguments.type.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          runSpacing: 10.r,
          spacing: 10.r,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: List.generate(6, (index) {
            return BlocSelector<ValidationCubit, ValidationState, bool?>(
              selector: (state) => state.fieldsValidity['n${index + 1}'],
              builder: (context, state) {
                return VerifyTextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) {
                    _handleFocus(value: value, index: index);
                    context.read<ValidationCubit>().validateField(
                      'n${index + 1}',
                      value.isNotEmpty,
                    );
                  },
                );
              },
            );
          }),
        ),
        64.verticalSpace,
        BlocBuilder<ValidationCubit, ValidationState>(
          builder: (context, validationState) {
            return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
              listener: _verifyOtpListener,
              builder: (context, state) {
                if (state is VerifyOtpLoading) {
                  return const AppButtonLoading();
                }

                return AppButton(
                  onClick: () {
                    final otp =
                        '${_n1controller.text}${_n2controller.text}${_n3controller.text}${_n4controller.text}${_n5controller.text}${_n6controller.text}';

                    _verifyOtp(
                      VerifyOtpRequestModel(
                        identifier: widget.verifyOtpArguments.identifier,
                        otp: otp,
                      ),
                    );
                  },
                  enabled: true,
                  text: context.tr.confirmPassword,
                );
              },
            );
          },
        ),
        32.verticalSpace,
        Text(
          context.tr.didNotReceiveOTP,
          style: AppStyles.s12W400.copyWith(color: context.customColor.text3),
        ),
        12.verticalSpace,
        BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
          buildWhen: (previous, current) =>
              current is VerifyOtpRunning || current is VerifyOtpCanResend,
          builder: (context, state) {
            if (state is VerifyOtpRunning) {
              return _buildResend(state);
            } else if (state is VerifyOtpCanResend) {
              return AppButton(
                onClick: () => _resenOtp(widget.verifyOtpArguments),
                enabled: true,
                text: context.tr.resend,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildResend(VerifyOtpRunning state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 17.r),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(1000.r),
        border: Border.all(color: context.customColor.border),
      ),
      child: Center(
        child: Text(
          '${context.tr.resendIn} ${state.secondsLeft}${context.tr.secs}',
          style: AppStyles.s14W500.copyWith(color: context.customColor.text3),
        ),
      ),
    );
  }
}
