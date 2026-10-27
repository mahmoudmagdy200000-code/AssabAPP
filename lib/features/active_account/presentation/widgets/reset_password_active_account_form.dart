import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/token_storage_service.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/features/active_account/data/models/reset_password_activation_account_request_model.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account/active_account_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account/active_account_state.dart';
import 'package:assab/features/active_account/presentation/cubits/reset_password_form/reset_password_form_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/reset_password_form/reset_password_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/enums/text_form_type.dart';
import '../../../../core/services/user_type_service.dart';
import '../../../../core/utils/app_dialog.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class ResetPasswordActiveAccountForm extends StatefulWidget {
  const ResetPasswordActiveAccountForm({super.key});

  @override
  State<ResetPasswordActiveAccountForm> createState() =>
      _ResetPasswordActiveAccountFormState();
}

class _ResetPasswordActiveAccountFormState
    extends State<ResetPasswordActiveAccountForm> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (UserTypeService.selectedUserTypeStrategy == null) {
      UserTypeService.restoreSavedUserType();
    }
    final strategy = UserTypeService.selectedUserTypeStrategy;
    if (strategy == null) return;

    strategy.resetPasswordFirstLogin(
      context,
      ResetPasswordActivationAccountRequestModel(
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      ),
    );
  }

  Future<void> _resetPasswordListener(
    BuildContext context,
    ActiveAccountState state,
  ) async {
    if (state is ResetPasswordActiveAccountSuccess) {
      if (getIt.isRegistered<TokenStorageService>()) {
        await getIt<TokenStorageService>().clearTokens();
      }
      NavigationService.I.offAllNamed(AppRouteName.resetPasswordSuccessScreen);
    } else if (state is ActiveAccountFailure) {
      AppDialog.showErrorDialog(context: context, failure: state.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppAssetImage(image: AppAssets.row, width: 280.w, height: 15.h),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
              ),
              padding: EdgeInsets.all(20.r),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppTextFormField(
                      controller: _passwordController,
                      label: context.tr.createNewPassword,
                      hint: context.tr.passwordHint,
                      textFormType: TextFormType.password,
                      error: context
                          .read<ResetPasswordFormCubit>()
                          .state
                          .passwordError,
                      onChanged: (value) => context
                          .read<ResetPasswordFormCubit>()
                          .updatePassword(value),
                    ),
                    16.verticalSpace,
                    AppTextFormField(
                      controller: _confirmPasswordController,
                      label: context.tr.confirmPassword,
                      hint: context.tr.passwordHint,
                      textFormType: TextFormType.password,
                      error: context
                          .read<ResetPasswordFormCubit>()
                          .state
                          .confirmPasswordError,
                      onChanged: (value) => context
                          .read<ResetPasswordFormCubit>()
                          .updateConfirmPassword(value),
                    ),
                    176.verticalSpace,
                    BlocSelector<
                      ResetPasswordFormCubit,
                      ResetPasswordFormState,
                      bool
                    >(
                      selector: (state) => state.isFormValid,
                      builder: (context, isFormValid) {
                        return BlocConsumer<
                          ActiveAccountCubit,
                          ActiveAccountState
                        >(
                          listener: _resetPasswordListener,
                          builder: (context, state) {
                            if (state is ActiveAccountLoading) {
                              return const AppButtonLoading();
                            }

                            return AppButton(
                              onClick: _resetPassword,
                              enabled: isFormValid,
                              text: context.tr.completeAccountActivation,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
