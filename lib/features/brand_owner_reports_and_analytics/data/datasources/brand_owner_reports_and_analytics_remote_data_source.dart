import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/brand_owner_custody_report_details_response_model.dart';
import '../models/brand_owner_expense_report_details_response_model.dart';
import '../models/brand_owner_reports_and_analytics_response_model.dart';
import '../models/brand_owner_export_report_response_model.dart';
import '../models/export_custody_report_request.dart';
import '../models/export_expense_report_request.dart';

part 'brand_owner_reports_and_analytics_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BrandOwnerReportsAndAnalyticsRemoteDataSource {
  factory BrandOwnerReportsAndAnalyticsRemoteDataSource(
    Dio dio, {
    String? baseUrl,
  }) = _BrandOwnerReportsAndAnalyticsRemoteDataSource;

  @GET(ApiEndpoint.brandOwnerReportsAndAnalytics)
  Future<BrandOwnerReportsAndAnalyticsResponseModel> getReportsAndAnalytics();

  @GET(ApiEndpoint.brandOwnerExpenseReportDetails)
  Future<BrandOwnerExpenseReportDetailsResponseModel> getExpenseReportDetails({
    @Path('reportId') required String reportId,
    @Query('type') String? type,
    @Query('status') String? status,
    @Query('month') int? month,
    @Query('year') int? year,
    @Query('branch_id') String? branchId,
  });

  @GET(ApiEndpoint.brandOwnerCustodyReportDetails)
  Future<BrandOwnerCustodyReportDetailsResponseModel> getCustodyReportDetails({
    @Path('reportId') required String reportId,
  });

  @POST(ApiEndpoint.brandOwnerExportExpenseReport)
  Future<BrandOwnerExportReportResponseModel> exportExpenseReport({
    @Body() required ExportExpenseReportRequest request,
  });

  @POST(ApiEndpoint.brandOwnerExportCustodyReport)
  Future<BrandOwnerExportReportResponseModel> exportCustodyReport({
    @Body() required ExportCustodyReportRequest request,
  });
}
