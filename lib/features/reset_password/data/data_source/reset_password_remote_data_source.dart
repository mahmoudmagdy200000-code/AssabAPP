import 'package:assab/features/reset_password/data/models/reset_password_model.dart';
import 'package:assab/features/reset_password/data/models/branch_manager_reset_my_password_request_model.dart';
import 'package:assab/features/reset_password/data/models/send_otp_request_model.dart';
import 'package:assab/features/reset_password/data/models/verify_otp_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';

part 'reset_password_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class ResetPasswordRemoteDataSource {
  factory ResetPasswordRemoteDataSource(Dio dio, {String? baseUrl}) =
      _ResetPasswordRemoteDataSource;

  @POST(ApiEndpoint.branchManagerForgotPassword)
  Future<void> branchManagerSendOtp(@Body() SendOtpRequestModel request);

  @POST(ApiEndpoint.branchManagerVerifyOtp)
  Future<void> branchManagerVerifyOtp(@Body() VerifyOtpRequestModel request);

  @POST(ApiEndpoint.branchManagerResetPasswordUsingOtp)
  Future<void> branchManagerResetPassword(@Body() ResetPasswordModel request);

  @POST(ApiEndpoint.supplierSendOtp)
  Future<void> supplierSendOtp(@Body() SendOtpRequestModel request);

  @POST(ApiEndpoint.supplierVerifyOtp)
  Future<void> supplierVerifyOtp(@Body() VerifyOtpRequestModel request);

  @POST(ApiEndpoint.supplierResetPassword)
  Future<void> supplierResetPassword(@Body() ResetPasswordModel request);

  @POST(ApiEndpoint.cashierForgotPassword)
  Future<void> cashierSendOtp(@Body() SendOtpRequestModel request);

  @POST(ApiEndpoint.cashierVerifyOtp)
  Future<void> cashierVerifyOtp(@Body() VerifyOtpRequestModel request);

  @POST(ApiEndpoint.branchManagerResetPasswordUsingOtp)
  Future<void> cashierResetPassword(@Body() ResetPasswordModel request);

  @POST(ApiEndpoint.brandOwnerForgotPassword)
  Future<void> brandOwnerSendOtp(@Body() SendOtpRequestModel request);

  @POST(ApiEndpoint.brandOwnerVerifyOtp)
  Future<void> brandOwnerVerifyOtp(@Body() VerifyOtpRequestModel request);

  @POST(ApiEndpoint.brandOwnerResetPasswordUsingOtp)
  Future<void> brandOwnerResetPassword(@Body() ResetPasswordModel request);
}
