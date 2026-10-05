import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/reset_password/data/data_source/reset_password_remote_data_source.dart';
import 'package:assab/features/reset_password/data/models/branch_manager_reset_my_password_request_model.dart';
import 'package:assab/features/reset_password/data/models/reset_password_model.dart';
import 'package:assab/features/reset_password/data/models/send_otp_request_model.dart';
import 'package:assab/features/reset_password/data/models/verify_otp_request_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class ResetPasswordRepository with RepositoryMixin {
  final ResetPasswordRemoteDataSource _resetPasswordRemoteDataSource;

  ResetPasswordRepository(this._resetPasswordRemoteDataSource);

  FutureApiResult<void> branchManagerSendOtp({
    required SendOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.branchManagerSendOtp(request);
  });

  FutureApiResult<void> branchManagerVerifyOtp({
    required VerifyOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.branchManagerVerifyOtp(request);
  });

  FutureApiResult<void> branchManagerResetPassword({
    required ResetPasswordModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.branchManagerResetPassword(request);
  });

  FutureApiResult<void> supplierSendOtp({
    required SendOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.supplierSendOtp(request);
  });

  FutureApiResult<void> supplierVerifyOtp({
    required VerifyOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.supplierVerifyOtp(request);
  });

  FutureApiResult<void> supplierResetPassword({
    required ResetPasswordModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.supplierResetPassword(request);
  });

  FutureApiResult<void> cashierSendOtp({
    required SendOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.cashierSendOtp(request);
  });

  FutureApiResult<void> cashierVerifyOtp({
    required VerifyOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.cashierVerifyOtp(request);
  });

  FutureApiResult<void> cashierResetPassword({
    required ResetPasswordModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.cashierResetPassword(request);
  });

  FutureApiResult<void> brandOwnerSendOtp({
    required SendOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.brandOwnerSendOtp(request);
  });

  FutureApiResult<void> brandOwnerVerifyOtp({
    required VerifyOtpRequestModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.brandOwnerVerifyOtp(request);
  });

  FutureApiResult<void> brandOwnerResetPassword({
    required ResetPasswordModel request,
  }) => execute(() async {
    return _resetPasswordRemoteDataSource.brandOwnerResetPassword(request);
  });
}
