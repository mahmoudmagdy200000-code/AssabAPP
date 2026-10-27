import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import 'package:retrofit/retrofit.dart';

import '../models/first_login_request_model.dart';
import '../../../../shared/models/login_model/login_response_model.dart';
import '../models/reset_password_activation_account_request_model.dart';

part 'active_account_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class ActiveAccountRemoteDataSource {
  factory ActiveAccountRemoteDataSource(Dio dio, {String? baseUrl}) =
      _ActiveAccountRemoteDataSource;

  @POST(ApiEndpoint.branchManagerFirstLogin)
  Future<LoginResponseModel> firstLogin(@Body() FirstLoginRequestModel request);

  @POST(ApiEndpoint.branchManagerResetPasswordFirstLogin)
  Future<void> resetPasswordFirstLogin(
    @Body() ResetPasswordActivationAccountRequestModel request,
  );

  @POST(ApiEndpoint.supplierActiveAccount)
  Future<LoginResponseModel> supplierFirstLogin(
    @Body() FirstLoginRequestModel request,
  );

  @POST(ApiEndpoint.supplierResetPasswordFirstLogin)
  Future<void> supplierResetPasswordFirstLogin(
    @Body() ResetPasswordActivationAccountRequestModel request,
  );

  @POST(ApiEndpoint.brandOwnerFirstLogin)
  Future<LoginResponseModel> brandOwnerFirstLogin(
    @Body() FirstLoginRequestModel request,
  );

  @POST(ApiEndpoint.brandOwnerResetPasswordFirstLogin)
  Future<void> brandOwnerResetPasswordFirstLogin(
    @Body() ResetPasswordActivationAccountRequestModel request,
  );

  @POST(ApiEndpoint.cashierFirstLogin)
  Future<LoginResponseModel> cashierFirstLogin(
    @Body() FirstLoginRequestModel request,
  );

  @POST(ApiEndpoint.cashierResetPasswordFirstLogin)
  Future<void> cashierResetPasswordFirstLogin(
    @Body() ResetPasswordActivationAccountRequestModel request,
  );
}
