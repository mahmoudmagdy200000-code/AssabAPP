import 'package:assab/core/services/cancel_request_service.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_break_even_analysis_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_break_even_analysis_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_menu_engineering_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_menu_engineering_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_operational_profitability_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_operational_profitability_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_profit_and_loss_statement_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_profit_and_loss_statement_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_sales_channel_analysis_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_sales_channel_analysis_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_sales_channel_level2_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_sales_channel_level2_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_profit_vs_cash_reconciliation_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_profit_vs_cash_reconciliation_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_smart_comparison_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/brand_owner_smart_comparison_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/item_test_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/item_test_remote_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/price_simulator_data_source.dart';
import 'package:assab/features/brand_owner_financial_reporting/data/datasources/price_simulator_remote_data_source.dart';
import 'package:assab/features/brand_owner_reports_and_analytics/data/datasources/brand_owner_reports_and_analytics_remote_data_source.dart';
import 'package:assab/features/cashier_my_shifts/data/data_source/cashier_my_shifts_data_source.dart';
import 'package:assab/features/purchase/data/data_sources/remote/purchase_remote_data_source.dart';
import 'package:assab/features/supplier_requests/data/data_source/supplier_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../core/helpers/shared_preferences_helper.dart';
import '../../core/network/dio_client.dart';
import '../../features/active_account/data/data_source/active_account_remote_data_source.dart';
import '../../features/branch_manager_expenses/data/data_source/branch_manager_expenses_remote_data_source.dart';
import '../../features/branch_manager_home/data/data_sources/branch_manager_price_comparison_datasource.dart';
import '../../features/branch_manager_requests/data/data_source/requests_remote_data_source.dart';
import '../../features/brand_owner_home/data/datasource/brand_owner_home_remote_data_source.dart';
import '../../features/branch_manager_settings/data/datasources/branch_manager_setting_and_aggregators_remote_data_source.dart';
import '../../features/brand_owner_tools/data/datasources/brand_owner_fixed_assets_requests_remote_data_source.dart';
import '../../features/brand_owner_tools/data/datasources/brand_owner_asset_overview_remote_data_source.dart';
import '../../features/brand_owner_tools/data/datasources/brand_owner_inventory_remote_data_source.dart';
import '../../features/brand_owner_requests/data/data_source/brand_owner_requests_remote_data_source.dart';
import '../../features/cashier_home/data/datasources/cashier_home_remote_data_source.dart';
import '../../features/custody/data/data_sources/custody_remote_data_source.dart';
import '../../features/fixed_assets/data/data_source/fixed_assets_remote_data_source.dart';
import '../../features/inventory/data/data_sources/inventory_remote_data_source.dart';
import '../../features/login/data/data_source/login_remote_data_source.dart';
import '../../features/receive_goods/data/data_sources/receive_goods_remote_data_source.dart';
import '../../features/recurring_orders/data/data_sources/recurring_order_remote_data_source.dart';
import '../../features/reset_password/data/data_source/reset_password_remote_data_source.dart';
import '../../features/returns_management/data/data_sources/return_management_remote_data_source.dart';
import '../../features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart';
import '../../features/supplier_returns/data/data_sources/supplier_returns_remote_data_source.dart';

@module
abstract class AppModule {
  Dio? _dioInstance;

  @lazySingleton
  Logger get logger => Logger();

  @preResolve
  @LazySingleton()
  Future<SharedPreferencesHelper> providePrefsHelper(Logger logger) async {
    final helper = SharedPreferencesHelper(logger);
    await helper.init();
    return helper;
  }

  @lazySingleton
  FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage();

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  CancelRequestService get cancelRequestService => CancelRequestService();

  @lazySingleton
  Dio get dio => _dioInstance ??= DioClient.create();

  @lazySingleton
  ActiveAccountRemoteDataSource get activeAccountRemoteDataSource =>
      ActiveAccountRemoteDataSource(dio);

  @lazySingleton
  LoginRemoteDataSource get loginRemoteDataSource => LoginRemoteDataSource(dio);

  @lazySingleton
  ResetPasswordRemoteDataSource get resetPasswordRemoteDataSource =>
      ResetPasswordRemoteDataSource(dio);

  @lazySingleton
  BranchManagerExpensesRemoteDataSource
  get branchManagerExpensesRemoteDataSource =>
      BranchManagerExpensesRemoteDataSource(dio);

  @lazySingleton
  ShiftManagementRemoteDataSource get shiftManagementRemoteDataSource =>
      ShiftManagementRemoteDataSource(dio);

  @lazySingleton
  PurchaseRemoteDataSource get purchaseRemoteDataSource =>
      PurchaseRemoteDataSource(dio);

  @lazySingleton
  RequestsRemoteDataSource get requestsRemoteDataSource =>
      RequestsRemoteDataSource(dio);

  @lazySingleton
  CustodyRemoteDataSource get custodyRemoteDataSource =>
      CustodyRemoteDataSource(dio);

  @lazySingleton
  SupplierRemoteDataSource get supplierRemoteDataSource =>
      SupplierRemoteDataSource(dio);

  @lazySingleton
  ReceiveGoodsRemoteDataSource get receiveGoodsRemoteDataSource =>
      ReceiveGoodsRemoteDataSource(dio);

  @lazySingleton
  ReturnManagementRemoteDataSource get returnManagementRemoteDataSource =>
      ReturnManagementRemoteDataSource(dio);

  @lazySingleton
  SupplierReturnsRemoteDataSource get supplierReturnsRemoteDataSource =>
      SupplierReturnsRemoteDataSource(dio);

  @lazySingleton
  InventoryRemoteDataSource get inventoryRemoteDataSource =>
      InventoryRemoteDataSource(dio);

  @lazySingleton
  CashierMyShiftsRemoteDataSource get cashierMyShiftsRemoteDataSource =>
      CashierMyShiftsRemoteDataSource(dio);

  @lazySingleton
  RecurringOrderRemoteDataSource get recurringOrderRemoteDataSource =>
      RecurringOrderRemoteDataSource(dio);

  @lazySingleton
  CashierHomeRemoteDataSource get cashierHomeRemoteDataSource =>
      CashierHomeRemoteDataSource(dio);

  @lazySingleton
  FixedAssetsRemoteDataSource get fixedAssetsRemoteDataSource =>
      FixedAssetsRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerRequestsRemoteDataSource get brandOwnerRequestsRemoteDataSource =>
      BrandOwnerRequestsRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerHomeRemoteDataSource get brandOwnerHomeRemoteDataSource =>
      BrandOwnerHomeRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerInventoryRemoteDataSource get brandOwnerInventoryRemoteDataSource =>
      BrandOwnerInventoryRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerAssetOverviewRemoteDataSource
  get brandOwnerAssetOverviewRemoteDataSource =>
      BrandOwnerAssetOverviewRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerReportsAndAnalyticsRemoteDataSource
  get brandOwnerReportsAndAnalyticsRemoteDataSource =>
      BrandOwnerReportsAndAnalyticsRemoteDataSource(dio);

  @lazySingleton
  BranchManagerPriceComparisonRemoteClient
  get branchManagerPriceComparisonRemoteClient =>
      BranchManagerPriceComparisonRemoteClient(dio);

  @lazySingleton
  BranchManagerSettingAndAggregatorsRemoteDataSource
  get branchManagerSettingAndAggregatorsRemoteDataSource =>
      BranchManagerSettingAndAggregatorsRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerFixedAssetsRequestsRemoteDataSource
  get brandOwnerFixedAssetsRequestsRemoteDataSource =>
      BrandOwnerFixedAssetsRequestsRemoteDataSource(dio);

  @lazySingleton
  BrandOwnerProfitAndLossStatementDataSource
  get brandOwnerProfitAndLossStatementDataSource =>
      BrandOwnerProfitAndLossStatementRemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerSalesChannelLevel2DataSource
  get brandOwnerSalesChannelLevel2DataSource =>
      BrandOwnerSalesChannelLevel2RemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerSalesChannelAnalysisDataSource
  get brandOwnerSalesChannelAnalysisDataSource =>
      BrandOwnerSalesChannelAnalysisRemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerSmartComparisonDataSource
  get brandOwnerSmartComparisonDataSource =>
      BrandOwnerSmartComparisonRemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerProfitVsCashReconciliationDataSource
  get brandOwnerProfitVsCashReconciliationDataSource =>
      BrandOwnerProfitVsCashReconciliationRemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerBreakEvenAnalysisDataSource
  get brandOwnerBreakEvenAnalysisDataSource =>
      BrandOwnerBreakEvenAnalysisRemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerOperationalProfitabilityDataSource
  get brandOwnerOperationalProfitabilityDataSource =>
      BrandOwnerOperationalProfitabilityRemoteDataSourceImpl(dio);

  @lazySingleton
  BrandOwnerMenuEngineeringDataSource
  get brandOwnerMenuEngineeringDataSource =>
      BrandOwnerMenuEngineeringRemoteDataSourceImpl(dio);

  @lazySingleton
  PriceSimulatorDataSource get priceSimulatorDataSource =>
      PriceSimulatorRemoteDataSourceImpl(dio);

  @lazySingleton
  ItemTestDataSource get itemTestDataSource =>
      ItemTestRemoteDataSourceImpl(dio);
}
