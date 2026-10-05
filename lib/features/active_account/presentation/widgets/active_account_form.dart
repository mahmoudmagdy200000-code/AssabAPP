import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/extensions/number_extensions.dart';
import 'package:assab/core/routing/app_route_name.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/core/services/user_type_service.dart';
import 'package:assab/core/utils/app_bottom_sheet.dart';
import 'package:assab/core/utils/app_dialog.dart';
import 'package:assab/core/widgets/app_button_loading.dart';
import 'package:assab/core/widgets/create_account_bottom_sheet_widget.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account/active_account_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account_form/active_account_form_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account_form/active_account_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/enums/text_form_type.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/app_asset_image.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../shared/models/login_model/login_response_model.dart';
import '../../data/models/first_login_request_model.dart';
import '../cubits/active_account/active_account_state.dart';

class ActiveAccountForm extends StatefulWidget {
  const ActiveAccountForm({super.key});

  @override
  State<ActiveAccountForm> createState() => _ActiveAccountFormState();
}

class _ActiveAccountFormState extends State<ActiveAccountForm> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _howToCreateAccount() {
    AppBottomSheet.show(
      context,
      (context) => const CreateAccountBottomSheetWidget(),
    );
  }

  void _activeAccount() {
    UserTypeService.selectedUserTypeStrategy!.activeAccount(
      context,
      FirstLoginRequestModel(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _activeAccountSuccess(LoginResponseModel firstLoginResponseModel) async {
    NavigationService.I.pushNamed(
      AppRouteName.resetPasswordActiveAccountScreen,
    );
  }

  void _activeAccountListener(BuildContext context, ActiveAccountState state) {
    if (state is ActiveAccountSuccess) {
      _activeAccountSuccess(state.firstLoginResponseModel);
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
                      controller: _emailController,
                      label: context.tr.registeredEmail,
                      hint: context.tr.hintEmail,
                      error: context.read<ActiveAccountFormCubit>().state.emailError,
                      onChanged: (value) =>
                          context.read<ActiveAccountFormCubit>().updateEmail(value),
                    ),
                    16.verticalSpace,
                    AppTextFormField(
                      controller: _passwordController,
                      label: context.tr.defaultPassword,
                      hint: context.tr.defaultPassword,
                      textFormType: TextFormType.password,
                      error: context.read<ActiveAccountFormCubit>().state.passwordError,
                      onChanged: (value) =>
                          context.read<ActiveAccountFormCubit>().updatePassword(value),
                    ),
                    20.verticalSpace,
                    const CustomDivider(),
                    20.verticalSpace,
                    BlocSelector<ActiveAccountFormCubit, ActiveAccountFormState, bool>(
                      selector: (state) => state.isFormValid,
                      builder: (context, isFormValid) {
                        return BlocConsumer<
                          ActiveAccountCubit,
                          ActiveAccountState
                        >(
                          listener: _activeAccountListener,
                          builder: (context, state) {
                            if (state is ActiveAccountLoading) {
                              return const AppButtonLoading();
                            }

                            return AppButton(
                              onClick: _activeAccount,
                              enabled: isFormValid,
                              text: context.tr.verifyAccount,
                            );
                          },
                        );
                      },
                    ),
                    48.verticalSpace,
                    Text(
                      context.tr.doNotHaveAnAccountYet,
                      style: AppStyles.s12W400.copyWith(fontSize: 12.f),
                    ),
                    12.verticalSpace,
                    AppButton(
                      onClick: _howToCreateAccount,
                      isTransparent: true,
                      enabled: true,
                      text: context.tr.howToCreateAnAccount,
                      textColor: context.customColor.text1,
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
