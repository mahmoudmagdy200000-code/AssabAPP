import 'package:assab/shared/models/login_model/login_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/login_request_model.dart';

part 'login_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class LoginRemoteDataSource {
  factory LoginRemoteDataSource(Dio dio, {String? baseUrl}) =
      _LoginRemoteDataSource;

  @POST(ApiEndpoint.branchManagerLogin)
  Future<LoginResponseModel> branchManagerLogin(
    @Body() LoginRequestModel request,
  );

  @POST(ApiEndpoint.supplierLogin)
  Future<LoginResponseModel> supplierLogin(@Body() LoginRequestModel request);

  @POST(ApiEndpoint.cashierLogin)
  Future<LoginResponseModel> cashierLogin(@Body() LoginRequestModel request);

  @POST(ApiEndpoint.brandOwnerLogin)
  Future<LoginResponseModel> brandOwnerLogin(@Body() LoginRequestModel request);
}
