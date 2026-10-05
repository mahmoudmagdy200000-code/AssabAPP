import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/core/cubits/validation/validation_state.dart';
import 'package:assab/core/enums/password_strength.dart';
import 'package:assab/core/enums/text_form_type.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_reg_exp.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_padding_widget.dart';
import 'package:assab/core/widgets/app_scaffold.dart';
import 'package:assab/core/widgets/app_text_form_field.dart';
import 'package:assab/features/reset_password/presentation/cubits/create_new_password/create_new_password_cubit.dart';
import 'package:assab/features/reset_password/presentation/cubits/create_new_password/create_new_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/create_new_password_arguments.dart';
import '../../data/models/reset_password_model.dart';
import '../widgets/create_new_password_top_section.dart';
import '../widgets/password_strength_widget.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final ValueNotifier<PasswordStrength> _valueNotifier;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _valueNotifier = ValueNotifier(PasswordStrength.empty);

    _passwordController.addListener(_validatePasswordMatching);
    _confirmPasswordController.addListener(_validatePasswordMatching);
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePasswordMatching);
    _confirmPasswordController.removeListener(_validatePasswordMatching);

    _valueNotifier.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswordMatching() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    context.read<ValidationCubit>().validateField(
      'password',
      AppRegExp.passwordValidator(password),
    );

    if (confirmPassword.isNotEmpty) {
      final isValidConfirm = AppRegExp.passwordValidator(confirmPassword);
      final isMatching = password == confirmPassword;

      context.read<ValidationCubit>().validateField(
        'confirmPassword',
        isValidConfirm && isMatching,
      );
    }
  }

  void _onChangePassword(String value) {
    if (value.isEmpty) {
      _valueNotifier.value = PasswordStrength.empty;
    } else {
      _valueNotifier.value = AppRegExp.getPasswordStrength(value);
    }
  }

  void _createNewPassword(
    CreateNewPasswordArguments createNewPasswordArguments,
  ) {
    UserTypeService.selectedUserTypeStrategy!.resetPasswordUsingOtp(
      context,
      ResetPasswordModel(
        identifier: createNewPasswordArguments.identifier,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      ),
    );
  }

  void _createNewPasswordListener(
    BuildContext context,
    CreateNewPasswordState state,
  ) {
    if (state is CreateNewPasswordSuccess) {
      NavigationService.I.offAllNamed(AppRouteName.resetPasswordSuccessScreen);
    } else if (state is CreateNewPasswordFailure) {
      AppDialog.showErrorDialog(context: context, failure: state.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createNewPasswordArguments =
        context.arguments as CreateNewPasswordArguments;

    return AppScaffold(
      child: AppPaddingWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateNewPasswordTopSection(),
              40.verticalSpace,
              BlocSelector<ValidationCubit, ValidationState, bool?>(
                selector: (state) => state.fieldsValidity['password'],
                builder: (context, state) {
                  return AppTextFormField(
                    controller: _passwordController,
                    textFormType: TextFormType.password,
                    label: context.tr.newPassword,
                    hint: context.tr.passwordHint,
                    onChanged: _onChangePassword,
                  );
                },
              ),
              16.verticalSpace,
              PasswordStrengthWidget(valueNotifier: _valueNotifier),
              16.verticalSpace,
              BlocSelector<ValidationCubit, ValidationState, bool?>(
                selector: (state) => state.fieldsValidity['confirmPassword'],
                builder: (context, state) {
                  return AppTextFormField(
                    controller: _confirmPasswordController,
                    textFormType: TextFormType.password,
                    label: context.tr.confirmPassword,
                    hint: context.tr.passwordHint,
                    error: context.read<ValidationCubit>().errorMsg(
                      state,
                      context.tr.passwordNoMatch,
                    ),
                  );
                },
              ),
              40.verticalSpace,
              BlocBuilder<ValidationCubit, ValidationState>(
                builder: (context, validationState) {
                  return BlocConsumer<
                    CreateNewPasswordCubit,
                    CreateNewPasswordState
                  >(
                    listener: _createNewPasswordListener,
                    builder: (context, state) {
                      if (state is CreateNewPasswordLoading) {
                        return const AppButtonLoading();
                      }

                      return AppButton(
                        onClick: () =>
                            _createNewPassword(createNewPasswordArguments),
                        enabled: validationState.enableButton,
                        text: context.tr.confirmPasswordReset,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
