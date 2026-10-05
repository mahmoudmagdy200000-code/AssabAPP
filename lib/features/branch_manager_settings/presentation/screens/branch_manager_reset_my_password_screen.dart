import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/utils/app_snack_bar.dart';
import 'package:assab/core/widgets/app_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/cubits/validation/validation_state.dart';
import '../../../../core/enums/password_strength.dart';
import '../../../../core/enums/text_form_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_reg_exp.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_padding_widget.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../reset_password/presentation/widgets/password_strength_widget.dart';
import '../cubits/branch_manager_reset_my_password/branch_manager_reset_my_password_cubit.dart';
import '../cubits/branch_manager_reset_my_password/branch_manager_reset_my_password_state.dart';

class BranchManagerResetMyPasswordScreen extends StatefulWidget {
  const BranchManagerResetMyPasswordScreen({super.key});

  @override
  State<BranchManagerResetMyPasswordScreen> createState() =>
      _BranchManagerResetMyPasswordScreenState();
}

class _BranchManagerResetMyPasswordScreenState
    extends State<BranchManagerResetMyPasswordScreen> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final ValueNotifier<PasswordStrength> _strengthNotifier;
  late final ValidationCubit _validationCubit;
  late final BranchManagerResetMyPasswordCubit _resetPasswordCubit;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _strengthNotifier = ValueNotifier(PasswordStrength.empty);
    _validationCubit = ValidationCubit(
      requiredFields: {'oldPassword', 'password', 'confirmPassword'},
    );
    _resetPasswordCubit = getIt<BranchManagerResetMyPasswordCubit>();

    _oldPasswordController.addListener(_onOldPasswordChanged);
    _passwordController.addListener(_onNewPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _oldPasswordController.removeListener(_onOldPasswordChanged);
    _passwordController.removeListener(_onNewPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);

    _oldPasswordController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _strengthNotifier.dispose();
    _validationCubit.close();
    _resetPasswordCubit.close();
    super.dispose();
  }

  void _onOldPasswordChanged() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _passwordController.text;

    if (oldPassword.isEmpty) {
      _validationCubit.validateField('oldPassword', false);
      return;
    }

    if (newPassword.isNotEmpty) {
      _validationCubit.validateField('oldPassword', oldPassword != newPassword);
    }
  }

  void _onNewPasswordChanged() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _passwordController.text;

    _strengthNotifier.value = newPassword.isEmpty
        ? PasswordStrength.empty
        : AppRegExp.getPasswordStrength(newPassword);

    if (newPassword.isEmpty) {
      _validationCubit.validateField('password', false);
      if (oldPassword.isNotEmpty) {
        _validationCubit.validateField('oldPassword', false);
      }
    } else {
      _validationCubit.validateField(
        'password',
        AppRegExp.passwordValidator(newPassword),
      );

      if (oldPassword.isNotEmpty) {
        _validationCubit.validateField(
          'oldPassword',
          oldPassword != newPassword,
        );
      }
    }

    _revalidateConfirmPassword();
  }

  void _onConfirmPasswordChanged() {
    _revalidateConfirmPassword();
  }

  void _revalidateConfirmPassword() {
    final newPassword = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (confirmPassword.isEmpty) {
      _validationCubit.validateField('confirmPassword', false);
      return;
    }

    _validationCubit.validateField(
      'confirmPassword',
      AppRegExp.passwordValidator(confirmPassword) &&
          confirmPassword == newPassword,
    );
  }

  void _resetMyPassword() {
    _resetPasswordCubit.resetMyPassword(
      oldPassword: _oldPasswordController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
  }

  void _handleResetPasswordState(
    BuildContext context,
    BranchManagerResetMyPasswordState state,
  ) {
    if (state is BranchManagerResetMyPasswordLoading) {
      AppOverlay.showCustomOverlay(
        child: const AppLoadingWidget(),
        barrierDismissible: false,
        animated: true,
      );
      return;
    }

    AppOverlay.hideCustomOverlay();

    if (state is BranchManagerResetMyPasswordSuccess) {
      AppSnackBar.showSuccess(context, 'Password reset successfully');
      NavigationService.I.pop();
    } else if (state is BranchManagerResetMyPasswordFailure) {
      AppDialog.showErrorDialog(context: context, failure: state.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _resetPasswordCubit),
        BlocProvider.value(value: _validationCubit),
      ],
      child: Scaffold(
        backgroundColor: context.customColor.text2,
        body:
            BlocListener<
              BranchManagerResetMyPasswordCubit,
              BranchManagerResetMyPasswordState
            >(
              listener: _handleResetPasswordState,
              child: Column(
                children: [
                  AppPaddingWidget(
                    top: 30.r,
                    child: Row(
                      children: [
                        const AppBackButton(),
                        10.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reset my password',
                                style: AppStyles.s16W500.copyWith(
                                  color: context.customColor.text1,
                                ),
                              ),
                              Text(
                                'Reset your login password anytime.',
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
                      decoration: BoxDecoration(
                        color: context.customColor.reversedTextColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      padding: EdgeInsets.all(16.r),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            AppAssetImage(
                              image: AppAssets.resetPassword2,
                              width: 160.h,
                              height: 160.h,
                            ),
                            10.verticalSpace,
                            Text(
                              'Create new password',
                              style: AppStyles.s20W500.copyWith(
                                color: context.customColor.text1,
                              ),
                            ),
                            10.verticalSpace,
                            Text(
                              'Your new password must be different from the previous used passwords.',
                              style: AppStyles.s12W400.copyWith(
                                color: context.customColor.text3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            40.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool?
                            >(
                              selector: (state) =>
                                  state.fieldsValidity['oldPassword'],
                              builder: (context, isValid) {
                                return AppTextFormField(
                                  controller: _oldPasswordController,
                                  textFormType: TextFormType.password,
                                  label: context.tr.currentPassword,
                                  hint: context.tr.passwordHint,
                                  error: isValid == false
                                      ? context.tr.oldPasswordMatchesNew
                                      : null,
                                );
                              },
                            ),
                            16.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool?
                            >(
                              selector: (state) =>
                                  state.fieldsValidity['password'],
                              builder: (context, isValid) {
                                return AppTextFormField(
                                  controller: _passwordController,
                                  textFormType: TextFormType.password,
                                  label: context.tr.newPassword,
                                  hint: context.tr.passwordHint,
                                );
                              },
                            ),
                            16.verticalSpace,
                            PasswordStrengthWidget(
                              valueNotifier: _strengthNotifier,
                            ),
                            16.verticalSpace,
                            BlocSelector<
                              ValidationCubit,
                              ValidationState,
                              bool?
                            >(
                              selector: (state) =>
                                  state.fieldsValidity['confirmPassword'],
                              builder: (context, isValid) {
                                return AppTextFormField(
                                  controller: _confirmPasswordController,
                                  textFormType: TextFormType.password,
                                  label: context.tr.confirmPassword,
                                  hint: context.tr.passwordHint,
                                  error: _validationCubit.errorMsg(
                                    isValid,
                                    context.tr.passwordNoMatch,
                                  ),
                                );
                              },
                            ),
                            40.verticalSpace,
                            BlocBuilder<ValidationCubit, ValidationState>(
                              builder: (context, validationState) {
                                return AppButton(
                                  onClick: _resetMyPassword,
                                  enabled: validationState.enableButton,
                                  text: context.tr.confirmPasswordReset,
                                );
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
