// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;

import '../../features/active_account/data/data_source/active_account_remote_data_source.dart'
    as _i151;
import '../../features/active_account/data/repository/active_account_repository_impl.dart'
    as _i782;
import '../../features/active_account/domain/repositories/active_account_repository.dart'
    as _i1015;
import '../../features/active_account/domain/usecases/first_login_usecase.dart'
    as _i893;
import '../../features/active_account/domain/usecases/reset_password_first_login_usecase.dart'
    as _i539;
import '../../features/active_account/presentation/cubits/active_account/active_account_cubit.dart'
    as _i944;
import '../../features/branch_manager_expenses/data/data_source/branch_manager_expenses_remote_data_source.dart'
    as _i782;
import '../../features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart'
    as _i652;
import '../../features/branch_manager_expenses/domain/use_cases/get_categories_usecase.dart'
    as _i903;
import '../../features/branch_manager_expenses/presentation/cubit/branch_manager_expenses/branch_manager_expenses_cubit.dart'
    as _i67;
import '../../features/branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart'
    as _i450;
import '../../features/branch_manager_expenses/presentation/cubit/categories/categories_cubit.dart'
    as _i952;
import '../../features/branch_manager_expenses/presentation/cubit/create_expense_previous_request/create_expense_previous_request_cubit.dart'
    as _i878;
import '../../features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart'
    as _i730;
import '../../features/branch_manager_expenses/presentation/cubit/expenses_filter/expenses_filter_cubit.dart'
    as _i873;
import '../../features/branch_manager_expenses/presentation/cubit/expenses_get_custody_balance/expenses_get_custody_balance_cubit.dart'
    as _i145;
import '../../features/branch_manager_expenses/presentation/cubit/expenses_search/expenses_search_cubit.dart'
    as _i986;
import '../../features/branch_manager_expenses/presentation/cubit/grouped_invoice/grouped_invoice_cubit.dart'
    as _i289;
import '../../features/branch_manager_expenses/presentation/cubit/pre_approval/pre_approval_cubit.dart'
    as _i847;
import '../../features/branch_manager_expenses/presentation/cubit/quick_cash/quick_cash_cubit.dart'
    as _i1026;
import '../../features/branch_manager_expenses/presentation/cubit/single_expense/single_expense_cubit.dart'
    as _i705;
import '../../features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart'
    as _i749;
import '../../features/branch_manager_home/data/data_sources/branch_manager_price_comparison_datasource.dart'
    as _i825;
import '../../features/branch_manager_home/data/repositories/branch_manager_price_comparison_repository_impl.dart'
    as _i596;
import '../../features/branch_manager_home/domain/repositories/branch_manager_price_comparison_repository.dart'
    as _i957;
import '../../features/branch_manager_home/presentation/cubit/branch_manager_create_order_with_recommended_source/branch_manager_create_order_with_recommended_source_cubit.dart'
    as _i79;
import '../../features/branch_manager_home/presentation/cubit/branch_manager_export_price_comparison/branch_manager_export_price_comparison_cubit.dart'
    as _i503;
import '../../features/branch_manager_home/presentation/cubit/branch_manager_price_comparison/branch_manager_price_comparison_cubit.dart'
    as _i816;
import '../../features/branch_manager_home/presentation/cubit/branch_manager_price_comparison_details/branch_manager_price_comparison_details_cubit.dart'
    as _i919;
import '../../features/branch_manager_requests/data/data_source/requests_remote_data_source.dart'
    as _i442;
import '../../features/branch_manager_requests/data/repository/requests_repository.dart'
    as _i38;
import '../../features/branch_manager_requests/presentation/cubit/approve_or_reject_order/approve_or_reject_order_cubit.dart'
    as _i963;
import '../../features/branch_manager_requests/presentation/cubit/approve_or_reject_responsibility/approve_or_reject_responsibility_cubit.dart'
    as _i1026;
import '../../features/branch_manager_requests/presentation/cubit/branch_approve_or_reject_modification/branch_approve_or_reject_modification_cubit.dart'
    as _i924;
import '../../features/branch_manager_requests/presentation/cubit/branch_cancel_item/branch_cancel_item_cubit.dart'
    as _i693;
import '../../features/branch_manager_requests/presentation/cubit/branch_get_cancel_reason/branch_get_cancel_reason_cubit.dart'
    as _i393;
import '../../features/branch_manager_requests/presentation/cubit/branch_get_modification/branch_get_modification_cubit.dart'
    as _i671;
import '../../features/branch_manager_requests/presentation/cubit/get_handovers/get_handovers_cubit.dart'
    as _i109;
import '../../features/branch_manager_requests/presentation/cubit/get_order_details/get_order_details_cubit.dart'
    as _i921;
import '../../features/branch_manager_requests/presentation/cubit/get_orders/get_orders_cubit.dart'
    as _i838;
import '../../features/branch_manager_requests/presentation/cubit/get_responsibility_details/get_responsibility_details_cubit.dart'
    as _i479;
import '../../features/branch_manager_requests/presentation/cubit/get_variances/get_variances_cubit.dart'
    as _i758;
import '../../features/branch_manager_requests/presentation/cubit/reject_approve_delay/reject_approve_delay_cubit.dart'
    as _i704;
import '../../features/branch_manager_requests/presentation/cubit/select_branch_manager_approve_request/select_branch_manager_approve_request_cubit.dart'
    as _i734;
import '../../features/branch_manager_requests/presentation/cubit/select_branch_manager_delivery_time/select_branch_manager_delivery_time_cubit.dart'
    as _i890;
import '../../features/branch_manager_settings/data/datasources/branch_manager_setting_and_aggregators_remote_data_source.dart'
    as _i415;
import '../../features/branch_manager_settings/data/repositories/branch_manager_reset_my_password_repository_impl.dart'
    as _i418;
import '../../features/branch_manager_settings/data/repositories/branch_manager_setting_and_aggregators_repository_impl.dart'
    as _i799;
import '../../features/branch_manager_settings/data/repositories/brand_owner_settings_repository_impl.dart'
    as _i1054;
import '../../features/branch_manager_settings/domain/repositories/branch_manager_reset_my_password_repository.dart'
    as _i996;
import '../../features/branch_manager_settings/domain/repositories/branch_manager_setting_and_aggregators_repository.dart'
    as _i542;
import '../../features/branch_manager_settings/domain/repositories/brand_owner_settings_repository.dart'
    as _i471;
import '../../features/branch_manager_settings/domain/usecases/branch_manager_reset_my_password_usecase.dart'
    as _i155;
import '../../features/branch_manager_settings/domain/usecases/branch_manager_setting_and_aggregators_usecases.dart'
    as _i415;
import '../../features/branch_manager_settings/domain/usecases/brand_owner_settings_usecases.dart'
    as _i850;
import '../../features/branch_manager_settings/presentation/cubits/branch_manager_my_account_details_cubit.dart'
    as _i379;
import '../../features/branch_manager_settings/presentation/cubits/branch_manager_reset_my_password/branch_manager_reset_my_password_cubit.dart'
    as _i859;
import '../../features/branch_manager_settings/presentation/cubits/branch_manager_setting_and_aggregators_cubit.dart'
    as _i704;
import '../../features/branch_manager_settings/presentation/cubits/brand_owner_notifications/brand_owner_notifications_cubit.dart'
    as _i1034;
import '../../features/branch_manager_settings/presentation/cubits/brand_owner_report_settings/brand_owner_report_settings_cubit.dart'
    as _i308;
import '../../features/branch_manager_settings/presentation/cubits/brand_owner_retention_settings/brand_owner_retention_settings_cubit.dart'
    as _i745;
import '../../features/branch_manager_settings/presentation/cubits/brand_owner_security_setting/brand_owner_security_setting_cubit.dart'
    as _i706;
import '../../features/branch_manager_settings/presentation/cubits/brand_owner_setting_approval/brand_owner_setting_approval_cubit.dart'
    as _i104;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_break_even_analysis_data_source.dart'
    as _i489;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_menu_engineering_data_source.dart'
    as _i385;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_operational_profitability_data_source.dart'
    as _i644;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_profit_and_loss_statement_data_source.dart'
    as _i65;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_profit_vs_cash_reconciliation_data_source.dart'
    as _i599;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_sales_channel_analysis_data_source.dart'
    as _i738;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_sales_channel_level2_data_source.dart'
    as _i926;
import '../../features/brand_owner_financial_reporting/data/datasources/brand_owner_smart_comparison_data_source.dart'
    as _i460;
import '../../features/brand_owner_financial_reporting/data/datasources/item_test_data_source.dart'
    as _i430;
import '../../features/brand_owner_financial_reporting/data/datasources/price_simulator_data_source.dart'
    as _i658;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_break_even_analysis_repository_impl.dart'
    as _i741;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_menu_engineering_repository_impl.dart'
    as _i258;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_operational_profitability_repository_impl.dart'
    as _i38;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_profit_and_loss_statement_repository_impl.dart'
    as _i891;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_profit_vs_cash_reconciliation_repository_impl.dart'
    as _i733;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_sales_channel_analysis_repository_impl.dart'
    as _i693;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_sales_channel_level2_repository_impl.dart'
    as _i286;
import '../../features/brand_owner_financial_reporting/data/repositories/brand_owner_smart_comparison_repository_impl.dart'
    as _i523;
import '../../features/brand_owner_financial_reporting/data/repositories/item_test_repository_impl.dart'
    as _i303;
import '../../features/brand_owner_financial_reporting/data/repositories/price_simulator_repository_impl.dart'
    as _i249;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_break_even_analysis_repository.dart'
    as _i314;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_menu_engineering_repository.dart'
    as _i42;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_operational_profitability_repository.dart'
    as _i811;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_profit_and_loss_statement_repository.dart'
    as _i301;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_profit_vs_cash_reconciliation_repository.dart'
    as _i396;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_sales_channel_analysis_repository.dart'
    as _i950;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_sales_channel_level2_repository.dart'
    as _i685;
import '../../features/brand_owner_financial_reporting/domain/repositories/brand_owner_smart_comparison_repository.dart'
    as _i227;
import '../../features/brand_owner_financial_reporting/domain/repositories/item_test_repository.dart'
    as _i78;
import '../../features/brand_owner_financial_reporting/domain/repositories/price_simulator_repository.dart'
    as _i181;
import '../../features/brand_owner_financial_reporting/domain/usecases/email_item_test_usecase.dart'
    as _i444;
import '../../features/brand_owner_financial_reporting/domain/usecases/email_scenario_usecase.dart'
    as _i737;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_break_even_analysis_usecase.dart'
    as _i77;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_item_test_usecase.dart'
    as _i355;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_menu_engineering_usecase.dart'
    as _i242;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_operational_profitability_usecase.dart'
    as _i785;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_profit_and_loss_statement_usecase.dart'
    as _i952;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_profit_vs_cash_reconciliation_usecase.dart'
    as _i336;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_sales_channel_analysis_usecase.dart'
    as _i988;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_sales_channel_level2_usecase.dart'
    as _i261;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_scenario_usecase.dart'
    as _i722;
import '../../features/brand_owner_financial_reporting/domain/usecases/export_smart_comparison_usecase.dart'
    as _i651;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_branches_for_filter_usecase.dart'
    as _i482;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_break_even_analysis_usecase.dart'
    as _i265;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_menu_engineering_usecase.dart'
    as _i124;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_operational_profitability_usecase.dart'
    as _i920;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_price_simulator_item_info_usecase.dart'
    as _i893;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_price_simulator_items_usecase.dart'
    as _i831;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_profit_and_loss_statement_usecase.dart'
    as _i901;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_profit_vs_cash_reconciliation_usecase.dart'
    as _i657;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_sales_channel_analysis_usecase.dart'
    as _i1037;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_sales_channel_level2_usecase.dart'
    as _i518;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_saved_item_tests_usecase.dart'
    as _i214;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_saved_scenarios_usecase.dart'
    as _i983;
import '../../features/brand_owner_financial_reporting/domain/usecases/get_smart_comparison_usecase.dart'
    as _i210;
import '../../features/brand_owner_financial_reporting/domain/usecases/save_item_test_usecase.dart'
    as _i1039;
import '../../features/brand_owner_financial_reporting/domain/usecases/save_scenario_usecase.dart'
    as _i898;
import '../../features/brand_owner_financial_reporting/domain/usecases/submit_item_test_usecase.dart'
    as _i860;
import '../../features/brand_owner_financial_reporting/domain/usecases/submit_price_simulation_usecase.dart'
    as _i3;
import '../../features/brand_owner_financial_reporting/presentation/cubit/brand_owner_branches_for_filter_cubit.dart'
    as _i593;
import '../../features/brand_owner_financial_reporting/presentation/cubit/break_even_analysis_cubit.dart'
    as _i765;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_break_even_analysis_cubit.dart'
    as _i49;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_menu_engineering_cubit.dart'
    as _i853;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_operational_profitability_cubit.dart'
    as _i52;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_profit_and_loss_statement_cubit.dart'
    as _i569;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_profit_vs_cash_reconciliation_cubit.dart'
    as _i399;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_sales_channel_analysis_cubit.dart'
    as _i710;
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_smart_comparison_cubit.dart'
    as _i911;
import '../../features/brand_owner_financial_reporting/presentation/cubit/item_test_save_result_cubit.dart'
    as _i197;
import '../../features/brand_owner_financial_reporting/presentation/cubit/item_test_saved_test_details_cubit.dart'
    as _i272;
import '../../features/brand_owner_financial_reporting/presentation/cubit/item_test_saved_tests_cubit.dart'
    as _i633;
import '../../features/brand_owner_financial_reporting/presentation/cubit/item_test_screen_cubit.dart'
    as _i497;
import '../../features/brand_owner_financial_reporting/presentation/cubit/menu_engineering_cubit.dart'
    as _i545;
import '../../features/brand_owner_financial_reporting/presentation/cubit/operational_profitability_cubit.dart'
    as _i1029;
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_items_cubit.dart'
    as _i25;
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_save_scenario_cubit.dart'
    as _i466;
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_saved_scenarios_cubit.dart'
    as _i993;
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_scenario_details_cubit.dart'
    as _i184;
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_screen_cubit.dart'
    as _i276;
import '../../features/brand_owner_financial_reporting/presentation/cubit/profit_and_loss_statement_cubit.dart'
    as _i849;
import '../../features/brand_owner_financial_reporting/presentation/cubit/profit_vs_cash_reconciliation_cubit.dart'
    as _i523;
import '../../features/brand_owner_financial_reporting/presentation/cubit/sales_channel_analysis_cubit.dart'
    as _i44;
import '../../features/brand_owner_financial_reporting/presentation/cubit/sales_channel_level2_cubit.dart'
    as _i570;
import '../../features/brand_owner_financial_reporting/presentation/cubit/smart_comparison_cubit.dart'
    as _i774;
import '../../features/brand_owner_home/data/datasource/brand_owner_home_remote_data_source.dart'
    as _i600;
import '../../features/brand_owner_home/data/repository/brand_owner_home_repository.dart'
    as _i365;
import '../../features/brand_owner_home/presentation/cubit/brand_owner_branches/brand_owner_branches_cubit.dart'
    as _i711;
import '../../features/brand_owner_home/presentation/cubit/brand_owner_home/brand_owner_home_cubit.dart'
    as _i552;
import '../../features/brand_owner_home/presentation/cubit/brand_owner_payment/brand_owner_payment_cubit.dart'
    as _i41;
import '../../features/brand_owner_home/presentation/cubit/get_completed_escelations/get_completed_escelations_cubit.dart'
    as _i562;
import '../../features/brand_owner_home/presentation/cubit/get_pending_escelations/get_pending_escelations_cubit.dart'
    as _i3;
import '../../features/brand_owner_reports_and_analytics/data/datasources/brand_owner_reports_and_analytics_remote_data_source.dart'
    as _i1049;
import '../../features/brand_owner_reports_and_analytics/data/repositories/brand_owner_reports_and_analytics_repository_impl.dart'
    as _i1069;
import '../../features/brand_owner_reports_and_analytics/domain/repositories/brand_owner_reports_and_analytics_repository.dart'
    as _i450;
import '../../features/brand_owner_reports_and_analytics/domain/usecases/get_brand_owner_expense_report_details_usecase.dart'
    as _i1009;
import '../../features/brand_owner_reports_and_analytics/domain/usecases/get_brand_owner_reports_and_analytics_usecase.dart'
    as _i379;
import '../../features/brand_owner_reports_and_analytics/domain/usecases/get_custody_report_details_usecase.dart'
    as _i560;
import '../../features/brand_owner_reports_and_analytics/presentation/cubit/brand_owner_custody_report_details_cubit.dart'
    as _i545;
import '../../features/brand_owner_reports_and_analytics/presentation/cubit/brand_owner_expense_report_details_cubit.dart'
    as _i546;
import '../../features/brand_owner_reports_and_analytics/presentation/cubit/brand_owner_reports_and_analytics_cubit.dart'
    as _i1044;
import '../../features/brand_owner_reports_and_analytics/presentation/cubit/export_custody_report_cubit.dart'
    as _i630;
import '../../features/brand_owner_reports_and_analytics/presentation/cubit/export_expense_report_cubit.dart'
    as _i68;
import '../../features/brand_owner_requests/data/data_source/brand_owner_requests_remote_data_source.dart'
    as _i268;
import '../../features/brand_owner_requests/data/repositories/brand_owner_requests_repository.dart'
    as _i244;
import '../../features/brand_owner_requests/presentation/cubits/branch_owner_approve_reject_cubit.dart'
    as _i842;
import '../../features/brand_owner_requests/presentation/cubits/brand_owner_payment_log_cubit.dart'
    as _i119;
import '../../features/brand_owner_requests/presentation/cubits/brand_owner_requests_custody_sales_transfers_cubit.dart'
    as _i1064;
import '../../features/brand_owner_tools/data/datasources/brand_owner_asset_overview_remote_data_source.dart'
    as _i157;
import '../../features/brand_owner_tools/data/datasources/brand_owner_fixed_assets_requests_remote_data_source.dart'
    as _i699;
import '../../features/brand_owner_tools/data/datasources/brand_owner_inventory_remote_data_source.dart'
    as _i655;
import '../../features/brand_owner_tools/data/repositories/brand_owner_asset_overview_repository_impl.dart'
    as _i58;
import '../../features/brand_owner_tools/data/repositories/brand_owner_control_panel_repository_impl.dart'
    as _i1043;
import '../../features/brand_owner_tools/data/repositories/brand_owner_fixed_assets_requests_repository_impl.dart'
    as _i896;
import '../../features/brand_owner_tools/data/repositories/brand_owner_inventory_management_repository.dart'
    as _i79;
import '../../features/brand_owner_tools/domain/repositories/brand_owner_asset_overview_repository.dart'
    as _i915;
import '../../features/brand_owner_tools/domain/repositories/brand_owner_control_panel_repository.dart'
    as _i1019;
import '../../features/brand_owner_tools/domain/repositories/brand_owner_fixed_assets_requests_repository.dart'
    as _i949;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_daily_inventory_use_case.dart'
    as _i1012;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_fixed_assets_disposal_and_external_transfer_use_case.dart'
    as _i731;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_fixed_assets_handover_report_use_case.dart'
    as _i337;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_fixed_assets_modification_use_case.dart'
    as _i90;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_fixed_assets_review_audit_use_case.dart'
    as _i1057;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_fixed_assets_transfer_use_case.dart'
    as _i214;
import '../../features/brand_owner_tools/domain/use_cases/approve_brand_owner_wast_and_damage_use_case.dart'
    as _i861;
import '../../features/brand_owner_tools/domain/use_cases/export_brand_owner_asset_overview_report_use_case.dart'
    as _i918;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_asset_overview_branch_details_use_case.dart'
    as _i390;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_asset_overview_performance_summary_use_case.dart'
    as _i1048;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_asset_overview_use_case.dart'
    as _i845;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_control_panel_use_case.dart'
    as _i452;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_daily_inventory_details_use_case.dart'
    as _i987;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_daily_inventory_requests_use_case.dart'
    as _i752;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_disposal_and_external_transfer_details_use_case.dart'
    as _i831;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_disposal_and_external_transfer_requests_use_case.dart'
    as _i666;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_handover_report_details_use_case.dart'
    as _i271;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_handover_reports_requests_use_case.dart'
    as _i439;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_modification_details_use_case.dart'
    as _i605;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_modification_requests_use_case.dart'
    as _i379;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_review_audit_details_use_case.dart'
    as _i640;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_review_audit_requests_use_case.dart'
    as _i944;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_transfer_details_use_case.dart'
    as _i661;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_fixed_assets_transfer_requests_use_case.dart'
    as _i190;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_wast_and_damage_details_use_case.dart'
    as _i4;
import '../../features/brand_owner_tools/domain/use_cases/get_brand_owner_wast_and_damage_requests_use_case.dart'
    as _i452;
import '../../features/brand_owner_tools/domain/use_cases/reject_brand_owner_daily_inventory_use_case.dart'
    as _i291;
import '../../features/brand_owner_tools/domain/use_cases/reject_brand_owner_fixed_assets_disposal_and_external_transfer_use_case.dart'
    as _i921;
import '../../features/brand_owner_tools/domain/use_cases/reject_brand_owner_fixed_assets_modification_use_case.dart'
    as _i605;
import '../../features/brand_owner_tools/domain/use_cases/reject_brand_owner_fixed_assets_review_audit_use_case.dart'
    as _i57;
import '../../features/brand_owner_tools/domain/use_cases/reject_brand_owner_fixed_assets_transfer_use_case.dart'
    as _i420;
import '../../features/brand_owner_tools/domain/use_cases/reject_brand_owner_wast_and_damage_use_case.dart'
    as _i419;
import '../../features/brand_owner_tools/domain/use_cases/salary_deduction_brand_owner_fixed_assets_handover_report_use_case.dart'
    as _i230;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_asset_overview/brand_owner_asset_overview_cubit.dart'
    as _i456;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_asset_overview_branch_details/brand_owner_asset_overview_branch_details_cubit.dart'
    as _i61;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_asset_overview_export/brand_owner_asset_overview_export_cubit.dart'
    as _i240;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_asset_overview_performance_summary/brand_owner_asset_overview_performance_summary_cubit.dart'
    as _i399;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_asset_overview_search/brand_owner_asset_overview_search_cubit.dart'
    as _i212;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_control_panel/brand_owner_control_panel_cubit.dart'
    as _i114;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_cubit.dart'
    as _i879;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_daily_inventory_requests/brand_owner_daily_inventory_requests_cubit.dart'
    as _i470;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_disposal_and_external_transfer_details/brand_owner_disposal_and_external_transfer_details_cubit.dart'
    as _i296;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_fixed_assets_requests/brand_owner_fixed_assets_requests_cubit.dart'
    as _i1031;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_handover_reports_details/brand_owner_handover_reports_details_cubit.dart'
    as _i472;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_modification_details/brand_owner_modification_details_cubit.dart'
    as _i281;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_review_audit_details/brand_owner_review_audit_details_cubit.dart'
    as _i422;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_transfer_details/brand_owner_transfer_details_cubit.dart'
    as _i1027;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_wast_and_damage_details/brand_owner_wast_and_damage_details_cubit.dart'
    as _i657;
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_wast_and_damage_requests/brand_owner_wast_and_damage_requests_cubit.dart'
    as _i721;
import '../../features/cashier_home/data/datasources/cashier_home_remote_data_source.dart'
    as _i1013;
import '../../features/cashier_home/data/repository/cashier_home_repository.dart'
    as _i331;
import '../../features/cashier_home/presentation/cubit/get_branch_info/get_branch_info_cubit.dart'
    as _i1004;
import '../../features/cashier_home/presentation/cubit/get_cashier_info/get_cashier_info_cubit.dart'
    as _i991;
import '../../features/cashier_home/presentation/cubit/get_tasks/get_tasks_cubit.dart'
    as _i172;
import '../../features/cashier_my_shifts/data/data_source/cashier_my_shifts_data_source.dart'
    as _i395;
import '../../features/cashier_my_shifts/data/repository/cashier_my_shifts_repo.dart'
    as _i534;
import '../../features/cashier_my_shifts/presentation/cubits/cashier_my_shifts_cubit.dart'
    as _i866;
import '../../features/cashier_my_shifts/presentation/cubits/reassign_cashier_shift_cubit.dart'
    as _i1004;
import '../../features/cashier_requests/presentation/cubits/accept_reassigned_shift/accept_reassigned_shift_cubit.dart'
    as _i355;
import '../../features/cashier_requests/presentation/cubits/get_reassignments/get_reassignments_cubit.dart'
    as _i884;
import '../../features/choose_user_type/presentation/cubit/choose_user_type/choose_user_type_cubit.dart'
    as _i338;
import '../../features/custody/data/data_sources/custody_remote_data_source.dart'
    as _i153;
import '../../features/custody/data/repository/custody_repository.dart'
    as _i816;
import '../../features/custody/presentation/cubit/create_handover_to_cashier/create_handover_to_cashier_cubit.dart'
    as _i530;
import '../../features/custody/presentation/cubit/custody_create_request/custody_create_request_cubit.dart'
    as _i467;
import '../../features/custody/presentation/cubit/custody_get_personal_balance_only/custody_get_personal_balance_only_cubit.dart'
    as _i551;
import '../../features/custody/presentation/cubit/custody_get_requets/custody_get_requets_cubit.dart'
    as _i784;
import '../../features/custody/presentation/cubit/export_personal_balance_as_pdf/export_personal_balance_as_pdf_cubit.dart'
    as _i608;
import '../../features/custody/presentation/cubit/get_branch_balance/get_branch_balance_cubit.dart'
    as _i980;
import '../../features/custody/presentation/cubit/get_branch_balance_transactions/get_branch_balance_transactions_cubit.dart'
    as _i690;
import '../../features/custody/presentation/cubit/get_custody_details/get_custody_details_cubit.dart'
    as _i326;
import '../../features/custody/presentation/cubit/get_custody_recipients/get_custody_recipients_cubit.dart'
    as _i534;
import '../../features/custody/presentation/cubit/get_custody_trend_state/get_custody_trend_state_cubit.dart'
    as _i386;
import '../../features/custody/presentation/cubit/get_personal_balance/get_personal_balance_cubit.dart'
    as _i354;
import '../../features/custody/presentation/cubit/get_personal_balance_transactions/get_personal_balance_transactions_cubit.dart'
    as _i1015;
import '../../features/custody/presentation/cubit/select_export_account_statement_as_pdf/select_export_account_statement_as_pdf_cubit.dart'
    as _i859;
import '../../features/custody/presentation/cubit/select_filter_account_statement/select_filter_account_statement_cubit.dart'
    as _i231;
import '../../features/custody/presentation/cubit/select_filter_custody_requests/select_filter_custody_requests_cubit.dart'
    as _i36;
import '../../features/custody/presentation/cubit/select_filter_custody_transactions/select_filter_custody_transactions_cubit.dart'
    as _i140;
import '../../features/fixed_assets/data/data_source/fixed_assets_remote_data_source.dart'
    as _i628;
import '../../features/fixed_assets/data/repositories/fixed_assets_repository.dart'
    as _i836;
import '../../features/fixed_assets/domain/use_cases/confirm_active_handover_signature_receiver_use_case.dart'
    as _i477;
import '../../features/fixed_assets/domain/use_cases/confirm_active_handover_signature_sender_use_case.dart'
    as _i628;
import '../../features/fixed_assets/domain/use_cases/generate_fixed_assets_preview_history_asset_report_use_case.dart'
    as _i406;
import '../../features/fixed_assets/domain/use_cases/get_active_handover_session_preview_assets_use_case.dart'
    as _i93;
import '../../features/fixed_assets/domain/use_cases/get_fixed_assets_preview_history_asset_use_case.dart'
    as _i62;
import '../../features/fixed_assets/presentation/cubit/complete__handover_session/complete__handover_session_cubit.dart'
    as _i907;
import '../../features/fixed_assets/presentation/cubit/confirm_active_handover_signature/confirm_active_handover_signature_cubit.dart'
    as _i627;
import '../../features/fixed_assets/presentation/cubit/fixd_assets_active_handover_approval/fixd_assets_active_handover_approval_cubit.dart'
    as _i675;
import '../../features/fixed_assets/presentation/cubit/fixd_assets_join_handover/fixd_assets_join_handover_cubit.dart'
    as _i256;
import '../../features/fixed_assets/presentation/cubit/fixd_assets_start_handover/fixd_assets_start_handover_cubit.dart'
    as _i857;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_disposals_details/fixed_assets_disposals_details_cubit.dart'
    as _i811;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_get_receive_assets/fixed_assets_get_receive_assets_cubit.dart'
    as _i855;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_get_requests/fixed_assets_get_requests_cubit.dart'
    as _i631;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart'
    as _i748;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_cubit.dart'
    as _i991;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_receive_assets/fixed_assets_receive_assets_cubit.dart'
    as _i310;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_search/fixed_assets_search_cubit.dart'
    as _i336;
import '../../features/fixed_assets/presentation/cubit/fixed_assets_transfer_details/fixed_assets_transfer_details_cubit.dart'
    as _i625;
import '../../features/fixed_assets/presentation/cubit/generate_fixed_assets_preview_history_asset_report/generate_fixed_assets_preview_history_asset_report_cubit.dart'
    as _i1032;
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_details/get_active_handover_session_details_cubit.dart'
    as _i909;
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_preview_assets/get_active_handover_session_preview_assets_cubit.dart'
    as _i761;
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart'
    as _i446;
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_summary/get_active_handover_session_summary_cubit.dart'
    as _i89;
import '../../features/fixed_assets/presentation/cubit/get_fixed_assets_handover_details/get_fixed_assets_handover_details_cubit.dart'
    as _i333;
import '../../features/fixed_assets/presentation/cubit/get_fixed_assets_overview/get_fixed_assets_overview_cubit.dart'
    as _i642;
import '../../features/fixed_assets/presentation/cubit/get_fixed_assets_preview_history_asset/get_fixed_assets_preview_history_asset_cubit.dart'
    as _i467;
import '../../features/fixed_assets/presentation/cubit/get_handover_included_zones/get_handover_included_zones_cubit.dart'
    as _i882;
import '../../features/fixed_assets/presentation/cubit/get_join_handover_session_details/get_join_handover_session_details_cubit.dart'
    as _i220;
import '../../features/fixed_assets/presentation/cubit/get_requests_details/get_requests_details_cubit.dart'
    as _i739;
import '../../features/fixed_assets/presentation/cubit/modify_asset/modify_asset_cubit.dart'
    as _i950;
import '../../features/fixed_assets/presentation/cubit/transfer_or_dispose_assets/transfer_or_dispose_assets_cubit.dart'
    as _i841;
import '../../features/fixed_assets/presentation/cubit/update_asset_settings/update_asset_settings_cubit.dart'
    as _i619;
import '../../features/inventory/data/data_sources/inventory_remote_data_source.dart'
    as _i171;
import '../../features/inventory/data/repository/inventory_repository.dart'
    as _i117;
import '../../features/inventory/presentation/cubit/create_inventory/create_inventory_cubit.dart'
    as _i671;
import '../../features/inventory/presentation/cubit/create_waste_damage/create_waste_damage_cubit.dart'
    as _i984;
import '../../features/inventory/presentation/cubit/get_daily_inventory_items/get_daily_inventory_items_cubit.dart'
    as _i692;
import '../../features/inventory/presentation/cubit/get_inventory_employee/get_inventory_employee_cubit.dart'
    as _i522;
import '../../features/inventory/presentation/cubit/get_inventory_requests/get_inventory_requests_cubit.dart'
    as _i605;
import '../../features/inventory/presentation/cubit/get_monthly_completed_products/get_monthly_completed_products_cubit.dart'
    as _i1048;
import '../../features/inventory/presentation/cubit/get_monthly_details/get_monthly_details_cubit.dart'
    as _i473;
import '../../features/inventory/presentation/cubit/get_monthly_pending_products/get_monthly_pending_products_cubit.dart'
    as _i1041;
import '../../features/inventory/presentation/cubit/get_monthly_setup_info/get_monthly_setup_info_cubit.dart'
    as _i863;
import '../../features/inventory/presentation/cubit/get_wasted_damage_items/get_wasted_damage_items_cubit.dart'
    as _i369;
import '../../features/inventory/presentation/cubit/inventory_approve_reject_staff_submition/inventory_approve_reject_staff_submition_cubit.dart'
    as _i158;
import '../../features/inventory/presentation/cubit/start_monthly_inventory/start_monthly_inventory_cubit.dart'
    as _i553;
import '../../features/inventory/presentation/cubit/submit_monthly_inventory/submit_monthly_inventory_cubit.dart'
    as _i617;
import '../../features/inventory/presentation/cubit/update_qty_monthly_inventory/update_qty_monthly_inventory_bloc.dart'
    as _i257;
import '../../features/inventory/presentation/cubit/wasted_selected_items/wasted_selected_items_cubit.dart'
    as _i324;
import '../../features/login/data/data_source/login_remote_data_source.dart'
    as _i678;
import '../../features/login/data/repository/login_repository.dart' as _i59;
import '../../features/login/domain/repositories/login_repository.dart'
    as _i902;
import '../../features/login/domain/usecases/branch_manager_login_usecase.dart'
    as _i929;
import '../../features/login/domain/usecases/brand_owner_login_usecase.dart'
    as _i605;
import '../../features/login/domain/usecases/cashier_login_usecase.dart'
    as _i244;
import '../../features/login/domain/usecases/supplier_login_usecase.dart'
    as _i573;
import '../../features/login/presentation/cubits/login/login_cubit.dart'
    as _i545;
import '../../features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart'
    as _i607;
import '../../features/purchase/data/data_sources/remote/purchase_remote_data_source.dart'
    as _i336;
import '../../features/purchase/data/repository/purchase_repository.dart'
    as _i200;
import '../../features/purchase/presentation/cubit/add_item_purchase/add_item_purchase_cubit.dart'
    as _i904;
import '../../features/purchase/presentation/cubit/choose_branch/choose_branch_cubit.dart'
    as _i163;
import '../../features/purchase/presentation/cubit/compare_price/compare_price_cubit.dart'
    as _i942;
import '../../features/purchase/presentation/cubit/create_purchase_order/create_purchase_order_cubit.dart'
    as _i212;
import '../../features/purchase/presentation/cubit/delete_order_draft/delete_order_draft_cubit.dart'
    as _i83;
import '../../features/purchase/presentation/cubit/filter_branches/filter_branches_cubit.dart'
    as _i517;
import '../../features/purchase/presentation/cubit/filter_purchase_history/filter_purchase_history_cubit.dart'
    as _i245;
import '../../features/purchase/presentation/cubit/filter_suppliers/filter_suppliers_cubit.dart'
    as _i420;
import '../../features/purchase/presentation/cubit/get_categories_for_filter/get_categories_for_filter_cubit.dart'
    as _i45;
import '../../features/purchase/presentation/cubit/get_purchase_branch_items/get_purchase_branch_items_cubit.dart'
    as _i51;
import '../../features/purchase/presentation/cubit/get_purchase_branches/get_purchase_branches_cubit.dart'
    as _i811;
import '../../features/purchase/presentation/cubit/get_purchase_products_branch_details/get_purchase_products_branch_details_cubit.dart'
    as _i873;
import '../../features/purchase/presentation/cubit/get_purchase_products_officer_details/get_purchase_products_officer_details_cubit.dart'
    as _i1006;
import '../../features/purchase/presentation/cubit/get_purchase_products_supplier_details/get_purchase_products_supplier_details_cubit.dart'
    as _i994;
import '../../features/purchase/presentation/cubit/get_purchase_suppliers/get_purchase_suppliers_cubit.dart'
    as _i317;
import '../../features/purchase/presentation/cubit/get_suppliers_for_filter/get_suppliers_for_filter_cubit.dart'
    as _i492;
import '../../features/purchase/presentation/cubit/purchase_history/purchase_history_cubit.dart'
    as _i332;
import '../../features/purchase/presentation/cubit/purchasing_officer_select_processing_time/purchasing_officer_select_processing_time_cubit.dart'
    as _i914;
import '../../features/purchase/presentation/cubit/purchasing_officer_select_quality/purchasing_officer_select_quality_cubit.dart'
    as _i417;
import '../../features/purchase/presentation/cubit/save_compare_price/save_compare_price_cubit.dart'
    as _i864;
import '../../features/purchase/presentation/cubit/select_filter_item/select_filter_item_cubit.dart'
    as _i362;
import '../../features/purchase/presentation/cubit/select_filter_purchase_history/select_filter_purchase_history_cubit.dart'
    as _i584;
import '../../features/receive_goods/data/data_sources/receive_goods_remote_data_source.dart'
    as _i691;
import '../../features/receive_goods/data/repository/receive_goods_repository.dart'
    as _i181;
import '../../features/receive_goods/presentation/cubit/get_receive_order_inspection/get_receive_order_inspection_cubit.dart'
    as _i630;
import '../../features/receive_goods/presentation/cubit/get_receiving_orders/get_receiving_orders_cubit.dart'
    as _i601;
import '../../features/receive_goods/presentation/cubit/start_receive_order/start_receive_order_cubit.dart'
    as _i971;
import '../../features/recurring_orders/data/data_sources/recurring_order_remote_data_source.dart'
    as _i189;
import '../../features/recurring_orders/data/repository/recurring_order_repository.dart'
    as _i973;
import '../../features/recurring_orders/presentation/cubit/create_recurring_order/create_recurring_order_cubit.dart'
    as _i416;
import '../../features/recurring_orders/presentation/cubit/get_in_progress_recurring_orders/get_in_progress_recurring_orders_cubit.dart'
    as _i142;
import '../../features/recurring_orders/presentation/cubit/get_next_scheduled_recurring_orders/get_next_scheduled_recurring_orders_cubit.dart'
    as _i942;
import '../../features/recurring_orders/presentation/cubit/get_paused_recurring_orders/get_paused_recurring_orders_cubit.dart'
    as _i251;
import '../../features/recurring_orders/presentation/cubit/get_recurring_order_details/get_recurring_order_details_cubit.dart'
    as _i186;
import '../../features/recurring_orders/presentation/cubit/recurring_order_actions/recurring_order_actions_cubit.dart'
    as _i263;
import '../../features/reset_password/data/data_source/reset_password_remote_data_source.dart'
    as _i655;
import '../../features/reset_password/data/repository/reset_password_repository.dart'
    as _i850;
import '../../features/reset_password/presentation/bloc/verify_otp/verify_otp_bloc.dart'
    as _i982;
import '../../features/reset_password/presentation/cubits/create_new_password/create_new_password_cubit.dart'
    as _i695;
import '../../features/reset_password/presentation/cubits/send_otp/send_otp_cubit.dart'
    as _i24;
import '../../features/returns_management/data/data_sources/return_management_remote_data_source.dart'
    as _i434;
import '../../features/returns_management/data/repository/return_management_repository.dart'
    as _i667;
import '../../features/returns_management/presentation/cubit/accept_escalate_return_rejection/accept_escalate_return_rejection_cubit.dart'
    as _i952;
import '../../features/returns_management/presentation/cubit/create_return/create_return_cubit.dart'
    as _i684;
import '../../features/returns_management/presentation/cubit/get_return_details/get_return_details_cubit.dart'
    as _i349;
import '../../features/returns_management/presentation/cubit/get_returns/get_returns_cubit.dart'
    as _i531;
import '../../features/shift_module_features/shift_management/data/data_source/shift_management_remote_data_source.dart'
    as _i572;
import '../../features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassign_shift_params.dart'
    as _i760;
import '../../features/shift_module_features/shift_management/data/repository/shift_management_repository_imp.dart'
    as _i430;
import '../../features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart'
    as _i136;
import '../../features/shift_module_features/shift_management/presentation/logic/add_cashier/add_cashier_cubit.dart'
    as _i761;
import '../../features/shift_module_features/shift_management/presentation/logic/cashier/cashier_filter/cashier_filter_cubit.dart'
    as _i92;
import '../../features/shift_module_features/shift_management/presentation/logic/cashier/cashier_management_cubit.dart'
    as _i254;
import '../../features/shift_module_features/shift_management/presentation/logic/cashier/start_cashier_shift_cubit.dart'
    as _i794;
import '../../features/shift_module_features/shift_management/presentation/logic/choose_variance_reason/choose_variance_reason_cubit.dart'
    as _i911;
import '../../features/shift_module_features/shift_management/presentation/logic/get_cashier/get_cashier_cubit.dart'
    as _i10;
import '../../features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart'
    as _i881;
import '../../features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart'
    as _i1000;
import '../../features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart'
    as _i35;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart'
    as _i123;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/approve_and_reject_handover/approve_and_reject_handover_cubit.dart'
    as _i187;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart'
    as _i1015;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart'
    as _i1053;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/handover/handover_cubit.dart'
    as _i156;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/reassign_shift/reassign_shift_cubit.dart'
    as _i590;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/handover_option/end_shift_option_cubit.dart'
    as _i526;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart'
    as _i54;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/shift_filter/fetch_manager_cubit.dart'
    as _i628;
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/variance/variance_cubit.dart'
    as _i585;
import '../../features/supplier_requests/data/data_source/supplier_remote_data_source.dart'
    as _i144;
import '../../features/supplier_requests/data/repository/supplier_requests_repository.dart'
    as _i507;
import '../../features/supplier_requests/presentation/cubit/get_supplier_items/get_supplier_items_cubit.dart'
    as _i543;
import '../../features/supplier_requests/presentation/cubit/supplier_confirm_or_reject_order_or_item/supplier_confirm_or_reject_order_or_item_cubit.dart'
    as _i199;
import '../../features/supplier_requests/presentation/cubit/supplier_get_cancellation_reason/supplier_get_cancellation_reason_cubit.dart'
    as _i993;
import '../../features/supplier_requests/presentation/cubit/supplier_get_modification/supplier_get_modification_cubit.dart'
    as _i585;
import '../../features/supplier_requests/presentation/cubit/supplier_get_request_details/supplier_get_request_details_cubit.dart'
    as _i607;
import '../../features/supplier_requests/presentation/cubit/supplier_get_requests/supplier_get_requests_cubit.dart'
    as _i952;
import '../../features/supplier_requests/presentation/cubit/supplier_start_track_order/supplier_start_track_order_cubit.dart'
    as _i643;
import '../../features/supplier_returns/data/data_sources/supplier_returns_remote_data_source.dart'
    as _i716;
import '../../features/supplier_returns/data/repository/supplier_returns_repository.dart'
    as _i519;
import '../../features/supplier_returns/presentation/cubit/get_return_details/get_return_details_cubit.dart'
    as _i481;
import '../../features/supplier_returns/presentation/cubit/supplier_approve_reject_return/supplier_approve_reject_return_cubit.dart'
    as _i209;
import '../../features/supplier_returns/presentation/cubit/supplier_get_returns/supplier_get_returns_cubit.dart'
    as _i546;
import '../cubits/add_item/add_item_cubit.dart' as _i72;
import '../cubits/calendar_cubit/calendar_cubit_cubit.dart' as _i225;
import '../cubits/choose_item/choose_item_cubit.dart' as _i314;
import '../cubits/data_management/date_management/date_management_cubit.dart'
    as _i792;
import '../cubits/locale/locale_cubit.dart' as _i927;
import '../cubits/logout/logout_cubit.dart' as _i338;
import '../cubits/media/media_cubit.dart' as _i943;
import '../cubits/password/show_password_cubit.dart' as _i366;
import '../cubits/payment_method/payment_method_cubit.dart' as _i779;
import '../cubits/select_priority/select_priority_cubit.dart' as _i453;
import '../cubits/switch_button/switch_button_cubit.dart' as _i1020;
import '../cubits/theme/theme_cubit.dart' as _i93;
import '../cubits/track_order/track_order_cubit.dart' as _i117;
import '../helpers/shared_preferences_helper.dart' as _i285;
import '../services/cancel_request_service.dart' as _i16;
import '../services/download_service.dart' as _i433;
import '../services/image_picker/image_picker_service.dart' as _i818;
import '../services/navigation/request_route_observer.dart' as _i621;
import '../services/realtime_service/pusher_realtime_service.dart' as _i409;
import '../services/realtime_service/realtime_service.dart' as _i668;
import '../services/token_storage_service.dart' as _i474;
import '../strategies/user_type_strategy.dart' as _i323;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i72.AddItemCubit>(() => _i72.AddItemCubit());
    gh.factory<_i225.CalendarCubit>(() => _i225.CalendarCubit());
    gh.factory<_i314.ChooseItemCubit>(() => _i314.ChooseItemCubit());
    gh.factory<_i792.DateManagementCubit>(() => _i792.DateManagementCubit());
    gh.factory<_i338.LogoutCubit>(() => _i338.LogoutCubit());
    gh.factory<_i366.ShowPasswordCubit>(() => _i366.ShowPasswordCubit());
    gh.factory<_i779.PaymentMethodCubit>(() => _i779.PaymentMethodCubit());
    gh.factory<_i453.SelectPriorityCubit>(() => _i453.SelectPriorityCubit());
    gh.factory<_i1020.SwitchButtonCubit>(() => _i1020.SwitchButtonCubit());
    gh.factory<_i873.ExpensesFilterCubit>(() => _i873.ExpensesFilterCubit());
    gh.factory<_i734.SelectBranchManagerApproveRequestCubit>(
      () => _i734.SelectBranchManagerApproveRequestCubit(),
    );
    gh.factory<_i890.SelectBranchManagerDeliveryTimeCubit>(
      () => _i890.SelectBranchManagerDeliveryTimeCubit(),
    );
    gh.factory<_i212.BrandOwnerAssetOverviewSearchCubit>(
      () => _i212.BrandOwnerAssetOverviewSearchCubit(),
    );
    gh.factory<_i338.ChooseUserTypeCubit>(() => _i338.ChooseUserTypeCubit());
    gh.factory<_i859.SelectExportAccountStatementAsPdfCubit>(
      () => _i859.SelectExportAccountStatementAsPdfCubit(),
    );
    gh.factory<_i231.SelectFilterAccountStatementCubit>(
      () => _i231.SelectFilterAccountStatementCubit(),
    );
    gh.factory<_i36.SelectFilterCustodyRequestsCubit>(
      () => _i36.SelectFilterCustodyRequestsCubit(),
    );
    gh.factory<_i140.SelectFilterCustodyTransactionsCubit>(
      () => _i140.SelectFilterCustodyTransactionsCubit(),
    );
    gh.factory<_i324.WastedSelectedItemsCubit>(
      () => _i324.WastedSelectedItemsCubit(),
    );
    gh.factory<_i607.OnboardingCubit>(() => _i607.OnboardingCubit());
    gh.factory<_i904.AddItemPurchaseCubit>(() => _i904.AddItemPurchaseCubit());
    gh.factory<_i163.ChooseBranchCubit>(() => _i163.ChooseBranchCubit());
    gh.factory<_i517.FilterBranchesCubit>(() => _i517.FilterBranchesCubit());
    gh.factory<_i245.FilterPurchaseHistoryCubit>(
      () => _i245.FilterPurchaseHistoryCubit(),
    );
    gh.factory<_i420.FilterSuppliersCubit>(() => _i420.FilterSuppliersCubit());
    gh.factory<_i45.GetCategoriesForFilterCubit>(
      () => _i45.GetCategoriesForFilterCubit(),
    );
    gh.factory<_i914.PurchasingOfficerSelectProcessingTimeCubit>(
      () => _i914.PurchasingOfficerSelectProcessingTimeCubit(),
    );
    gh.factory<_i417.PurchasingOfficerSelectQualityCubit>(
      () => _i417.PurchasingOfficerSelectQualityCubit(),
    );
    gh.factory<_i362.SelectFilterItemCubit>(
      () => _i362.SelectFilterItemCubit(),
    );
    gh.factory<_i584.SelectFilterPurchaseHistoryCubit>(
      () => _i584.SelectFilterPurchaseHistoryCubit(),
    );
    gh.factory<_i92.CashierFilterCubit>(() => _i92.CashierFilterCubit());
    gh.factory<_i911.ChooseVarianceReasonCubit>(
      () => _i911.ChooseVarianceReasonCubit(),
    );
    gh.factory<_i526.EndShiftOptionCubit>(() => _i526.EndShiftOptionCubit());
    gh.lazySingleton<_i974.Logger>(() => appModule.logger);
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => appModule.flutterSecureStorage,
    );
    gh.lazySingleton<_i183.ImagePicker>(() => appModule.imagePicker);
    gh.lazySingleton<_i16.CancelRequestService>(
      () => appModule.cancelRequestService,
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i151.ActiveAccountRemoteDataSource>(
      () => appModule.activeAccountRemoteDataSource,
    );
    gh.lazySingleton<_i678.LoginRemoteDataSource>(
      () => appModule.loginRemoteDataSource,
    );
    gh.lazySingleton<_i655.ResetPasswordRemoteDataSource>(
      () => appModule.resetPasswordRemoteDataSource,
    );
    gh.lazySingleton<_i782.BranchManagerExpensesRemoteDataSource>(
      () => appModule.branchManagerExpensesRemoteDataSource,
    );
    gh.lazySingleton<_i572.ShiftManagementRemoteDataSource>(
      () => appModule.shiftManagementRemoteDataSource,
    );
    gh.lazySingleton<_i336.PurchaseRemoteDataSource>(
      () => appModule.purchaseRemoteDataSource,
    );
    gh.lazySingleton<_i442.RequestsRemoteDataSource>(
      () => appModule.requestsRemoteDataSource,
    );
    gh.lazySingleton<_i153.CustodyRemoteDataSource>(
      () => appModule.custodyRemoteDataSource,
    );
    gh.lazySingleton<_i144.SupplierRemoteDataSource>(
      () => appModule.supplierRemoteDataSource,
    );
    gh.lazySingleton<_i691.ReceiveGoodsRemoteDataSource>(
      () => appModule.receiveGoodsRemoteDataSource,
    );
    gh.lazySingleton<_i434.ReturnManagementRemoteDataSource>(
      () => appModule.returnManagementRemoteDataSource,
    );
    gh.lazySingleton<_i716.SupplierReturnsRemoteDataSource>(
      () => appModule.supplierReturnsRemoteDataSource,
    );
    gh.lazySingleton<_i171.InventoryRemoteDataSource>(
      () => appModule.inventoryRemoteDataSource,
    );
    gh.lazySingleton<_i395.CashierMyShiftsRemoteDataSource>(
      () => appModule.cashierMyShiftsRemoteDataSource,
    );
    gh.lazySingleton<_i189.RecurringOrderRemoteDataSource>(
      () => appModule.recurringOrderRemoteDataSource,
    );
    gh.lazySingleton<_i1013.CashierHomeRemoteDataSource>(
      () => appModule.cashierHomeRemoteDataSource,
    );
    gh.lazySingleton<_i628.FixedAssetsRemoteDataSource>(
      () => appModule.fixedAssetsRemoteDataSource,
    );
    gh.lazySingleton<_i268.BrandOwnerRequestsRemoteDataSource>(
      () => appModule.brandOwnerRequestsRemoteDataSource,
    );
    gh.lazySingleton<_i600.BrandOwnerHomeRemoteDataSource>(
      () => appModule.brandOwnerHomeRemoteDataSource,
    );
    gh.lazySingleton<_i655.BrandOwnerInventoryRemoteDataSource>(
      () => appModule.brandOwnerInventoryRemoteDataSource,
    );
    gh.lazySingleton<_i157.BrandOwnerAssetOverviewRemoteDataSource>(
      () => appModule.brandOwnerAssetOverviewRemoteDataSource,
    );
    gh.lazySingleton<_i1049.BrandOwnerReportsAndAnalyticsRemoteDataSource>(
      () => appModule.brandOwnerReportsAndAnalyticsRemoteDataSource,
    );
    gh.lazySingleton<_i825.BranchManagerPriceComparisonRemoteClient>(
      () => appModule.branchManagerPriceComparisonRemoteClient,
    );
    gh.lazySingleton<_i415.BranchManagerSettingAndAggregatorsRemoteDataSource>(
      () => appModule.branchManagerSettingAndAggregatorsRemoteDataSource,
    );
    gh.lazySingleton<_i699.BrandOwnerFixedAssetsRequestsRemoteDataSource>(
      () => appModule.brandOwnerFixedAssetsRequestsRemoteDataSource,
    );
    gh.lazySingleton<_i65.BrandOwnerProfitAndLossStatementDataSource>(
      () => appModule.brandOwnerProfitAndLossStatementDataSource,
    );
    gh.lazySingleton<_i926.BrandOwnerSalesChannelLevel2DataSource>(
      () => appModule.brandOwnerSalesChannelLevel2DataSource,
    );
    gh.lazySingleton<_i738.BrandOwnerSalesChannelAnalysisDataSource>(
      () => appModule.brandOwnerSalesChannelAnalysisDataSource,
    );
    gh.lazySingleton<_i460.BrandOwnerSmartComparisonDataSource>(
      () => appModule.brandOwnerSmartComparisonDataSource,
    );
    gh.lazySingleton<_i599.BrandOwnerProfitVsCashReconciliationDataSource>(
      () => appModule.brandOwnerProfitVsCashReconciliationDataSource,
    );
    gh.lazySingleton<_i489.BrandOwnerBreakEvenAnalysisDataSource>(
      () => appModule.brandOwnerBreakEvenAnalysisDataSource,
    );
    gh.lazySingleton<_i644.BrandOwnerOperationalProfitabilityDataSource>(
      () => appModule.brandOwnerOperationalProfitabilityDataSource,
    );
    gh.lazySingleton<_i385.BrandOwnerMenuEngineeringDataSource>(
      () => appModule.brandOwnerMenuEngineeringDataSource,
    );
    gh.lazySingleton<_i658.PriceSimulatorDataSource>(
      () => appModule.priceSimulatorDataSource,
    );
    gh.lazySingleton<_i430.ItemTestDataSource>(
      () => appModule.itemTestDataSource,
    );
    gh.lazySingleton<_i621.RequestRouteObserver>(
      () => _i621.RequestRouteObserver(),
    );
    gh.lazySingleton<_i323.UserTypeStrategy>(
      () => _i323.BranchManagerUserStrategy(),
      instanceName: 'branchManager',
    );
    gh.lazySingleton<_i244.BrandOwnerRequestsRepository>(
      () => _i244.BrandOwnerRequestsRepository(
        gh<_i268.BrandOwnerRequestsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i323.UserTypeStrategy>(
      () => _i323.CashierUserStrategy(),
      instanceName: 'cashier',
    );
    gh.lazySingleton<_i396.BrandOwnerProfitVsCashReconciliationRepository>(
      () => _i733.BrandOwnerProfitVsCashReconciliationRepositoryImpl(
        gh<_i599.BrandOwnerProfitVsCashReconciliationDataSource>(),
      ),
    );
    await gh.lazySingletonAsync<_i285.SharedPreferencesHelper>(
      () => appModule.providePrefsHelper(gh<_i974.Logger>()),
      preResolve: true,
    );
    gh.lazySingleton<_i323.UserTypeStrategy>(
      () => _i323.BrandOwnerUserStrategy(),
      instanceName: 'brandOwner',
    );
    gh.lazySingleton<_i850.ResetPasswordRepository>(
      () => _i850.ResetPasswordRepository(
        gh<_i655.ResetPasswordRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i314.BrandOwnerBreakEvenAnalysisRepository>(
      () => _i741.BrandOwnerBreakEvenAnalysisRepositoryImpl(
        gh<_i489.BrandOwnerBreakEvenAnalysisDataSource>(),
      ),
    );
    gh.lazySingleton<_i685.BrandOwnerSalesChannelLevel2Repository>(
      () => _i286.BrandOwnerSalesChannelLevel2RepositoryImpl(
        gh<_i926.BrandOwnerSalesChannelLevel2DataSource>(),
      ),
    );
    gh.lazySingleton<_i902.LoginRepository>(
      () => _i59.LoginRepositoryImpl(gh<_i678.LoginRemoteDataSource>()),
    );
    gh.lazySingleton<_i957.BranchManagerPriceComparisonRepository>(
      () => _i596.BranchManagerPriceComparisonRepositoryImpl(
        gh<_i825.BranchManagerPriceComparisonRemoteClient>(),
      ),
    );
    gh.lazySingleton<_i433.DownloadService>(
      () => _i433.DownloadService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i816.CustodyRepository>(
      () => _i816.CustodyRepository(gh<_i153.CustodyRemoteDataSource>()),
    );
    gh.lazySingleton<_i227.BrandOwnerSmartComparisonRepository>(
      () => _i523.BrandOwnerSmartComparisonRepositoryImpl(
        gh<_i460.BrandOwnerSmartComparisonDataSource>(),
      ),
    );
    gh.lazySingleton<_i336.ExportProfitVsCashReconciliationUseCase>(
      () => _i336.ExportProfitVsCashReconciliationUseCase(
        gh<_i396.BrandOwnerProfitVsCashReconciliationRepository>(),
      ),
    );
    gh.lazySingleton<_i657.GetProfitVsCashReconciliationUseCase>(
      () => _i657.GetProfitVsCashReconciliationUseCase(
        gh<_i396.BrandOwnerProfitVsCashReconciliationRepository>(),
      ),
    );
    gh.lazySingleton<_i181.ReceiveGoodsRepository>(
      () => _i181.ReceiveGoodsRepository(
        gh<_i691.ReceiveGoodsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1015.ActiveAccountRepository>(
      () => _i782.ActiveAccountRepositoryImpl(
        gh<_i151.ActiveAccountRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i667.ReturnManagementRepository>(
      () => _i667.ReturnManagementRepository(
        gh<_i434.ReturnManagementRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i323.UserTypeStrategy>(
      () => _i323.SupplierUserStrategy(),
      instanceName: 'supplier',
    );
    gh.lazySingleton<_i78.ItemTestRepository>(
      () => _i303.ItemTestRepositoryImpl(gh<_i430.ItemTestDataSource>()),
    );
    gh.lazySingleton<_i950.BrandOwnerSalesChannelAnalysisRepository>(
      () => _i693.BrandOwnerSalesChannelAnalysisRepositoryImpl(
        gh<_i738.BrandOwnerSalesChannelAnalysisDataSource>(),
      ),
    );
    gh.factory<_i523.ProfitVsCashReconciliationCubit>(
      () => _i523.ProfitVsCashReconciliationCubit(
        gh<_i657.GetProfitVsCashReconciliationUseCase>(),
      ),
    );
    gh.lazySingleton<_i450.BrandOwnerReportsAndAnalyticsRepository>(
      () => _i1069.BrandOwnerReportsAndAnalyticsRepositoryImpl(
        gh<_i1049.BrandOwnerReportsAndAnalyticsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i915.BrandOwnerAssetOverviewRepository>(
      () => _i58.BrandOwnerAssetOverviewRepositoryImpl(
        gh<_i157.BrandOwnerAssetOverviewRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i42.BrandOwnerMenuEngineeringRepository>(
      () => _i258.BrandOwnerMenuEngineeringRepositoryImpl(
        gh<_i385.BrandOwnerMenuEngineeringDataSource>(),
      ),
    );
    gh.lazySingleton<_i331.CashierHomeRepository>(
      () =>
          _i331.CashierHomeRepository(gh<_i1013.CashierHomeRemoteDataSource>()),
    );
    gh.lazySingleton<_i242.ExportMenuEngineeringUseCase>(
      () => _i242.ExportMenuEngineeringUseCase(
        gh<_i42.BrandOwnerMenuEngineeringRepository>(),
      ),
    );
    gh.lazySingleton<_i124.GetMenuEngineeringUseCase>(
      () => _i124.GetMenuEngineeringUseCase(
        gh<_i42.BrandOwnerMenuEngineeringRepository>(),
      ),
    );
    gh.lazySingleton<_i811.BrandOwnerOperationalProfitabilityRepository>(
      () => _i38.BrandOwnerOperationalProfitabilityRepositoryImpl(
        gh<_i644.BrandOwnerOperationalProfitabilityDataSource>(),
      ),
    );
    gh.factory<_i399.ExportProfitVsCashReconciliationCubit>(
      () => _i399.ExportProfitVsCashReconciliationCubit(
        gh<_i336.ExportProfitVsCashReconciliationUseCase>(),
      ),
    );
    gh.lazySingleton<_i652.BranchManagerExpensesRepository>(
      () => _i652.BranchManagerExpensesRepository(
        gh<_i782.BranchManagerExpensesRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i474.TokenStorageService>(
      () => _i474.TokenStorageService(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i695.CreateNewPasswordCubit>(
      () => _i695.CreateNewPasswordCubit(gh<_i850.ResetPasswordRepository>()),
    );
    gh.factory<_i24.SendOtpCubit>(
      () => _i24.SendOtpCubit(gh<_i850.ResetPasswordRepository>()),
    );
    gh.lazySingleton<_i471.BrandOwnerSettingsRepository>(
      () => _i1054.BrandOwnerSettingsRepositoryImpl(
        gh<_i699.BrandOwnerFixedAssetsRequestsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i181.PriceSimulatorRepository>(
      () => _i249.PriceSimulatorRepositoryImpl(
        gh<_i658.PriceSimulatorDataSource>(),
      ),
    );
    gh.lazySingleton<_i1019.BrandOwnerControlPanelRepository>(
      () => _i1043.BrandOwnerControlPanelRepositoryImpl(
        gh<_i157.BrandOwnerAssetOverviewRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i200.PurchaseRepository>(
      () => _i200.PurchaseRepository(gh<_i336.PurchaseRemoteDataSource>()),
    );
    gh.lazySingleton<_i929.BranchManagerLoginUseCase>(
      () => _i929.BranchManagerLoginUseCase(gh<_i902.LoginRepository>()),
    );
    gh.lazySingleton<_i605.BrandOwnerLoginUseCase>(
      () => _i605.BrandOwnerLoginUseCase(gh<_i902.LoginRepository>()),
    );
    gh.lazySingleton<_i244.CashierLoginUseCase>(
      () => _i244.CashierLoginUseCase(gh<_i902.LoginRepository>()),
    );
    gh.lazySingleton<_i573.SupplierLoginUseCase>(
      () => _i573.SupplierLoginUseCase(gh<_i902.LoginRepository>()),
    );
    gh.lazySingleton<_i365.BrandOwnerHomeRepository>(
      () => _i365.BrandOwnerHomeRepository(
        gh<_i600.BrandOwnerHomeRemoteDataSource>(),
      ),
    );
    gh.factory<_i971.StartReceiveOrderCubit>(
      () => _i971.StartReceiveOrderCubit(gh<_i181.ReceiveGoodsRepository>()),
    );
    gh.lazySingleton<_i519.SupplierReturnsRepository>(
      () => _i519.SupplierReturnsRepository(
        gh<_i716.SupplierReturnsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i534.CashierMyShiftsRepo>(
      () => _i534.CashierMyShiftsRepo(
        gh<_i395.CashierMyShiftsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i850.GetBrandOwnerSettingApprovalUseCase>(
      () => _i850.GetBrandOwnerSettingApprovalUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.GetBrandOwnerReportSettingsUseCase>(
      () => _i850.GetBrandOwnerReportSettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.GetBrandOwnerSecuritySettingsUseCase>(
      () => _i850.GetBrandOwnerSecuritySettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.GetBrandOwnerRetentionSettingsUseCase>(
      () => _i850.GetBrandOwnerRetentionSettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.GetBrandOwnerNotificationsSettingsUseCase>(
      () => _i850.GetBrandOwnerNotificationsSettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.UpdateBrandOwnerSettingApprovalUseCase>(
      () => _i850.UpdateBrandOwnerSettingApprovalUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.UpdateBrandOwnerReportSettingsUseCase>(
      () => _i850.UpdateBrandOwnerReportSettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.UpdateBrandOwnerSecuritySettingsUseCase>(
      () => _i850.UpdateBrandOwnerSecuritySettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.UpdateBrandOwnerRetentionSettingsUseCase>(
      () => _i850.UpdateBrandOwnerRetentionSettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i850.UpdateBrandOwnerNotificationsSettingsUseCase>(
      () => _i850.UpdateBrandOwnerNotificationsSettingsUseCase(
        gh<_i471.BrandOwnerSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i301.BrandOwnerProfitAndLossStatementRepository>(
      () => _i891.BrandOwnerProfitAndLossStatementRepositoryImpl(
        gh<_i65.BrandOwnerProfitAndLossStatementDataSource>(),
      ),
    );
    gh.lazySingleton<_i79.BrandOwnerInventoryManagementRepository>(
      () => _i79.BrandOwnerInventoryManagementRepository(
        gh<_i655.BrandOwnerInventoryRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i452.GetBrandOwnerControlPanelUseCase>(
      () => _i452.GetBrandOwnerControlPanelUseCase(
        gh<_i1019.BrandOwnerControlPanelRepository>(),
      ),
    );
    gh.lazySingleton<_i893.FirstLoginUseCase>(
      () => _i893.FirstLoginUseCase(gh<_i1015.ActiveAccountRepository>()),
    );
    gh.lazySingleton<_i539.ResetPasswordFirstLoginUseCase>(
      () => _i539.ResetPasswordFirstLoginUseCase(
        gh<_i1015.ActiveAccountRepository>(),
      ),
    );
    gh.factory<_i853.ExportMenuEngineeringCubit>(
      () => _i853.ExportMenuEngineeringCubit(
        gh<_i242.ExportMenuEngineeringUseCase>(),
      ),
    );
    gh.lazySingleton<_i949.BrandOwnerFixedAssetsRequestsRepository>(
      () => _i896.BrandOwnerFixedAssetsRequestsRepositoryImpl(
        gh<_i699.BrandOwnerFixedAssetsRequestsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i818.ImagePickerService>(
      () => _i818.ImagePickerService(gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i444.EmailItemTestUseCase>(
      () => _i444.EmailItemTestUseCase(gh<_i78.ItemTestRepository>()),
    );
    gh.lazySingleton<_i355.ExportItemTestUseCase>(
      () => _i355.ExportItemTestUseCase(gh<_i78.ItemTestRepository>()),
    );
    gh.lazySingleton<_i214.GetSavedItemTestsUseCase>(
      () => _i214.GetSavedItemTestsUseCase(gh<_i78.ItemTestRepository>()),
    );
    gh.lazySingleton<_i1039.SaveItemTestUseCase>(
      () => _i1039.SaveItemTestUseCase(gh<_i78.ItemTestRepository>()),
    );
    gh.lazySingleton<_i860.SubmitItemTestUseCase>(
      () => _i860.SubmitItemTestUseCase(gh<_i78.ItemTestRepository>()),
    );
    gh.lazySingleton<_i430.ShiftManagementRepositoryImp>(
      () => _i430.ShiftManagementRepositoryImp(
        gh<_i572.ShiftManagementRemoteDataSource>(),
      ),
    );
    gh.factoryParam<_i156.HandoverCubit, String, dynamic>(
      (shiftId, _) => _i156.HandoverCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
        shiftId,
      ),
    );
    gh.factory<_i982.VerifyOtpBloc>(
      () => _i982.VerifyOtpBloc(gh<_i850.ResetPasswordRepository>()),
    );
    gh.factory<_i119.BrandOwnerPaymentLogCubit>(
      () => _i119.BrandOwnerPaymentLogCubit(
        gh<_i244.BrandOwnerRequestsRepository>(),
      ),
    );
    gh.factory<_i1064.BrandOwnerRequestsCustodySalesTransfersCubit>(
      () => _i1064.BrandOwnerRequestsCustodySalesTransfersCubit(
        gh<_i244.BrandOwnerRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i973.RecurringOrderRepository>(
      () => _i973.RecurringOrderRepository(
        gh<_i189.RecurringOrderRemoteDataSource>(),
      ),
    );
    gh.factory<_i530.CreateHandoverToCashierCubit>(
      () => _i530.CreateHandoverToCashierCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i467.CustodyCreateRequestCubit>(
      () => _i467.CustodyCreateRequestCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i551.CustodyGetPersonalBalanceOnlyCubit>(
      () => _i551.CustodyGetPersonalBalanceOnlyCubit(
        gh<_i816.CustodyRepository>(),
      ),
    );
    gh.factory<_i784.CustodyGetRequetsCubit>(
      () => _i784.CustodyGetRequetsCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i608.ExportPersonalBalanceAsPdfCubit>(
      () =>
          _i608.ExportPersonalBalanceAsPdfCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i980.GetBranchBalanceCubit>(
      () => _i980.GetBranchBalanceCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i690.GetBranchBalanceTransactionsCubit>(
      () => _i690.GetBranchBalanceTransactionsCubit(
        gh<_i816.CustodyRepository>(),
      ),
    );
    gh.factory<_i326.GetCustodyDetailsCubit>(
      () => _i326.GetCustodyDetailsCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i534.GetCustodyRecipientsCubit>(
      () => _i534.GetCustodyRecipientsCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i386.GetCustodyTrendStateCubit>(
      () => _i386.GetCustodyTrendStateCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i354.GetPersonalBalanceCubit>(
      () => _i354.GetPersonalBalanceCubit(gh<_i816.CustodyRepository>()),
    );
    gh.factory<_i1015.GetPersonalBalanceTransactionsCubit>(
      () => _i1015.GetPersonalBalanceTransactionsCubit(
        gh<_i816.CustodyRepository>(),
      ),
    );
    gh.lazySingleton<_i507.SupplierRequestsRepository>(
      () => _i507.SupplierRequestsRepository(
        gh<_i144.SupplierRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i77.ExportBreakEvenAnalysisUseCase>(
      () => _i77.ExportBreakEvenAnalysisUseCase(
        gh<_i314.BrandOwnerBreakEvenAnalysisRepository>(),
      ),
    );
    gh.lazySingleton<_i265.GetBreakEvenAnalysisUseCase>(
      () => _i265.GetBreakEvenAnalysisUseCase(
        gh<_i314.BrandOwnerBreakEvenAnalysisRepository>(),
      ),
    );
    gh.factory<_i630.GetReceiveOrderInspectionCubit>(
      () => _i630.GetReceiveOrderInspectionCubit(
        gh<_i181.ReceiveGoodsRepository>(),
      ),
    );
    gh.factory<_i601.GetReceivingOrdersCubit>(
      () => _i601.GetReceivingOrdersCubit(gh<_i181.ReceiveGoodsRepository>()),
    );
    gh.factory<_i79.BranchManagerCreateOrderWithRecommendedSourceCubit>(
      () => _i79.BranchManagerCreateOrderWithRecommendedSourceCubit(
        gh<_i957.BranchManagerPriceComparisonRepository>(),
      ),
    );
    gh.factory<_i503.BranchManagerExportPriceComparisonCubit>(
      () => _i503.BranchManagerExportPriceComparisonCubit(
        gh<_i957.BranchManagerPriceComparisonRepository>(),
      ),
    );
    gh.factory<_i816.BranchManagerPriceComparisonCubit>(
      () => _i816.BranchManagerPriceComparisonCubit(
        gh<_i957.BranchManagerPriceComparisonRepository>(),
      ),
    );
    gh.factory<_i919.BranchManagerPriceComparisonDetailsCubit>(
      () => _i919.BranchManagerPriceComparisonDetailsCubit(
        gh<_i957.BranchManagerPriceComparisonRepository>(),
      ),
    );
    gh.lazySingleton<_i996.BranchManagerResetMyPasswordRepository>(
      () => _i418.BranchManagerResetMyPasswordRepositoryImpl(
        gh<_i415.BranchManagerSettingAndAggregatorsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i38.RequestsRepository>(
      () => _i38.RequestsRepository(
        remoteDataSource: gh<_i442.RequestsRemoteDataSource>(),
      ),
    );
    gh.factory<_i866.CashierMyShiftsCubit>(
      () => _i866.CashierMyShiftsCubit(gh<_i534.CashierMyShiftsRepo>()),
    );
    gh.factory<_i1004.ReassignedShiftActionsCubit>(
      () => _i1004.ReassignedShiftActionsCubit(gh<_i534.CashierMyShiftsRepo>()),
    );
    gh.lazySingleton<_i542.BranchManagerSettingAndAggregatorsRepository>(
      () => _i799.BranchManagerSettingAndAggregatorsRepositoryImpl(
        gh<_i415.BranchManagerSettingAndAggregatorsRemoteDataSource>(),
      ),
    );
    gh.factory<_i1004.GetBranchInfoCubit>(
      () => _i1004.GetBranchInfoCubit(gh<_i331.CashierHomeRepository>()),
    );
    gh.factory<_i991.GetCashierInfoCubit>(
      () => _i991.GetCashierInfoCubit(gh<_i331.CashierHomeRepository>()),
    );
    gh.factory<_i172.GetTasksCubit>(
      () => _i172.GetTasksCubit(gh<_i331.CashierHomeRepository>()),
    );
    gh.lazySingleton<_i261.ExportSalesChannelLevel2UseCase>(
      () => _i261.ExportSalesChannelLevel2UseCase(
        gh<_i685.BrandOwnerSalesChannelLevel2Repository>(),
      ),
    );
    gh.lazySingleton<_i518.GetSalesChannelLevel2UseCase>(
      () => _i518.GetSalesChannelLevel2UseCase(
        gh<_i685.BrandOwnerSalesChannelLevel2Repository>(),
      ),
    );
    gh.factory<_i416.CreateRecurringOrderCubit>(
      () =>
          _i416.CreateRecurringOrderCubit(gh<_i973.RecurringOrderRepository>()),
    );
    gh.factory<_i142.GetInProgressRecurringOrdersCubit>(
      () => _i142.GetInProgressRecurringOrdersCubit(
        gh<_i973.RecurringOrderRepository>(),
      ),
    );
    gh.factory<_i942.GetNextScheduledRecurringOrdersCubit>(
      () => _i942.GetNextScheduledRecurringOrdersCubit(
        gh<_i973.RecurringOrderRepository>(),
      ),
    );
    gh.factory<_i251.GetPausedRecurringOrdersCubit>(
      () => _i251.GetPausedRecurringOrdersCubit(
        gh<_i973.RecurringOrderRepository>(),
      ),
    );
    gh.factory<_i186.GetRecurringOrderDetailsCubit>(
      () => _i186.GetRecurringOrderDetailsCubit(
        gh<_i973.RecurringOrderRepository>(),
      ),
    );
    gh.factory<_i263.RecurringOrderActionsCubit>(
      () => _i263.RecurringOrderActionsCubit(
        gh<_i973.RecurringOrderRepository>(),
      ),
    );
    gh.lazySingleton<_i651.ExportSmartComparisonUseCase>(
      () => _i651.ExportSmartComparisonUseCase(
        gh<_i227.BrandOwnerSmartComparisonRepository>(),
      ),
    );
    gh.lazySingleton<_i210.GetSmartComparisonUseCase>(
      () => _i210.GetSmartComparisonUseCase(
        gh<_i227.BrandOwnerSmartComparisonRepository>(),
      ),
    );
    gh.factoryParam<_i1053.EndShiftCubit, String, _i136.ShiftEntity?>(
      (shiftId, shift) => _i1053.EndShiftCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
        shiftId,
        shift,
      ),
    );
    gh.factory<_i481.SupplierGetReturnDetailsCubit>(
      () => _i481.SupplierGetReturnDetailsCubit(
        gh<_i519.SupplierReturnsRepository>(),
      ),
    );
    gh.factory<_i209.SupplierApproveRejectReturnCubit>(
      () => _i209.SupplierApproveRejectReturnCubit(
        gh<_i519.SupplierReturnsRepository>(),
      ),
    );
    gh.factory<_i546.SupplierGetReturnsCubit>(
      () =>
          _i546.SupplierGetReturnsCubit(gh<_i519.SupplierReturnsRepository>()),
    );
    gh.lazySingleton<_i737.EmailScenarioUseCase>(
      () => _i737.EmailScenarioUseCase(gh<_i181.PriceSimulatorRepository>()),
    );
    gh.lazySingleton<_i722.ExportScenarioUseCase>(
      () => _i722.ExportScenarioUseCase(gh<_i181.PriceSimulatorRepository>()),
    );
    gh.lazySingleton<_i893.GetPriceSimulatorItemInfoUseCase>(
      () => _i893.GetPriceSimulatorItemInfoUseCase(
        gh<_i181.PriceSimulatorRepository>(),
      ),
    );
    gh.lazySingleton<_i831.GetPriceSimulatorItemsUseCase>(
      () => _i831.GetPriceSimulatorItemsUseCase(
        gh<_i181.PriceSimulatorRepository>(),
      ),
    );
    gh.lazySingleton<_i983.GetSavedScenariosUseCase>(
      () =>
          _i983.GetSavedScenariosUseCase(gh<_i181.PriceSimulatorRepository>()),
    );
    gh.lazySingleton<_i898.SaveScenarioUseCase>(
      () => _i898.SaveScenarioUseCase(gh<_i181.PriceSimulatorRepository>()),
    );
    gh.lazySingleton<_i3.SubmitPriceSimulationUseCase>(
      () => _i3.SubmitPriceSimulationUseCase(
        gh<_i181.PriceSimulatorRepository>(),
      ),
    );
    gh.factory<_i117.TrackOrderCubit>(
      () => _i117.TrackOrderCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i963.ApproveOrRejectOrderCubit>(
      () => _i963.ApproveOrRejectOrderCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i1026.ApproveOrRejectResponsibilityCubit>(
      () => _i1026.ApproveOrRejectResponsibilityCubit(
        gh<_i38.RequestsRepository>(),
      ),
    );
    gh.factory<_i924.BranchApproveOrRejectModificationCubit>(
      () => _i924.BranchApproveOrRejectModificationCubit(
        gh<_i38.RequestsRepository>(),
      ),
    );
    gh.factory<_i693.BranchCancelItemCubit>(
      () => _i693.BranchCancelItemCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i393.BranchGetCancelReasonCubit>(
      () => _i393.BranchGetCancelReasonCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i671.BranchGetModificationCubit>(
      () => _i671.BranchGetModificationCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i109.GetHandoversCubit>(
      () => _i109.GetHandoversCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i921.GetOrderDetailsCubit>(
      () => _i921.GetOrderDetailsCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i838.GetOrdersCubit>(
      () => _i838.GetOrdersCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i479.GetResponsibilityDetailsCubit>(
      () => _i479.GetResponsibilityDetailsCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i758.GetVariancesCubit>(
      () => _i758.GetVariancesCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i704.RejectApproveDelayCubit>(
      () => _i704.RejectApproveDelayCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i884.GetReassignedShiftsCubit>(
      () => _i884.GetReassignedShiftsCubit(gh<_i38.RequestsRepository>()),
    );
    gh.lazySingleton<_i927.LocaleCubit>(
      () => _i927.LocaleCubit(gh<_i285.SharedPreferencesHelper>()),
    );
    gh.singleton<_i93.ThemeCubit>(
      () => _i93.ThemeCubit(gh<_i285.SharedPreferencesHelper>()),
    );
    gh.lazySingleton<_i903.GetCategoriesUseCase>(
      () => _i903.GetCategoriesUseCase(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i67.BranchManagerExpensesCubit>(
      () => _i67.BranchManagerExpensesCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i450.BranchManagerExpensesHistoryCubit>(
      () => _i450.BranchManagerExpensesHistoryCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i878.CreateExpensePreviousRequestCubit>(
      () => _i878.CreateExpensePreviousRequestCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i730.ExpenseDetailsCubit>(
      () => _i730.ExpenseDetailsCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i145.ExpensesGetCustodyBalanceCubit>(
      () => _i145.ExpensesGetCustodyBalanceCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i986.ExpensesSearchCubit>(
      () => _i986.ExpensesSearchCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i289.GroupedInvoiceCubit>(
      () => _i289.GroupedInvoiceCubit(
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i847.PreApprovalCubit>(
      () => _i847.PreApprovalCubit(gh<_i652.BranchManagerExpensesRepository>()),
    );
    gh.factory<_i1026.QuickCashCubit>(
      () => _i1026.QuickCashCubit(gh<_i652.BranchManagerExpensesRepository>()),
    );
    gh.factory<_i705.SingleExpenseCubit>(
      () =>
          _i705.SingleExpenseCubit(gh<_i652.BranchManagerExpensesRepository>()),
    );
    gh.factory<_i749.SuppliersCubit>(
      () => _i749.SuppliersCubit(gh<_i652.BranchManagerExpensesRepository>()),
    );
    gh.factory<_i633.ItemTestSavedTestsCubit>(
      () => _i633.ItemTestSavedTestsCubit(gh<_i214.GetSavedItemTestsUseCase>()),
    );
    gh.factoryParam<_i54.ShiftDetailsCubit, String, bool>(
      (shiftId, isCashier) => _i54.ShiftDetailsCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
        shiftId,
        isCashier,
      ),
    );
    gh.factory<_i1034.BrandOwnerNotificationsCubit>(
      () => _i1034.BrandOwnerNotificationsCubit(
        gh<_i850.GetBrandOwnerNotificationsSettingsUseCase>(),
        gh<_i850.UpdateBrandOwnerNotificationsSettingsUseCase>(),
      ),
    );
    gh.factory<_i272.ItemTestSavedTestDetailsCubit>(
      () => _i272.ItemTestSavedTestDetailsCubit(
        gh<_i355.ExportItemTestUseCase>(),
        gh<_i444.EmailItemTestUseCase>(),
      ),
    );
    gh.factory<_i276.PriceSimulatorScreenCubit>(
      () => _i276.PriceSimulatorScreenCubit(
        gh<_i893.GetPriceSimulatorItemInfoUseCase>(),
        gh<_i3.SubmitPriceSimulationUseCase>(),
      ),
    );
    gh.factory<_i842.BranchOwnerApproveRejectCubit>(
      () => _i842.BranchOwnerApproveRejectCubit(
        gh<_i244.BrandOwnerRequestsRepository>(),
        gh<_i365.BrandOwnerHomeRepository>(),
      ),
    );
    gh.factory<_i10.GetCashierCubit>(
      () => _i10.GetCashierCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.lazySingleton<_i1009.GetBrandOwnerExpenseReportDetailsUseCase>(
      () => _i1009.GetBrandOwnerExpenseReportDetailsUseCase(
        gh<_i450.BrandOwnerReportsAndAnalyticsRepository>(),
      ),
    );
    gh.lazySingleton<_i379.GetBrandOwnerReportsAndAnalyticsUseCase>(
      () => _i379.GetBrandOwnerReportsAndAnalyticsUseCase(
        gh<_i450.BrandOwnerReportsAndAnalyticsRepository>(),
      ),
    );
    gh.lazySingleton<_i560.GetCustodyReportDetailsUseCase>(
      () => _i560.GetCustodyReportDetailsUseCase(
        gh<_i450.BrandOwnerReportsAndAnalyticsRepository>(),
      ),
    );
    gh.factory<_i630.ExportCustodyReportCubit>(
      () => _i630.ExportCustodyReportCubit(
        gh<_i450.BrandOwnerReportsAndAnalyticsRepository>(),
      ),
    );
    gh.factory<_i68.ExportExpenseReportCubit>(
      () => _i68.ExportExpenseReportCubit(
        gh<_i450.BrandOwnerReportsAndAnalyticsRepository>(),
      ),
    );
    gh.lazySingleton<_i668.RealtimeService>(
      () => _i409.PusherRealtimeService(
        tokenStorageService: gh<_i474.TokenStorageService>(),
        dio: gh<_i361.Dio>(),
      ),
    );
    gh.factory<_i711.BrandOwnerBranchesCubit>(
      () => _i711.BrandOwnerBranchesCubit(gh<_i365.BrandOwnerHomeRepository>()),
    );
    gh.factory<_i552.BrandOwnerHomeCubit>(
      () => _i552.BrandOwnerHomeCubit(gh<_i365.BrandOwnerHomeRepository>()),
    );
    gh.factory<_i952.CategoriesCubit>(
      () => _i952.CategoriesCubit(
        gh<_i903.GetCategoriesUseCase>(),
        gh<_i652.BranchManagerExpensesRepository>(),
      ),
    );
    gh.factory<_i562.GetCompletedEscelationsCubit>(
      () => _i562.GetCompletedEscelationsCubit(
        gh<_i667.ReturnManagementRepository>(),
      ),
    );
    gh.factory<_i3.GetPendingEscelationsCubit>(
      () => _i3.GetPendingEscelationsCubit(
        gh<_i667.ReturnManagementRepository>(),
      ),
    );
    gh.factory<_i952.AcceptEscalateReturnRejectionCubit>(
      () => _i952.AcceptEscalateReturnRejectionCubit(
        gh<_i667.ReturnManagementRepository>(),
      ),
    );
    gh.factory<_i684.CreateReturnCubit>(
      () => _i684.CreateReturnCubit(gh<_i667.ReturnManagementRepository>()),
    );
    gh.factory<_i349.GetReturnDetailsCubit>(
      () => _i349.GetReturnDetailsCubit(gh<_i667.ReturnManagementRepository>()),
    );
    gh.factory<_i531.GetReturnsCubit>(
      () => _i531.GetReturnsCubit(gh<_i667.ReturnManagementRepository>()),
    );
    gh.factory<_i545.MenuEngineeringCubit>(
      () => _i545.MenuEngineeringCubit(gh<_i124.GetMenuEngineeringUseCase>()),
    );
    gh.factory<_i184.PriceSimulatorScenarioDetailsCubit>(
      () => _i184.PriceSimulatorScenarioDetailsCubit(
        gh<_i722.ExportScenarioUseCase>(),
        gh<_i737.EmailScenarioUseCase>(),
      ),
    );
    gh.factory<_i570.SalesChannelLevel2Cubit>(
      () => _i570.SalesChannelLevel2Cubit(
        gh<_i518.GetSalesChannelLevel2UseCase>(),
      ),
    );
    gh.lazySingleton<_i918.ExportBrandOwnerAssetOverviewReportUseCase>(
      () => _i918.ExportBrandOwnerAssetOverviewReportUseCase(
        gh<_i915.BrandOwnerAssetOverviewRepository>(),
      ),
    );
    gh.lazySingleton<_i390.GetBrandOwnerAssetOverviewBranchDetailsUseCase>(
      () => _i390.GetBrandOwnerAssetOverviewBranchDetailsUseCase(
        gh<_i915.BrandOwnerAssetOverviewRepository>(),
      ),
    );
    gh.lazySingleton<
      _i1048.GetBrandOwnerAssetOverviewPerformanceSummaryUseCase
    >(
      () => _i1048.GetBrandOwnerAssetOverviewPerformanceSummaryUseCase(
        gh<_i915.BrandOwnerAssetOverviewRepository>(),
      ),
    );
    gh.lazySingleton<_i845.GetBrandOwnerAssetOverviewUseCase>(
      () => _i845.GetBrandOwnerAssetOverviewUseCase(
        gh<_i915.BrandOwnerAssetOverviewRepository>(),
      ),
    );
    gh.factory<_i104.BrandOwnerSettingApprovalCubit>(
      () => _i104.BrandOwnerSettingApprovalCubit(
        gh<_i850.GetBrandOwnerSettingApprovalUseCase>(),
        gh<_i850.UpdateBrandOwnerSettingApprovalUseCase>(),
      ),
    );
    gh.factory<_i41.BrandOwnerPaymentCubit>(
      () => _i41.BrandOwnerPaymentCubit(gh<_i365.BrandOwnerHomeRepository>()),
    );
    gh.factory<_i240.BrandOwnerAssetOverviewExportCubit>(
      () => _i240.BrandOwnerAssetOverviewExportCubit(
        gh<_i918.ExportBrandOwnerAssetOverviewReportUseCase>(),
      ),
    );
    gh.factory<_i944.ActiveAccountCubit>(
      () => _i944.ActiveAccountCubit(
        gh<_i893.FirstLoginUseCase>(),
        gh<_i539.ResetPasswordFirstLoginUseCase>(),
      ),
    );
    gh.factoryParam<_i1015.CashierShiftsManagementCubit, String, dynamic>(
      (cashierId, _) => _i1015.CashierShiftsManagementCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
        cashierId,
      ),
    );
    gh.factory<_i942.ComparePriceCubit>(
      () => _i942.ComparePriceCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i212.CreatePurchaseOrderCubit>(
      () => _i212.CreatePurchaseOrderCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i83.DeleteOrderDraftCubit>(
      () => _i83.DeleteOrderDraftCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i51.GetPurchaseBranchItemsCubit>(
      () => _i51.GetPurchaseBranchItemsCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i811.GetPurchaseBranchesCubit>(
      () => _i811.GetPurchaseBranchesCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i873.GetPurchaseProductsBranchDetailsCubit>(
      () => _i873.GetPurchaseProductsBranchDetailsCubit(
        gh<_i200.PurchaseRepository>(),
      ),
    );
    gh.factory<_i1006.GetPurchaseProductsOfficerDetailsCubit>(
      () => _i1006.GetPurchaseProductsOfficerDetailsCubit(
        gh<_i200.PurchaseRepository>(),
      ),
    );
    gh.factory<_i994.GetPurchaseProductsSupplierDetailsCubit>(
      () => _i994.GetPurchaseProductsSupplierDetailsCubit(
        gh<_i200.PurchaseRepository>(),
      ),
    );
    gh.factory<_i317.GetPurchaseSuppliersCubit>(
      () => _i317.GetPurchaseSuppliersCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i492.GetSuppliersForFilterCubit>(
      () => _i492.GetSuppliersForFilterCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i332.PurchaseHistoryCubit>(
      () => _i332.PurchaseHistoryCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i864.SaveComparePriceCubit>(
      () => _i864.SaveComparePriceCubit(gh<_i200.PurchaseRepository>()),
    );
    gh.factory<_i706.BrandOwnerSecuritySettingCubit>(
      () => _i706.BrandOwnerSecuritySettingCubit(
        gh<_i850.GetBrandOwnerSecuritySettingsUseCase>(),
        gh<_i850.UpdateBrandOwnerSecuritySettingsUseCase>(),
      ),
    );
    gh.lazySingleton<_i415.GetBranchManagerMyAccountDetailsUseCase>(
      () => _i415.GetBranchManagerMyAccountDetailsUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.GetBranchManagerSettingAndAggregatorsUseCase>(
      () => _i415.GetBranchManagerSettingAndAggregatorsUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.GetAvailableAggregatorsUseCase>(
      () => _i415.GetAvailableAggregatorsUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.GetBranchAggregatorsUseCase>(
      () => _i415.GetBranchAggregatorsUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.AddBranchManagerAggregatorUseCase>(
      () => _i415.AddBranchManagerAggregatorUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.DeleteBranchManagerAggregatorUseCase>(
      () => _i415.DeleteBranchManagerAggregatorUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.SetBranchManagerAggregatorStatusUseCase>(
      () => _i415.SetBranchManagerAggregatorStatusUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.lazySingleton<_i415.UpdateBranchManagerNotificationUseCase>(
      () => _i415.UpdateBranchManagerNotificationUseCase(
        gh<_i542.BranchManagerSettingAndAggregatorsRepository>(),
      ),
    );
    gh.factory<_i745.BrandOwnerRetentionSettingsCubit>(
      () => _i745.BrandOwnerRetentionSettingsCubit(
        gh<_i850.GetBrandOwnerRetentionSettingsUseCase>(),
        gh<_i850.UpdateBrandOwnerRetentionSettingsUseCase>(),
      ),
    );
    gh.lazySingleton<_i1012.ApproveBrandOwnerDailyInventoryUseCase>(
      () => _i1012.ApproveBrandOwnerDailyInventoryUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i861.ApproveBrandOwnerWastAndDamageUseCase>(
      () => _i861.ApproveBrandOwnerWastAndDamageUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i987.GetBrandOwnerDailyInventoryDetailsUseCase>(
      () => _i987.GetBrandOwnerDailyInventoryDetailsUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i752.GetBrandOwnerDailyInventoryRequestsUseCase>(
      () => _i752.GetBrandOwnerDailyInventoryRequestsUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i4.GetBrandOwnerWastAndDamageDetailsUseCase>(
      () => _i4.GetBrandOwnerWastAndDamageDetailsUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i452.GetBrandOwnerWastAndDamageRequestsUseCase>(
      () => _i452.GetBrandOwnerWastAndDamageRequestsUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i291.RejectBrandOwnerDailyInventoryUseCase>(
      () => _i291.RejectBrandOwnerDailyInventoryUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i419.RejectBrandOwnerWastAndDamageUseCase>(
      () => _i419.RejectBrandOwnerWastAndDamageUseCase(
        gh<_i79.BrandOwnerInventoryManagementRepository>(),
      ),
    );
    gh.lazySingleton<_i988.ExportSalesChannelAnalysisUseCase>(
      () => _i988.ExportSalesChannelAnalysisUseCase(
        gh<_i950.BrandOwnerSalesChannelAnalysisRepository>(),
      ),
    );
    gh.lazySingleton<_i1037.GetSalesChannelAnalysisUseCase>(
      () => _i1037.GetSalesChannelAnalysisUseCase(
        gh<_i950.BrandOwnerSalesChannelAnalysisRepository>(),
      ),
    );
    gh.factory<_i546.BrandOwnerExpenseReportDetailsCubit>(
      () => _i546.BrandOwnerExpenseReportDetailsCubit(
        gh<_i1009.GetBrandOwnerExpenseReportDetailsUseCase>(),
      ),
    );
    gh.factory<_i497.ItemTestScreenCubit>(
      () => _i497.ItemTestScreenCubit(gh<_i860.SubmitItemTestUseCase>()),
    );
    gh.factory<_i197.ItemTestSaveResultCubit>(
      () => _i197.ItemTestSaveResultCubit(gh<_i1039.SaveItemTestUseCase>()),
    );
    gh.lazySingleton<_i117.InventoryRepository>(
      () => _i117.InventoryRepository(
        gh<_i171.InventoryRemoteDataSource>(),
        gh<_i668.RealtimeService>(),
      ),
    );
    gh.factory<_i61.BrandOwnerAssetOverviewBranchDetailsCubit>(
      () => _i61.BrandOwnerAssetOverviewBranchDetailsCubit(
        gh<_i390.GetBrandOwnerAssetOverviewBranchDetailsUseCase>(),
      ),
    );
    gh.factory<_i49.ExportBreakEvenAnalysisCubit>(
      () => _i49.ExportBreakEvenAnalysisCubit(
        gh<_i77.ExportBreakEvenAnalysisUseCase>(),
      ),
    );
    gh.factory<_i308.BrandOwnerReportSettingsCubit>(
      () => _i308.BrandOwnerReportSettingsCubit(
        gh<_i850.GetBrandOwnerReportSettingsUseCase>(),
        gh<_i850.UpdateBrandOwnerReportSettingsUseCase>(),
      ),
    );
    gh.factoryParam<
      _i590.ReassignShiftCubit,
      _i760.ReassignShiftParams,
      dynamic
    >(
      (params, _) => _i590.ReassignShiftCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
        params,
      ),
    );
    gh.factory<_i545.BrandOwnerCustodyReportDetailsCubit>(
      () => _i545.BrandOwnerCustodyReportDetailsCubit(
        gh<_i560.GetCustodyReportDetailsUseCase>(),
      ),
    );
    gh.factory<_i545.LoginCubit>(
      () => _i545.LoginCubit(
        gh<_i929.BranchManagerLoginUseCase>(),
        gh<_i573.SupplierLoginUseCase>(),
        gh<_i244.CashierLoginUseCase>(),
        gh<_i605.BrandOwnerLoginUseCase>(),
      ),
    );
    gh.factory<_i761.AddCashierCubit>(
      () => _i761.AddCashierCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.factory<_i254.CashierManagementCubit>(
      () => _i254.CashierManagementCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
      ),
    );
    gh.factory<_i794.StartCashierShiftCubit>(
      () => _i794.StartCashierShiftCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
      ),
    );
    gh.factory<_i123.AggregatorCubit>(
      () => _i123.AggregatorCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.factory<_i628.FetchManagerCubit>(
      () => _i628.FetchManagerCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.lazySingleton<_i785.ExportOperationalProfitabilityUseCase>(
      () => _i785.ExportOperationalProfitabilityUseCase(
        gh<_i811.BrandOwnerOperationalProfitabilityRepository>(),
      ),
    );
    gh.lazySingleton<_i920.GetOperationalProfitabilityUseCase>(
      () => _i920.GetOperationalProfitabilityUseCase(
        gh<_i811.BrandOwnerOperationalProfitabilityRepository>(),
      ),
    );
    gh.factory<_i765.BreakEvenAnalysisCubit>(
      () =>
          _i765.BreakEvenAnalysisCubit(gh<_i265.GetBreakEvenAnalysisUseCase>()),
    );
    gh.factory<_i35.ManagerShiftCubit>(
      () => _i35.ManagerShiftCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.factory<_i187.ApproveAndRejectHandoverCubit>(
      () => _i187.ApproveAndRejectHandoverCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
      ),
    );
    gh.factory<_i710.ExportSalesChannelAnalysisCubit>(
      () => _i710.ExportSalesChannelAnalysisCubit(
        gh<_i988.ExportSalesChannelAnalysisUseCase>(),
      ),
    );
    gh.factory<_i114.BrandOwnerControlPanelCubit>(
      () => _i114.BrandOwnerControlPanelCubit(
        gh<_i452.GetBrandOwnerControlPanelUseCase>(),
      ),
    );
    gh.factory<_i399.BrandOwnerAssetOverviewPerformanceSummaryCubit>(
      () => _i399.BrandOwnerAssetOverviewPerformanceSummaryCubit(
        gh<_i1048.GetBrandOwnerAssetOverviewPerformanceSummaryUseCase>(),
      ),
    );
    gh.factory<_i943.MediaCubit>(
      () => _i943.MediaCubit(gh<_i818.ImagePickerService>()),
    );
    gh.lazySingleton<_i155.BranchManagerResetMyPasswordUseCase>(
      () => _i155.BranchManagerResetMyPasswordUseCase(
        gh<_i996.BranchManagerResetMyPasswordRepository>(),
      ),
    );
    gh.factory<_i379.BranchManagerMyAccountDetailsCubit>(
      () => _i379.BranchManagerMyAccountDetailsCubit(
        gh<_i415.GetBranchManagerMyAccountDetailsUseCase>(),
      ),
    );
    gh.lazySingleton<_i952.ExportProfitAndLossStatementUseCase>(
      () => _i952.ExportProfitAndLossStatementUseCase(
        gh<_i301.BrandOwnerProfitAndLossStatementRepository>(),
      ),
    );
    gh.lazySingleton<_i482.GetBranchesForFilterUseCase>(
      () => _i482.GetBranchesForFilterUseCase(
        gh<_i301.BrandOwnerProfitAndLossStatementRepository>(),
      ),
    );
    gh.lazySingleton<_i901.GetProfitAndLossStatementUseCase>(
      () => _i901.GetProfitAndLossStatementUseCase(
        gh<_i301.BrandOwnerProfitAndLossStatementRepository>(),
      ),
    );
    gh.factory<_i993.PriceSimulatorSavedScenariosCubit>(
      () => _i993.PriceSimulatorSavedScenariosCubit(
        gh<_i983.GetSavedScenariosUseCase>(),
      ),
    );
    gh.factory<_i543.GetSupplierItemsCubit>(
      () => _i543.GetSupplierItemsCubit(gh<_i507.SupplierRequestsRepository>()),
    );
    gh.factory<_i199.SupplierConfirmOrRejectOrderOrItemCubit>(
      () => _i199.SupplierConfirmOrRejectOrderOrItemCubit(
        gh<_i507.SupplierRequestsRepository>(),
      ),
    );
    gh.factory<_i993.SupplierGetCancellationReasonCubit>(
      () => _i993.SupplierGetCancellationReasonCubit(
        gh<_i507.SupplierRequestsRepository>(),
      ),
    );
    gh.factory<_i585.SupplierGetModificationCubit>(
      () => _i585.SupplierGetModificationCubit(
        gh<_i507.SupplierRequestsRepository>(),
      ),
    );
    gh.factory<_i607.SupplierGetRequestDetailsCubit>(
      () => _i607.SupplierGetRequestDetailsCubit(
        gh<_i507.SupplierRequestsRepository>(),
      ),
    );
    gh.factory<_i952.SupplierGetRequestsCubit>(
      () => _i952.SupplierGetRequestsCubit(
        gh<_i507.SupplierRequestsRepository>(),
      ),
    );
    gh.factory<_i643.SupplierStartTrackOrderCubit>(
      () => _i643.SupplierStartTrackOrderCubit(
        gh<_i507.SupplierRequestsRepository>(),
      ),
    );
    gh.factory<_i671.CreateInventoryCubit>(
      () => _i671.CreateInventoryCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i984.CreateWasteDamageCubit>(
      () => _i984.CreateWasteDamageCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i692.GetDailyInventoryItemsCubit>(
      () => _i692.GetDailyInventoryItemsCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i522.GetInventoryEmployeeCubit>(
      () => _i522.GetInventoryEmployeeCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i605.GetInventoryRequestsCubit>(
      () => _i605.GetInventoryRequestsCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i1048.GetMonthlyCompletedProductsCubit>(
      () => _i1048.GetMonthlyCompletedProductsCubit(
        gh<_i117.InventoryRepository>(),
      ),
    );
    gh.factory<_i473.GetMonthlyDetailsCubit>(
      () => _i473.GetMonthlyDetailsCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i1041.GetMonthlyPendingProductsCubit>(
      () => _i1041.GetMonthlyPendingProductsCubit(
        gh<_i117.InventoryRepository>(),
      ),
    );
    gh.factory<_i863.GetMonthlySetupInfoCubit>(
      () => _i863.GetMonthlySetupInfoCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i369.GetWastedDamageItemsCubit>(
      () => _i369.GetWastedDamageItemsCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i158.InventoryApproveRejectStaffSubmitionCubit>(
      () => _i158.InventoryApproveRejectStaffSubmitionCubit(
        gh<_i117.InventoryRepository>(),
      ),
    );
    gh.factory<_i553.StartMonthlyInventoryCubit>(
      () => _i553.StartMonthlyInventoryCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i617.SubmitMonthlyInventoryCubit>(
      () => _i617.SubmitMonthlyInventoryCubit(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i257.UpdateQtyMonthlyInventoryBloc>(
      () =>
          _i257.UpdateQtyMonthlyInventoryBloc(gh<_i117.InventoryRepository>()),
    );
    gh.factory<_i881.EndAndUpdateManagerShiftCubit>(
      () => _i881.EndAndUpdateManagerShiftCubit(
        gh<_i430.ShiftManagementRepositoryImp>(),
      ),
    );
    gh.factory<_i1000.FinalDailyCloseCubit>(
      () =>
          _i1000.FinalDailyCloseCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.factory<_i585.VarianceCubit>(
      () => _i585.VarianceCubit(gh<_i430.ShiftManagementRepositoryImp>()),
    );
    gh.lazySingleton<
      _i731.ApproveBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase
    >(
      () =>
          _i731.ApproveBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase(
            gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
          ),
    );
    gh.lazySingleton<_i337.ApproveBrandOwnerFixedAssetsHandoverReportUseCase>(
      () => _i337.ApproveBrandOwnerFixedAssetsHandoverReportUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i90.ApproveBrandOwnerFixedAssetsModificationUseCase>(
      () => _i90.ApproveBrandOwnerFixedAssetsModificationUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i1057.ApproveBrandOwnerFixedAssetsReviewAuditUseCase>(
      () => _i1057.ApproveBrandOwnerFixedAssetsReviewAuditUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i214.ApproveBrandOwnerFixedAssetsTransferUseCase>(
      () => _i214.ApproveBrandOwnerFixedAssetsTransferUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<
      _i831.GetBrandOwnerFixedAssetsDisposalAndExternalTransferDetailsUseCase
    >(
      () =>
          _i831.GetBrandOwnerFixedAssetsDisposalAndExternalTransferDetailsUseCase(
            gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
          ),
    );
    gh.lazySingleton<
      _i666.GetBrandOwnerFixedAssetsDisposalAndExternalTransferRequestsUseCase
    >(
      () =>
          _i666.GetBrandOwnerFixedAssetsDisposalAndExternalTransferRequestsUseCase(
            gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
          ),
    );
    gh.lazySingleton<
      _i271.GetBrandOwnerFixedAssetsHandoverReportDetailsUseCase
    >(
      () => _i271.GetBrandOwnerFixedAssetsHandoverReportDetailsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<
      _i439.GetBrandOwnerFixedAssetsHandoverReportsRequestsUseCase
    >(
      () => _i439.GetBrandOwnerFixedAssetsHandoverReportsRequestsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i605.GetBrandOwnerFixedAssetsModificationDetailsUseCase>(
      () => _i605.GetBrandOwnerFixedAssetsModificationDetailsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i379.GetBrandOwnerFixedAssetsModificationRequestsUseCase>(
      () => _i379.GetBrandOwnerFixedAssetsModificationRequestsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i640.GetBrandOwnerFixedAssetsReviewAuditDetailsUseCase>(
      () => _i640.GetBrandOwnerFixedAssetsReviewAuditDetailsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i944.GetBrandOwnerFixedAssetsReviewAuditRequestsUseCase>(
      () => _i944.GetBrandOwnerFixedAssetsReviewAuditRequestsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i661.GetBrandOwnerFixedAssetsTransferDetailsUseCase>(
      () => _i661.GetBrandOwnerFixedAssetsTransferDetailsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i190.GetBrandOwnerFixedAssetsTransferRequestsUseCase>(
      () => _i190.GetBrandOwnerFixedAssetsTransferRequestsUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<
      _i921.RejectBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase
    >(
      () => _i921.RejectBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i605.RejectBrandOwnerFixedAssetsModificationUseCase>(
      () => _i605.RejectBrandOwnerFixedAssetsModificationUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i57.RejectBrandOwnerFixedAssetsReviewAuditUseCase>(
      () => _i57.RejectBrandOwnerFixedAssetsReviewAuditUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<_i420.RejectBrandOwnerFixedAssetsTransferUseCase>(
      () => _i420.RejectBrandOwnerFixedAssetsTransferUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.lazySingleton<
      _i230.SalaryDeductionBrandOwnerFixedAssetsHandoverReportUseCase
    >(
      () => _i230.SalaryDeductionBrandOwnerFixedAssetsHandoverReportUseCase(
        gh<_i949.BrandOwnerFixedAssetsRequestsRepository>(),
      ),
    );
    gh.factory<_i355.AcceptReassignedShiftCubit>(
      () => _i355.AcceptReassignedShiftCubit(gh<_i38.RequestsRepository>()),
    );
    gh.factory<_i470.BrandOwnerDailyInventoryRequestsCubit>(
      () => _i470.BrandOwnerDailyInventoryRequestsCubit(
        gh<_i752.GetBrandOwnerDailyInventoryRequestsUseCase>(),
      ),
    );
    gh.factory<_i704.BranchManagerSettingAndAggregatorsCubit>(
      () => _i704.BranchManagerSettingAndAggregatorsCubit(
        gh<_i415.GetBranchManagerSettingAndAggregatorsUseCase>(),
        gh<_i415.GetAvailableAggregatorsUseCase>(),
        gh<_i415.GetBranchAggregatorsUseCase>(),
        gh<_i415.AddBranchManagerAggregatorUseCase>(),
        gh<_i415.DeleteBranchManagerAggregatorUseCase>(),
        gh<_i415.SetBranchManagerAggregatorStatusUseCase>(),
        gh<_i415.UpdateBranchManagerNotificationUseCase>(),
      ),
    );
    gh.factory<_i569.ExportProfitAndLossStatementCubit>(
      () => _i569.ExportProfitAndLossStatementCubit(
        gh<_i952.ExportProfitAndLossStatementUseCase>(),
      ),
    );
    gh.factory<_i774.SmartComparisonCubit>(
      () => _i774.SmartComparisonCubit(gh<_i210.GetSmartComparisonUseCase>()),
    );
    gh.factory<_i44.SalesChannelAnalysisCubit>(
      () => _i44.SalesChannelAnalysisCubit(
        gh<_i1037.GetSalesChannelAnalysisUseCase>(),
      ),
    );
    gh.factory<_i456.BrandOwnerAssetOverviewCubit>(
      () => _i456.BrandOwnerAssetOverviewCubit(
        gh<_i845.GetBrandOwnerAssetOverviewUseCase>(),
      ),
    );
    gh.factory<_i25.PriceSimulatorItemsCubit>(
      () => _i25.PriceSimulatorItemsCubit(
        gh<_i831.GetPriceSimulatorItemsUseCase>(),
      ),
    );
    gh.factory<_i911.ExportSmartComparisonCubit>(
      () => _i911.ExportSmartComparisonCubit(
        gh<_i651.ExportSmartComparisonUseCase>(),
      ),
    );
    gh.factory<_i1031.BrandOwnerFixedAssetsRequestsCubit>(
      () => _i1031.BrandOwnerFixedAssetsRequestsCubit(
        gh<_i944.GetBrandOwnerFixedAssetsReviewAuditRequestsUseCase>(),
        gh<_i379.GetBrandOwnerFixedAssetsModificationRequestsUseCase>(),
        gh<_i439.GetBrandOwnerFixedAssetsHandoverReportsRequestsUseCase>(),
        gh<
          _i666.GetBrandOwnerFixedAssetsDisposalAndExternalTransferRequestsUseCase
        >(),
        gh<_i190.GetBrandOwnerFixedAssetsTransferRequestsUseCase>(),
      ),
    );
    gh.factory<_i1044.BrandOwnerReportsAndAnalyticsCubit>(
      () => _i1044.BrandOwnerReportsAndAnalyticsCubit(
        gh<_i379.GetBrandOwnerReportsAndAnalyticsUseCase>(),
      ),
    );
    gh.factory<_i466.PriceSimulatorSaveScenarioCubit>(
      () => _i466.PriceSimulatorSaveScenarioCubit(
        gh<_i898.SaveScenarioUseCase>(),
      ),
    );
    gh.factory<_i657.BrandOwnerWastAndDamageDetailsCubit>(
      () => _i657.BrandOwnerWastAndDamageDetailsCubit(
        gh<_i4.GetBrandOwnerWastAndDamageDetailsUseCase>(),
        gh<_i861.ApproveBrandOwnerWastAndDamageUseCase>(),
        gh<_i419.RejectBrandOwnerWastAndDamageUseCase>(),
      ),
    );
    gh.lazySingleton<_i836.FixedAssetsRepository>(
      () => _i836.FixedAssetsRepository(
        gh<_i628.FixedAssetsRemoteDataSource>(),
        gh<_i668.RealtimeService>(),
      ),
    );
    gh.factory<_i472.BrandOwnerHandoverReportsDetailsCubit>(
      () => _i472.BrandOwnerHandoverReportsDetailsCubit(
        gh<_i271.GetBrandOwnerFixedAssetsHandoverReportDetailsUseCase>(),
        gh<_i337.ApproveBrandOwnerFixedAssetsHandoverReportUseCase>(),
        gh<_i230.SalaryDeductionBrandOwnerFixedAssetsHandoverReportUseCase>(),
      ),
    );
    gh.factory<_i1029.OperationalProfitabilityCubit>(
      () => _i1029.OperationalProfitabilityCubit(
        gh<_i920.GetOperationalProfitabilityUseCase>(),
      ),
    );
    gh.factory<_i859.BranchManagerResetMyPasswordCubit>(
      () => _i859.BranchManagerResetMyPasswordCubit(
        gh<_i155.BranchManagerResetMyPasswordUseCase>(),
      ),
    );
    gh.factory<_i721.BrandOwnerWastAndDamageRequestsCubit>(
      () => _i721.BrandOwnerWastAndDamageRequestsCubit(
        gh<_i452.GetBrandOwnerWastAndDamageRequestsUseCase>(),
      ),
    );
    gh.factory<_i1027.BrandOwnerTransferDetailsCubit>(
      () => _i1027.BrandOwnerTransferDetailsCubit(
        gh<_i661.GetBrandOwnerFixedAssetsTransferDetailsUseCase>(),
        gh<_i214.ApproveBrandOwnerFixedAssetsTransferUseCase>(),
        gh<_i420.RejectBrandOwnerFixedAssetsTransferUseCase>(),
      ),
    );
    gh.factory<_i281.BrandOwnerModificationDetailsCubit>(
      () => _i281.BrandOwnerModificationDetailsCubit(
        gh<_i605.GetBrandOwnerFixedAssetsModificationDetailsUseCase>(),
        gh<_i90.ApproveBrandOwnerFixedAssetsModificationUseCase>(),
        gh<_i605.RejectBrandOwnerFixedAssetsModificationUseCase>(),
      ),
    );
    gh.factory<_i879.BrandOwnerDailyInventoryDetailsCubit>(
      () => _i879.BrandOwnerDailyInventoryDetailsCubit(
        gh<_i987.GetBrandOwnerDailyInventoryDetailsUseCase>(),
        gh<_i1012.ApproveBrandOwnerDailyInventoryUseCase>(),
        gh<_i291.RejectBrandOwnerDailyInventoryUseCase>(),
      ),
    );
    gh.factory<_i593.BrandOwnerBranchesForFilterCubit>(
      () => _i593.BrandOwnerBranchesForFilterCubit(
        gh<_i482.GetBranchesForFilterUseCase>(),
      ),
    );
    gh.factory<_i849.ProfitAndLossStatementCubit>(
      () => _i849.ProfitAndLossStatementCubit(
        gh<_i901.GetProfitAndLossStatementUseCase>(),
      ),
    );
    gh.factory<_i52.ExportOperationalProfitabilityCubit>(
      () => _i52.ExportOperationalProfitabilityCubit(
        gh<_i785.ExportOperationalProfitabilityUseCase>(),
      ),
    );
    gh.factory<_i422.BrandOwnerReviewAuditDetailsCubit>(
      () => _i422.BrandOwnerReviewAuditDetailsCubit(
        gh<_i640.GetBrandOwnerFixedAssetsReviewAuditDetailsUseCase>(),
        gh<_i1057.ApproveBrandOwnerFixedAssetsReviewAuditUseCase>(),
        gh<_i57.RejectBrandOwnerFixedAssetsReviewAuditUseCase>(),
      ),
    );
    gh.factory<_i296.BrandOwnerDisposalAndExternalTransferDetailsCubit>(
      () => _i296.BrandOwnerDisposalAndExternalTransferDetailsCubit(
        gh<
          _i831.GetBrandOwnerFixedAssetsDisposalAndExternalTransferDetailsUseCase
        >(),
        gh<
          _i731.ApproveBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase
        >(),
        gh<
          _i921.RejectBrandOwnerFixedAssetsDisposalAndExternalTransferUseCase
        >(),
      ),
    );
    gh.lazySingleton<_i477.ConfirmActiveHandoverSignatureReceiverUseCase>(
      () => _i477.ConfirmActiveHandoverSignatureReceiverUseCase(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.lazySingleton<_i628.ConfirmActiveHandoverSignatureSenderUseCase>(
      () => _i628.ConfirmActiveHandoverSignatureSenderUseCase(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.lazySingleton<_i406.GenerateFixedAssetsPreviewHistoryAssetReportUseCase>(
      () => _i406.GenerateFixedAssetsPreviewHistoryAssetReportUseCase(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.lazySingleton<_i93.GetActiveHandoverSessionPreviewAssetsUseCase>(
      () => _i93.GetActiveHandoverSessionPreviewAssetsUseCase(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.lazySingleton<_i62.GetFixedAssetsPreviewHistoryAssetUseCase>(
      () => _i62.GetFixedAssetsPreviewHistoryAssetUseCase(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i907.CompleteHandoverSessionCubit>(
      () =>
          _i907.CompleteHandoverSessionCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i675.FixdAssetsActiveHandoverApprovalCubit>(
      () => _i675.FixdAssetsActiveHandoverApprovalCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i256.FixdAssetsJoinHandoverCubit>(
      () =>
          _i256.FixdAssetsJoinHandoverCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i857.FixdAssetsStartHandoverCubit>(
      () =>
          _i857.FixdAssetsStartHandoverCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i811.FixedAssetsDisposalsDetailsCubit>(
      () => _i811.FixedAssetsDisposalsDetailsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i855.FixedAssetsGetReceiveAssetsCubit>(
      () => _i855.FixedAssetsGetReceiveAssetsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i631.FixedAssetsGetRequestsCubit>(
      () =>
          _i631.FixedAssetsGetRequestsCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i748.FixedAssetsGetZoneAndTypeCubit>(
      () => _i748.FixedAssetsGetZoneAndTypeCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i991.FixedAssetsHandoverSessionRealtimeCubit>(
      () => _i991.FixedAssetsHandoverSessionRealtimeCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i310.FixedAssetsReceiveAssetsCubit>(
      () => _i310.FixedAssetsReceiveAssetsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i336.FixedAssetsSearchCubit>(
      () => _i336.FixedAssetsSearchCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i625.FixedAssetsTransferDetailsCubit>(
      () => _i625.FixedAssetsTransferDetailsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i909.GetActiveHandoverSessionDetailsCubit>(
      () => _i909.GetActiveHandoverSessionDetailsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i446.GetActiveHandoverSessionSignatureCubit>(
      () => _i446.GetActiveHandoverSessionSignatureCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i89.GetActiveHandoverSessionSummaryCubit>(
      () => _i89.GetActiveHandoverSessionSummaryCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i333.GetFixedAssetsHandoverDetailsCubit>(
      () => _i333.GetFixedAssetsHandoverDetailsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i642.GetFixedAssetsOverviewCubit>(
      () =>
          _i642.GetFixedAssetsOverviewCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i882.GetHandoverIncludedZonesCubit>(
      () => _i882.GetHandoverIncludedZonesCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i220.GetJoinHandoverSessionDetailsCubit>(
      () => _i220.GetJoinHandoverSessionDetailsCubit(
        gh<_i836.FixedAssetsRepository>(),
      ),
    );
    gh.factory<_i739.GetRequestsDetailsCubit>(
      () => _i739.GetRequestsDetailsCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i950.ModifyAssetCubit>(
      () => _i950.ModifyAssetCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i841.TransferOrDisposeAssetsCubit>(
      () =>
          _i841.TransferOrDisposeAssetsCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i619.UpdateAssetSettingsCubit>(
      () => _i619.UpdateAssetSettingsCubit(gh<_i836.FixedAssetsRepository>()),
    );
    gh.factory<_i627.ConfirmActiveHandoverSignatureCubit>(
      () => _i627.ConfirmActiveHandoverSignatureCubit(
        gh<_i477.ConfirmActiveHandoverSignatureReceiverUseCase>(),
        gh<_i628.ConfirmActiveHandoverSignatureSenderUseCase>(),
      ),
    );
    gh.factory<_i761.GetActiveHandoverSessionPreviewAssetsCubit>(
      () => _i761.GetActiveHandoverSessionPreviewAssetsCubit(
        gh<_i93.GetActiveHandoverSessionPreviewAssetsUseCase>(),
      ),
    );
    gh.factory<_i1032.GenerateFixedAssetsPreviewHistoryAssetReportCubit>(
      () => _i1032.GenerateFixedAssetsPreviewHistoryAssetReportCubit(
        gh<_i406.GenerateFixedAssetsPreviewHistoryAssetReportUseCase>(),
      ),
    );
    gh.factory<_i467.GetFixedAssetsPreviewHistoryAssetCubit>(
      () => _i467.GetFixedAssetsPreviewHistoryAssetCubit(
        gh<_i62.GetFixedAssetsPreviewHistoryAssetUseCase>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
