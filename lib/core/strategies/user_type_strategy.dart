import 'package:assab/features/active_account/data/models/first_login_request_model.dart';
import 'package:assab/features/active_account/data/models/reset_password_activation_account_request_model.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account/active_account_cubit.dart';
import 'package:assab/features/login/presentation/cubits/login/login_cubit.dart';
import 'package:assab/features/reset_password/data/models/reset_password_model.dart';
import 'package:assab/features/reset_password/data/models/send_otp_request_model.dart';
import 'package:assab/features/reset_password/data/models/verify_otp_request_model.dart';
import 'package:assab/features/reset_password/presentation/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:assab/features/reset_password/presentation/bloc/verify_otp/verify_otp_event.dart';
import 'package:assab/features/reset_password/presentation/cubits/create_new_password/create_new_password_cubit.dart';
import 'package:assab/features/reset_password/presentation/cubits/send_otp/send_otp_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../routing/app_route_name.dart';
import '../services/navigation/navigation_service.dart';
import '../services/user_type_service.dart';

enum UserType {
  branchManager('branchManager'),
  cashier('cashier'),
  supplier('supplier'),
  brandOwner('brandOwner');

  final String _value;

  const UserType(this._value);

  String get value => _value;

  static UserType fromString(String value) {
    return UserType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserType.branchManager,
    );
  }
}

abstract class UserTypeStrategy {
  UserType get userType;

  Future<void> login(BuildContext context, String identifier, String password);

  Future<void> verifyOtp(
    BuildContext context,
    VerifyOtpRequestModel verifyOtpRequestModel,
  );

  Future<void> resendOtp(
    BuildContext context,
    SendOtpRequestModel sendOtpRequestModel,
  );

  Future<void> resetPasswordUsingOtp(
    BuildContext context,
    ResetPasswordModel request,
  );

  Future<void> activeAccount(
    BuildContext context,
    FirstLoginRequestModel request,
  );

  Future<void> resetPasswordFirstLogin(
    BuildContext context,
    ResetPasswordActivationAccountRequestModel request,
  );

  Future<void> saveUserTypeLocally() async {
    await UserTypeService.saveSelectedUserType(userType);
  }

  void goToMainScreen() {}
}

@Named('branchManager')
@LazySingleton(as: UserTypeStrategy)
class BranchManagerUserStrategy extends UserTypeStrategy {
  BranchManagerUserStrategy();

  @override
  UserType get userType => UserType.branchManager;

  @override
  Future<void> login(BuildContext context, String identifier, String password) async {
    context.read<LoginCubit>().branchManagerLogin(
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> verifyOtp(
    BuildContext context,
    VerifyOtpRequestModel verifyOtpRequestModel,
  ) async {
    context.read<VerifyOtpBloc>().add(
      BranchVerifyOtpStarted(verifyOtpRequestModel),
    );
  }

  @override
  Future<void> resendOtp(
    BuildContext context,
    SendOtpRequestModel sendOtpRequestModel,
  ) async {
    context.read<SendOtpCubit>().branchManagerSendOtp(
      request: sendOtpRequestModel,
    );
    context.read<VerifyOtpBloc>().add(VerifyOtpResend());
  }

  @override
  Future<void> resetPasswordUsingOtp(
    BuildContext context,
    ResetPasswordModel request,
  ) async {
    context.read<CreateNewPasswordCubit>().branchManagerResetPassword(
      request: request,
    );
  }

  @override
  Future<void> activeAccount(
    BuildContext context,
    FirstLoginRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().firstLogin(
      email: request.email,
      password: request.password,
    );
  }

  @override
  Future<void> resetPasswordFirstLogin(
    BuildContext context,
    ResetPasswordActivationAccountRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().resetPasswordFirstLogin(
      password: request.password,
      passwordConfirmation: request.passwordConfirmation,
    );
  }

  @override
  void goToMainScreen() {
    NavigationService.I.offAllNamed(AppRouteName.branchManagerMainScreen);
  }
}

@Named('supplier')
@LazySingleton(as: UserTypeStrategy)
class SupplierUserStrategy extends UserTypeStrategy {
  SupplierUserStrategy();

  @override
  UserType get userType => UserType.supplier;

  @override
  Future<void> login(BuildContext context, String identifier, String password) async {
    context.read<LoginCubit>().supplierLogin(
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> verifyOtp(
    BuildContext context,
    VerifyOtpRequestModel verifyOtpRequestModel,
  ) async {
    context.read<VerifyOtpBloc>().add(
      SupplierVerifyOtpStarted(verifyOtpRequestModel),
    );
  }

  @override
  Future<void> resendOtp(
    BuildContext context,
    SendOtpRequestModel sendOtpRequestModel,
  ) async {
    context.read<SendOtpCubit>().supplierSendOtp(request: sendOtpRequestModel);
    context.read<VerifyOtpBloc>().add(VerifyOtpResend());
  }

  @override
  Future<void> resetPasswordUsingOtp(
    BuildContext context,
    ResetPasswordModel request,
  ) async {
    context.read<CreateNewPasswordCubit>().supplierResetPassword(
      request: request,
    );
  }

  @override
  Future<void> activeAccount(
    BuildContext context,
    FirstLoginRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().supplierFirstLogin(
      email: request.email,
      password: request.password,
    );
  }

  @override
  Future<void> resetPasswordFirstLogin(
    BuildContext context,
    ResetPasswordActivationAccountRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().supplierResetPasswordFirstLogin(
      password: request.password,
      passwordConfirmation: request.passwordConfirmation,
    );
  }

  @override
  void goToMainScreen() {
    NavigationService.I.offAllNamed(AppRouteName.supplierMainScreen);
  }
}

@Named('cashier')
@LazySingleton(as: UserTypeStrategy)
class CashierUserStrategy extends UserTypeStrategy {
  CashierUserStrategy();

  @override
  UserType get userType => UserType.cashier;

  @override
  Future<void> login(BuildContext context, String identifier, String password) async {
    context.read<LoginCubit>().cashierLogin(
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> verifyOtp(
    BuildContext context,
    VerifyOtpRequestModel verifyOtpRequestModel,
  ) async {
    context.read<VerifyOtpBloc>().add(
      CashierVerifyOtpStarted(verifyOtpRequestModel),
    );
  }

  @override
  Future<void> resendOtp(
    BuildContext context,
    SendOtpRequestModel sendOtpRequestModel,
  ) async {
    context.read<SendOtpCubit>().cashierSendOtp(request: sendOtpRequestModel);
    context.read<VerifyOtpBloc>().add(VerifyOtpResend());
  }

  @override
  Future<void> resetPasswordUsingOtp(
    BuildContext context,
    ResetPasswordModel request,
  ) async {
    context.read<CreateNewPasswordCubit>().cashierResetPassword(
      request: request,
    );
  }

  @override
  Future<void> activeAccount(
    BuildContext context,
    FirstLoginRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().cashierFirstLogin(
      email: request.email,
      password: request.password,
    );
  }

  @override
  Future<void> resetPasswordFirstLogin(
    BuildContext context,
    ResetPasswordActivationAccountRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().cashierResetPasswordFirstLogin(
      password: request.password,
      passwordConfirmation: request.passwordConfirmation,
    );
  }

  @override
  void goToMainScreen() {
    NavigationService.I.offAllNamed(AppRouteName.cashierMainScreen);
  }
}

@Named('brandOwner')
@LazySingleton(as: UserTypeStrategy)
class BrandOwnerUserStrategy extends UserTypeStrategy {
  BrandOwnerUserStrategy();

  @override
  UserType get userType => UserType.brandOwner;

  @override
  Future<void> login(BuildContext context, String identifier, String password) async {
    context.read<LoginCubit>().brandOwnerLogin(
      identifier: identifier,
      password: password,
    );
  }

  @override
  Future<void> verifyOtp(
    BuildContext context,
    VerifyOtpRequestModel verifyOtpRequestModel,
  ) async {
    context.read<VerifyOtpBloc>().add(
      BrandOwnerVerifyOtpStarted(verifyOtpRequestModel),
    );
  }

  @override
  Future<void> resendOtp(
    BuildContext context,
    SendOtpRequestModel sendOtpRequestModel,
  ) async {
    context.read<SendOtpCubit>().brandOwnerSendOtp(
      request: sendOtpRequestModel,
    );
    context.read<VerifyOtpBloc>().add(VerifyOtpResend());
  }

  @override
  Future<void> resetPasswordUsingOtp(
    BuildContext context,
    ResetPasswordModel request,
  ) async {
    context.read<CreateNewPasswordCubit>().brandOwnerResetPassword(
      request: request,
    );
  }

  @override
  Future<void> activeAccount(
    BuildContext context,
    FirstLoginRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().brandOwnerFirstLogin(
      email: request.email,
      password: request.password,
    );
  }

  @override
  Future<void> resetPasswordFirstLogin(
    BuildContext context,
    ResetPasswordActivationAccountRequestModel request,
  ) async {
    context.read<ActiveAccountCubit>().brandOwnerResetPasswordFirstLogin(
      password: request.password,
      passwordConfirmation: request.passwordConfirmation,
    );
  }

  @override
  void goToMainScreen() {
    NavigationService.I.offAllNamed(AppRouteName.brandOwnerMainScreen);
  }
}
