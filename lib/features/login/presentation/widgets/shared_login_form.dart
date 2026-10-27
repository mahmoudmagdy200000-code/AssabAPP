import 'package:assab/core/enums/text_form_type.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/helpers/shared_preferences_helper.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/app_gesture_detector_button.dart';
import 'package:assab/core/widgets/app_text_form_field.dart';
import 'package:assab/core/widgets/bottom_section_auth_widget.dart';
import 'package:assab/core/widgets/custom_divider.dart';
import 'package:assab/core/widgets/row_create_account_and_reset_password_buttons.dart';
import 'package:assab/features/login/domain/entities/login_entity.dart';
import 'package:assab/features/login/presentation/cubits/login/login_cubit.dart';
import 'package:assab/features/login/presentation/cubits/login/login_state.dart';
import 'package:assab/features/login/presentation/cubits/login_form/login_form_cubit.dart';
import 'package:assab/features/login/presentation/cubits/login_form/login_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/styles/app_styles.dart';

enum LoginIdentifierType { email, phone }

class SharedLoginForm extends StatefulWidget {
  final LoginIdentifierType identifierType;
  final VoidCallback onSwitchMethod;
  final String switchMethodText;

  const SharedLoginForm({
    super.key,
    required this.identifierType,
    required this.onSwitchMethod,
    required this.switchMethodText,
  });

  @override
  State<SharedLoginForm> createState() => _SharedLoginFormState();
}

class _SharedLoginFormState extends State<SharedLoginForm> {
  late final TextEditingController _identifierController;
  late final TextEditingController _passwordController;

  String _normalizeLocalPhone(String raw) {
    final trimmed = raw.trim();
    if (trimmed.startsWith('+966')) {
      return trimmed.substring(4);
    }
    return trimmed;
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();

    final rawSaved = widget.identifierType == LoginIdentifierType.email
        ? getIt<SharedPreferencesHelper>().getString('u_email')
        : getIt<SharedPreferencesHelper>().getString('u_phone');

    final savedIdentifier = rawSaved == null
        ? null
        : (widget.identifierType == LoginIdentifierType.phone
              ? _normalizeLocalPhone(rawSaved)
              : rawSaved.trim());

    _identifierController = TextEditingController(text: savedIdentifier ?? '');

    if (savedIdentifier != null && savedIdentifier.isNotEmpty) {
      context.read<LoginFormCubit>().initWithIdentifier(savedIdentifier);
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final formState = context.read<LoginFormCubit>().state;
    final trimmedInput = _identifierController.text.trim();
    final identifier = widget.identifierType == LoginIdentifierType.phone
        ? (trimmedInput.startsWith('+') ? trimmedInput : '+966$trimmedInput')
        : trimmedInput;

    if (UserTypeService.selectedUserTypeStrategy == null) {
      UserTypeService.restoreSavedUserType();
    }
    final strategy = UserTypeService.selectedUserTypeStrategy;
    if (strategy == null) return;

    strategy.login(context, identifier, formState.password);
  }

  Future<void> _saveToken(LoginEntity entity) async {
    await getIt<TokenStorageService>().saveAccessToken(entity.token);
  }

  Future<void> _whenLoginSuccess(LoginEntity entity) async {
    final formState = context.read<LoginFormCubit>().state;
    if (UserTypeService.selectedUserTypeStrategy == null) {
      UserTypeService.restoreSavedUserType();
    }
    final strategy = UserTypeService.selectedUserTypeStrategy;
    if (strategy == null) return;

    await Future.wait([
      _saveToken(entity),
      if (formState.saveLoginDetails)
        getIt<SharedPreferencesHelper>().storeString(
          widget.identifierType == LoginIdentifierType.email
              ? 'u_email'
              : 'u_phone',
          widget.identifierType == LoginIdentifierType.email
              ? (entity.email.isNotEmpty
                    ? entity.email
                    : _identifierController.text.trim())
              : _normalizeLocalPhone(
                  entity.phone ?? _identifierController.text.trim(),
                ),
        ),
      getIt<SharedPreferencesHelper>().storeString('u_name', entity.name),
      getIt<SharedPreferencesHelper>().storeString('u_id', entity.id),
      UserTypeService.saveSelectedUserType(strategy.userType),
    ]);

    AuthService.markLoggedIn();
    strategy.goToMainScreen();
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      _whenLoginSuccess(state.entity);
    } else if (state is LoginFailure) {
      AppDialog.showErrorDialog(context: context, failure: state.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: _loginListener,
      builder: (context, loginState) {
        return BottomSectionAuthWidget(
          listWidgets: [
            BlocSelector<LoginFormCubit, LoginFormState, String?>(
              selector: (state) => state.identifierError,
              builder: (context, error) {
                return AppTextFormField(
                  controller: _identifierController,
                  label: widget.identifierType == LoginIdentifierType.email
                      ? context.tr.email
                      : context.tr.phone,
                  hint: widget.identifierType == LoginIdentifierType.email
                      ? context.tr.hintEmail
                      : context.tr.hintPhone,
                  textFormType:
                      widget.identifierType == LoginIdentifierType.phone
                      ? TextFormType.phone
                      : TextFormType.text,
                  onChanged: (value) =>
                      context.read<LoginFormCubit>().updateIdentifier(value),
                  error: error,
                );
              },
            ),
            16.verticalSpace,
            BlocSelector<LoginFormCubit, LoginFormState, String?>(
              selector: (state) => state.passwordError,
              builder: (context, error) {
                return AppTextFormField(
                  controller: _passwordController,
                  label: context.tr.password,
                  hint: context.tr.passwordHint,
                  textFormType: TextFormType.password,
                  onChanged: (value) =>
                      context.read<LoginFormCubit>().updatePassword(value),
                  error: error,
                );
              },
            ),
            16.verticalSpace,
            Row(
              children: [
                BlocSelector<LoginFormCubit, LoginFormState, bool>(
                  selector: (state) => state.saveLoginDetails,
                  builder: (context, saveLoginDetails) {
                    return Checkbox(
                      value: saveLoginDetails,
                      side: BorderSide(color: context.customColor.border),
                      onChanged: (value) {
                        context.read<LoginFormCubit>().toggleSaveLoginDetails(
                          value ?? false,
                        );
                      },
                    );
                  },
                ),
                Text(
                  context.tr.saveLoginDetailsToDevice,
                  style: AppStyles.s14W400.copyWith(
                    color: context.customColor.text3,
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            const CustomDivider(),
            20.verticalSpace,
            if (loginState is LoginLoading)
              const AppButtonLoading()
            else
              BlocSelector<LoginFormCubit, LoginFormState, bool>(
                selector: (state) => state.isFormValid,
                builder: (context, isFormValid) {
                  return AppButton(
                    onClick: _login,
                    enabled: isFormValid,
                    text: context.tr.logIn,
                  );
                },
              ),
            50.verticalSpace,
            AppGestureDetectorButton(
              onTap: widget.onSwitchMethod,
              child: Text(
                widget.switchMethodText,
                style: AppStyles.s15W500.copyWith(
                  color: context.theme.primaryColor,
                ),
              ),
            ),
            10.verticalSpace,
            Text(
              context.tr.accountRelatedQuickLinks,
              style: AppStyles.s12W400.copyWith(
                color: context.customColor.text3,
              ),
            ),
            16.verticalSpace,
            const RowCreateAccountAndResetPasswordButtons(),
          ],
        );
      },
    );
  }
}
