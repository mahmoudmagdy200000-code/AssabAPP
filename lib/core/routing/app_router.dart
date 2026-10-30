// ignore_for_file: unused_import

import 'package:assab/core/cubits/add_item/add_item_cubit.dart';
import 'package:assab/core/cubits/media/media_cubit.dart';
import 'package:assab/core/cubits/switch_button/switch_button_cubit.dart';
import 'package:assab/core/cubits/validation/validation_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/active_account_form/active_account_form_cubit.dart';
import 'package:assab/features/active_account/presentation/cubits/reset_password_form/reset_password_form_cubit.dart';
import 'package:assab/core/services/auth_service.dart';
import 'package:assab/core/strategies/user_type_strategy.dart';
import 'package:assab/core/widgets/reset_password_success_screen.dart';
import 'package:assab/features/active_account/presentation/screens/active_account_screen.dart';
import 'package:assab/features/brach_manager_main/presentation/screens/branch_manager_main_screen.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/grouped_invoice_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/pre_approval_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/quick_cash_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/single_invoice_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expenses_filter/expenses_filter_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/suppliers/suppliers_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/screens/pre_approval_request_screen.dart';
import 'package:assab/features/branch_manager_expenses/presentation/screens/single_expense_screen.dart';
import 'package:assab/features/choose_user_type/presentation/cubit/choose_user_type/choose_user_type_cubit.dart';
import 'package:assab/features/choose_user_type/presentation/screens/choose_user_type_screen.dart';
import 'package:assab/features/login/presentation/cubits/login/login_cubit.dart';
import 'package:assab/features/login/presentation/screens/login_with_email_screen.dart';
import 'package:assab/features/login/presentation/screens/login_with_phone_screen.dart';
import 'package:assab/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:assab/features/purchase/data/models/purchase_branch_items_response.dart';
import 'package:assab/features/purchase/data/models/purchase_history_response.dart';
import 'package:assab/features/purchase/presentation/cubit/get_purchase_branch_items/get_purchase_branch_items_cubit.dart';
import 'package:assab/features/purchase/presentation/screens/purchase_screen.dart';
import 'package:assab/features/reset_password/presentation/cubits/create_new_password/create_new_password_cubit.dart';
import 'package:assab/features/reset_password/presentation/cubits/send_otp/send_otp_cubit.dart';
import 'package:assab/features/reset_password/presentation/screens/create_new_password_screen.dart';
import 'package:assab/features/reset_password/presentation/screens/reset_password_with_email_screen.dart';
import 'package:assab/features/reset_password/presentation/screens/reset_password_with_phone_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/manager_shift/current_shift/handover_details_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_cashier_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/domain/entity/shift/shift_entity.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/add_cashier/add_cashier_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/manager_shift/end_manager_shift/end_manager_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/logic/shifts/end_shift/end_shift_cubit.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/add_cashier_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/end_manager_shift_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/end_shift_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/screens/update_manager_final_daily_close_screen.dart';
import 'package:assab/features/shift_module_features/shift_management/presentation/ui/widgets/handover_widgets/handover_success_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/active_account/presentation/cubits/active_account/active_account_cubit.dart';
import '../../features/active_account/presentation/screens/reset_password_active_account_screen.dart';
import '../../features/branch_manager_expenses/domain/entities/expenses_main_category_response_entity.dart';
import '../../features/branch_manager_expenses/presentation/cubit/branch_manager_expenses_history/branch_manager_expenses_history_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/categories/categories_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/grouped_invoice/grouped_invoice_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/pre_approval/pre_approval_cubit.dart';
import '../../features/branch_manager_expenses/presentation/cubit/single_expense/single_expense_cubit.dart';
import '../../features/branch_manager_expenses/presentation/screens/branch_manager_expenses_history_screen.dart';
import '../../features/branch_manager_expenses/presentation/screens/edit_item_and_expenses_list.dart';
import '../../features/branch_manager_expenses/presentation/screens/grouped_invoices_screen.dart';
import '../../features/branch_manager_expenses/presentation/screens/quick_cash_expense_screen.dart';
import '../../features/branch_manager_home/presentation/cubit/branch_manager_create_order_with_recommended_source/branch_manager_create_order_with_recommended_source_cubit.dart';
import '../../features/branch_manager_home/presentation/screens/branch_manager_view_reports_price_comparison_details_screen.dart';
import '../../features/branch_manager_home/presentation/screens/branch_manager_view_reports_price_comparison_view.dart';
import '../../features/branch_manager_home/presentation/screens/branch_manager_view_reports_screen.dart';
import '../../features/branch_manager_settings/presentation/cubits/branch_manager_setting_and_aggregators_cubit.dart';
import '../../features/branch_manager_settings/presentation/screens/branch_manager_setting_and_aggregators_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/brand_owner_branches_for_filter_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/break_even_analysis_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_break_even_analysis_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_menu_engineering_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_operational_profitability_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_profit_and_loss_statement_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_profit_vs_cash_reconciliation_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_sales_channel_analysis_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/export_smart_comparison_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/menu_engineering_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/operational_profitability_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/item_test_screen_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_items_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_save_scenario_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_saved_scenarios_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_scenario_details_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/price_simulator_screen_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/profit_and_loss_statement_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/profit_vs_cash_reconciliation_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/sales_channel_analysis_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/sales_channel_level2_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/cubit/smart_comparison_cubit.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_break_even_analysis_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_financial_reporting_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_menu_engineering_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_operational_profitability_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_price_simulator_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_profit_and_loss_statement_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_profit_vs_cash_reconciliation_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_sales_channel_analysis_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_sales_channel_level2_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_smart_comparisons_screen.dart';
import '../../features/brand_owner_financial_reporting/presentation/screens/brand_owner_test_item_screen.dart';
import '../../features/brand_owner_home/presentation/cubit/brand_owner_payment/brand_owner_payment_cubit.dart';
import '../../features/brand_owner_home/presentation/cubit/get_completed_escelations/get_completed_escelations_cubit.dart';
import '../../features/brand_owner_home/presentation/cubit/get_pending_escelations/get_pending_escelations_cubit.dart';
import '../../features/brand_owner_home/presentation/screens/brand_owner_escalation_requests_screen.dart';
import '../../features/brand_owner_home/presentation/screens/brand_owner_payment_screen.dart';
import '../../features/brand_owner_main/presentation/screens/brand_owner_main_screen.dart';
import '../../features/brand_owner_requests/presentation/screens/brand_owner_payment_log_screen.dart';
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_daily_inventory_details/brand_owner_daily_inventory_details_cubit.dart';
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_wast_and_damage_details/brand_owner_wast_and_damage_details_cubit.dart';
import '../../features/brand_owner_tools/presentation/cubit/brand_owner_wast_and_damage_requests/brand_owner_wast_and_damage_requests_cubit.dart';
import '../../features/brand_owner_tools/presentation/screens/brand_owner_daily_inventory_details_screen.dart';
import '../../features/brand_owner_tools/presentation/screens/brand_owner_fixed_assets_control_panal_screen.dart';
import '../../features/brand_owner_tools/presentation/screens/brand_owner_fixed_assets_requests_screen.dart';
import '../../features/brand_owner_tools/presentation/screens/brand_owner_inventory_management_screen.dart';
import '../../features/brand_owner_tools/presentation/screens/brand_owner_wast_and_damage_details_screen.dart';
import '../../features/cashier_home/presentation/cubit/get_tasks/get_tasks_cubit.dart';
import '../../features/cashier_home/presentation/screens/cashier_new_assignments_screen.dart';
import '../../features/cashier_main/presentation/screens/cashier_main_screen.dart';
import '../../features/custody/presentation/cubit/get_branch_balance/get_branch_balance_cubit.dart';
import '../../features/custody/presentation/cubit/get_custody_trend_state/get_custody_trend_state_cubit.dart';
import '../../features/custody/presentation/cubit/get_personal_balance/get_personal_balance_cubit.dart';
import '../../features/custody/presentation/screens/custody_balance_trend_state.dart';
import '../../features/custody/presentation/screens/custody_handover_to_cashier_details_screen.dart';
import '../../features/custody/presentation/screens/custody_request_success_screen.dart';
import '../../features/custody/presentation/screens/custody_screen.dart';
import '../../features/custody/presentation/cubit/get_personal_balance_transactions/get_personal_balance_transactions_cubit.dart';
import '../../features/custody/presentation/widgets/see_all_personal_custody_activities.dart';
import '../../features/fixed_assets/data/models/fixed_assets_search_response.dart';
import '../../features/fixed_assets/domain/enums/fixed_assets_handover_status_filter_enum.dart';
import '../../features/fixed_assets/domain/strategies/fixed_assets_transfer_types_strategy.dart';
import '../../features/fixed_assets/presentation/arguments/fixed_assets_transfers_and_disposal_arguments.dart';
import '../../features/fixed_assets/presentation/cubit/complete__handover_session/complete__handover_session_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/confirm_active_handover_signature/confirm_active_handover_signature_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixd_assets_active_handover_approval/fixd_assets_active_handover_approval_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixd_assets_join_handover/fixd_assets_join_handover_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixd_assets_start_handover/fixd_assets_start_handover_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_disposals_details/fixed_assets_disposals_details_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_get_receive_assets/fixed_assets_get_receive_assets_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_get_requests/fixed_assets_get_requests_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_get_zone_and_type/fixed_assets_get_zone_and_type_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_handover_session_realtime/fixed_assets_handover_session_realtime_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_receive_assets/fixed_assets_receive_assets_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/fixed_assets_transfer_details/fixed_assets_transfer_details_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_details/get_active_handover_session_details_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_preview_assets/get_active_handover_session_preview_assets_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_signature/get_active_handover_session_signature_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_active_handover_session_summary/get_active_handover_session_summary_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_fixed_assets_handover_details/get_fixed_assets_handover_details_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_fixed_assets_overview/get_fixed_assets_overview_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_handover_included_zones/get_handover_included_zones_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_join_handover_session_details/get_join_handover_session_details_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/get_requests_details/get_requests_details_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/modify_asset/modify_asset_cubit.dart';
import '../../features/fixed_assets/presentation/cubit/transfer_or_dispose_assets/transfer_or_dispose_assets_cubit.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_active_handover_session_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_disposals_details_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_handover_details_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_handover_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_join_handover_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_modification_details_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_modify_asset_status_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_receive_assets_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_requests_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_search_result_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_search_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_transfer_details_screen.dart';
import '../../features/fixed_assets/presentation/screens/fixed_assets_transfers_and_disposal_screen.dart';
import '../../features/inventory/data/models/daily_inventory_items_response.dart';
import '../../features/inventory/data/models/daily_inventory_local_model.dart';
import '../../features/inventory/data/models/monthly_inventory_local_model.dart';
import '../../features/inventory/data/models/monthly_inventory_pending_products_response.dart';
import '../../features/inventory/domain/strategies/inventory_user_type.dart';
import '../../features/inventory/presentation/cubit/create_waste_damage/create_waste_damage_cubit.dart';
import '../../features/inventory/presentation/cubit/get_daily_inventory_items/get_daily_inventory_items_cubit.dart';
import '../../features/inventory/presentation/cubit/get_monthly_completed_products/get_monthly_completed_products_cubit.dart';
import '../../features/inventory/presentation/cubit/get_monthly_pending_products/get_monthly_pending_products_cubit.dart';
import '../../features/inventory/presentation/cubit/get_monthly_setup_info/get_monthly_setup_info_cubit.dart';
import '../../features/inventory/presentation/cubit/start_monthly_inventory/start_monthly_inventory_cubit.dart';
import '../../features/inventory/presentation/cubit/update_qty_monthly_inventory/update_qty_monthly_inventory_bloc.dart';
import '../../features/inventory/presentation/cubit/wasted_selected_items/wasted_selected_items_cubit.dart';
import '../../features/inventory/presentation/screens/daily_inventory_choose_inventory_method_screen.dart';
import '../../features/inventory/presentation/screens/daily_inventory_screen.dart';
import '../../features/inventory/presentation/screens/daily_personal_inventory.dart';
import '../../features/inventory/presentation/screens/inventory_how_to_slider_work_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/inventory/presentation/screens/inventory_slider_screen.dart';
import '../../features/inventory/presentation/screens/monthly_inventory_pending_products_screen.dart';
import '../../features/inventory/presentation/screens/monthly_inventory_screen.dart';
import '../../features/inventory/presentation/screens/monthly_inventory_start_screen.dart';
import '../../features/inventory/presentation/screens/wasted_inventory_choose_inventory_method_screen.dart';
import '../../features/inventory/presentation/screens/wasted_inventory_screen.dart';
import '../../features/inventory/presentation/screens/wasted_regester_productes_screen.dart';
import '../../features/onboarding/presentation/cubit/onboarding/onboarding_cubit.dart';
import '../../features/purchase/domain/strategies/create_order_strategy.dart';
import '../../features/purchase/presentation/cubit/add_item_purchase/add_item_purchase_cubit.dart';
import '../../features/purchase/presentation/cubit/purchase_history/purchase_history_cubit.dart';
import '../../features/purchase/presentation/screens/create_purchase_order_success_screen.dart';
import '../../features/purchase/presentation/screens/purchase_history_screen.dart';
import '../../features/receive_goods/presentation/cubit/get_receiving_orders/get_receiving_orders_cubit.dart';
import '../../features/receive_goods/presentation/screens/receive_goods_screen.dart';
import '../../features/receive_goods/presentation/screens/receive_without_prior_order_screen.dart';
import '../../features/recurring_orders/presentation/cubit/get_in_progress_recurring_orders/get_in_progress_recurring_orders_cubit.dart';
import '../../features/recurring_orders/presentation/cubit/get_next_scheduled_recurring_orders/get_next_scheduled_recurring_orders_cubit.dart';
import '../../features/recurring_orders/presentation/cubit/get_paused_recurring_orders/get_paused_recurring_orders_cubit.dart';
import '../../features/recurring_orders/presentation/cubit/get_recurring_order_details/get_recurring_order_details_cubit.dart';
import '../../features/recurring_orders/presentation/cubit/recurring_order_actions/recurring_order_actions_cubit.dart';
import '../../features/recurring_orders/presentation/screens/recurring_order_created_successfully_screen.dart';
import '../../features/recurring_orders/presentation/screens/recurring_order_details_screen.dart';
import '../../features/recurring_orders/presentation/screens/recurring_orders_screen.dart';
import '../../features/reset_password/presentation/bloc/verify_otp/verify_otp_bloc.dart';
import '../../features/reset_password/presentation/screens/verify_reset_password_screen.dart';
import '../../features/returns_management/presentation/cubit/get_return_details/get_return_details_cubit.dart';
import '../../features/returns_management/presentation/cubit/get_returns/get_returns_cubit.dart';
import '../../features/returns_management/presentation/screens/item_return_details_screen.dart';
import '../../features/returns_management/presentation/screens/returns_management_screen.dart';
import '../../features/shift_module_features/shift_management/data/model/shift/reassign_shift/reassign_shift_params.dart';
import '../../features/shift_module_features/shift_management/domain/entity/cashier_entity.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/cashier/cashier_management_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/choose_employee/choose_employee_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/manager_shift/final_daily_close/final_daily_close_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/manager_shift/manager_shift_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/aggregator_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/cashier_shifts_management_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/handover/handover_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/reassign_shift/reassign_shift_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/logic/shifts/shift_details/shift_details_cubit.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/arguments/shift_arguments.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/cashier_shifts_screen.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/cashiers_management_screen.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/end_shift_with_handover_screen.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/handover_only_screen.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/reassign_shift_with_handover_screen.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/reassign_shift_without_handover_screen.dart';
import '../../features/shift_module_features/shift_management/presentation/ui/screens/shift_details_screen.dart';
import '../../features/supplier_main/presentation/screens/supplier_main_screen.dart';
import '../../features/supplier_returns/presentation/cubit/get_return_details/get_return_details_cubit.dart';
import '../../features/supplier_returns/presentation/screens/supplier_item_return_details_screen.dart';
import '../cubits/choose_item/choose_item_cubit.dart';
import '../cubits/data_management/date_management/date_management_cubit.dart';
import '../cubits/paging_cubit/paging_cubit.dart';
import '../cubits/payment_method/payment_method_cubit.dart';
import '../cubits/search/search_cubit.dart';
import '../cubits/select_priority/select_priority_cubit.dart';
import '../di/dependency_injection.dart';
import '../services/user_type_service.dart';
import 'app_route_name.dart';

class AppRouter {
  AppRouter._();

  static MaterialPageRoute _chooseUserTypeRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => getIt<ChooseUserTypeCubit>(),
        child: const ChooseUserTypeScreen(),
      ),
      settings: settings,
    );
  }

  static MaterialPageRoute _branchManagerMainScreenRoute(
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => PagingCubit(totalSteps: 5),
        child: const BranchManagerMainScreen(),
      ),
      settings: settings,
    );
  }

  static MaterialPageRoute _supplierMainScreenRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => PagingCubit(totalSteps: 3),
        child: const SupplierMainScreen(),
      ),
      settings: settings,
    );
  }

  static MaterialPageRoute _cashierMainScreenRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => PagingCubit(totalSteps: 5),
        child: const CashierMainScreen(),
      ),
      settings: settings,
    );
  }

  static MaterialPageRoute _brandOwnerMainScreenRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => PagingCubit(totalSteps: 5),
        child: const BrandOwnerMainScreen(),
      ),
      settings: settings,
    );
  }

  static MaterialPageRoute _startRoute(RouteSettings settings) {
    final userType = UserTypeService.getSavedUserType();

    if (AuthService.isLoggedInVal && userType != null) {
      UserTypeService.setUserType(
        strategy: UserTypeService.strategyFor(userType),
        userType: userType,
      );
      switch (userType) {
        case UserType.branchManager:
          return _branchManagerMainScreenRoute(settings);
        case UserType.cashier:
          return _cashierMainScreenRoute(settings);
        case UserType.supplier:
          return _supplierMainScreenRoute(settings);
        case UserType.brandOwner:
          return _brandOwnerMainScreenRoute(settings);
      }
    }

    return _chooseUserTypeRoute(settings);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteName.start:
        return _startRoute(settings);
      case AppRouteName.onboarding:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<OnboardingCubit>(),
            child: const OnboardingScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.activeAccountScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<ActiveAccountCubit>()),
              BlocProvider(create: (context) => ActiveAccountFormCubit()),
            ],
            child: const ActiveAccountScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.resetPasswordActiveAccountScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<ActiveAccountCubit>()),
              BlocProvider(create: (context) => ResetPasswordFormCubit()),
            ],
            child: const ResetPasswordActiveAccountScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.resetPasswordSuccessScreen:
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordSuccessScreen(),
          settings: settings,
        );
      case AppRouteName.loginWithEmailScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginWithEmailScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.loginWithPhoneScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: const LoginWithPhoneScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.resetPasswordWithEmailScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<SendOtpCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {'email'}),
              ),
            ],
            child: const ResetPasswordWithEmailScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.resetPasswordWithPhoneScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<SendOtpCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {'phone'}),
              ),
            ],
            child: const ResetPasswordWithPhoneScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.verifyResetPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<VerifyOtpBloc>()),
              BlocProvider(create: (context) => getIt<SendOtpCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {'n1', 'n2', 'n3', 'n4', 'n5'},
                ),
              ),
            ],
            child: const VerifyResetPasswordScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.createNewPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<CreateNewPasswordCubit>(),
              ),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {'password', 'confirmPassword'},
                ),
              ),
            ],
            child: const CreateNewPasswordScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.branchManagerMainScreen:
        return _branchManagerMainScreenRoute(settings);
      case AppRouteName.supplierMainScreen:
        return _supplierMainScreenRoute(settings);
      case AppRouteName.brandOwnerMainScreen:
        return _brandOwnerMainScreenRoute(settings);
      case AppRouteName.branchManagerExpensesHistoryScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<BranchManagerExpensesHistoryCubit>(),
              ),
              BlocProvider(create: (context) => getIt<ExpensesFilterCubit>()),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 6)),
            ],
            child: const BranchManagerExpensesHistoryScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.quickCashExpenseScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'date',
                    'expenseTitle',
                    'totalAmount',
                    'paymentMethod',
                    'photos',
                  },
                  optionalFields: {'itemsAmount', 'paymentSupplierId'},
                ),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => getIt<PaymentMethodCubit>()),
              BlocProvider(create: (context) => getIt<AddItemCubit>()),
              BlocProvider(create: (context) => getIt<ExpenseDetailsCubit>()),
            ],
            child: QuickCashExpenseScreen(strategy: AddNewQuickCashStrategy()),
          ),
          settings: settings,
        );
      case AppRouteName.singleExpenseScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'supplierId',
                    'supplierName',
                    'invoiceNum',
                    'issueDate',
                    'photos',
                  },
                  optionalFields: {
                    'taxId',
                    'taxSupplierName',
                    'netAmount',
                    'vatAmount',
                    'totalIncVat',
                    'paymentSupplierId',
                  },
                ),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => getIt<PaymentMethodCubit>()),
              BlocProvider(create: (context) => getIt<SingleExpenseCubit>()),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 4)),
              BlocProvider(create: (context) => getIt<SuppliersCubit>()),
              BlocProvider(create: (context) => getIt<CategoriesCubit>()),
              BlocProvider(create: (context) => getIt<AddItemCubit>()),
              BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
              BlocProvider(create: (_) => getIt<SwitchButtonCubit>()),
              BlocProvider(create: (_) => getIt<ExpenseDetailsCubit>()),
            ],
            child: SingleExpenseScreen(strategy: AddNewSingleInvoiceStrategy()),
          ),
          settings: settings,
        );
      case AppRouteName.editItemAndExpensesList:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<CategoriesCubit>()),
              BlocProvider(
                create: (context) =>
                    SearchCubit<ExpensesMainCategoryResponseEntity>(),
              ),
            ],
            child: const EditItemAndExpensesList(),
          ),
          settings: settings,
        );
      case AppRouteName.preApprovalRequestScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => getIt<PaymentMethodCubit>()),
              BlocProvider(create: (context) => getIt<CategoriesCubit>()),
              BlocProvider(create: (context) => getIt<AddItemCubit>()),
              BlocProvider(create: (context) => getIt<PreApprovalCubit>()),
              BlocProvider(create: (context) => getIt<ExpenseDetailsCubit>()),
              BlocProvider(create: (context) => getIt<SelectPriorityCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'purpose',
                    'estimatedAmount',
                    'paymentMethod',
                    'photos',
                    'priority',
                  },
                  optionalFields: {'paymentSupplierId'},
                ),
              ),
            ],
            child: PreApprovalRequestScreen(
              strategy: AddNewPreApprovalDraftStrategy(),
            ),
          ),
          settings: settings,
        );
      case AppRouteName.groupedInvoicesScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(create: (context) => getIt<PaymentMethodCubit>()),
              BlocProvider(create: (context) => getIt<SuppliersCubit>()),
              BlocProvider(create: (context) => getIt<CategoriesCubit>()),
              BlocProvider(create: (context) => getIt<AddItemCubit>()),
              BlocProvider(create: (context) => getIt<GroupedInvoiceCubit>()),
              BlocProvider(create: (context) => getIt<ExpenseDetailsCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {'supplierId', 'supplierName', 'paymentType'},
                  optionalFields: {'paymentSupplierId'},
                ),
              ),
            ],
            child: GroupedInvoicesScreen(
              strategy: AddNewGroupedInvoiceDraftStrategy(),
            ),
          ),
          settings: settings,
        );
      case AppRouteName.cashiersManagementScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<CashierManagementCubit>(),
              ),
              BlocProvider(create: (context) => SearchCubit<CashierEntity>()),
            ],
            child: const CashiersManagementScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.addCashierScreen:
        final cashierCubit = settings.arguments as CashierManagementCubit;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {'cashierName', 'email', 'storeBranch'},
                ),
              ),
              BlocProvider(create: (context) => getIt<AddCashierCubit>()),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider.value(value: cashierCubit),
            ],
            child: const AddCashierScreen(),
          ),
          settings: settings,
        );

      case AppRouteName.cashierShiftsScreen:
        final args = settings.arguments as Map<String, dynamic>;

        final cashierId = args['param1'] as String;
        final cashier = args['param2'] as CashierEntity;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<CashierShiftsManagementCubit>(param1: cashierId),
              ),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 4)),
            ],
            child: CashierShiftsScreen(cashier: cashier),
          ),
          settings: settings,
        );

      case AppRouteName.shiftDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final shiftId = args['shiftId'] as String;
        final isCashier = args['isCashier'] as bool?;

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<ShiftDetailsCubit>(
                  param1: shiftId,
                  param2: isCashier ?? false,
                ),
              ),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
            ],
            child: const ShiftDetailsScreen(),
          ),

          settings: settings,
        );

      case AppRouteName.reassignShiftWithoutHandoverScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final shift = args['shift'] as ShiftEntity;
        final previousCashier = args['previousCashier'] as ShiftCashierEntity?;
        final nextCashier = args['nextCashier'] as ShiftCashierEntity?;
        final isOpenedFromShiftDetailsScreen =
            args['isOpenedFromShiftDetailsScreen'] as bool?;

        final params = ReassignShiftParams(
          shift: shift,
          previousCashier: previousCashier,
          nextCashier: nextCashier,
        );
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (_) => ValidationCubit(
                  requiredFields: {'cashierName'},
                  optionalFields: {'reason'},
                ),
              ),
              BlocProvider(
                create: (_) => getIt<ReassignShiftCubit>(param1: params),
              ),
            ],
            child: ReassignShiftWithoutHandoverScreen(
              isOpenedFromShiftDetailsScreen:
                  isOpenedFromShiftDetailsScreen ?? false,
            ),
          ),
        );
      case AppRouteName.reassignShiftWithHandoverScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final shift = args['shift'] as ShiftEntity;
        final previousCashier = args['previousCashier'] as ShiftCashierEntity?;
        final nextCashier = args['nextCashier'] as ShiftCashierEntity?;
        final isOpenedFromShiftDetailsScreen =
            args['isOpenedFromShiftDetailsScreen'] as bool?;

        final params = ReassignShiftParams(
          shift: shift,
          previousCashier: previousCashier,
          nextCashier: nextCashier,
        );
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (_) => ValidationCubit(requiredFields: {'cashierName'}),
              ),
              BlocProvider(
                create: (_) => getIt<ReassignShiftCubit>(param1: params),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => ChooseEmployeeCubit()),
              BlocProvider(create: (context) => getIt<AggregatorCubit>()),
            ],
            child: ReassignShiftWithHandoverScreen(
              isOpenedFromShiftDetailsScreen:
                  isOpenedFromShiftDetailsScreen ?? false,
            ),
          ),
        );
      case AppRouteName.endShiftScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final isNavigatedFromCashier = args['isNavigatedFromCashier'] as bool;
        final shiftId = args['shiftId'] as String;
        final isOpenedFromShiftDetailsScreen =
            args['isOpenedFromShiftDetailsScreen'] as bool?;

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (_) => ValidationCubit(requiredFields: {'totalSales'}),
              ),
              BlocProvider(
                create: (_) => getIt<EndShiftCubit>(param1: shiftId),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => ChooseEmployeeCubit()),
              BlocProvider(create: (context) => getIt<AggregatorCubit>()),
            ],
            child: EndShiftScreen(
              isNavigatedFromCashier: isNavigatedFromCashier,
              isOpenedFromShiftDetailsScreen:
                  isOpenedFromShiftDetailsScreen ?? false,
            ),
          ),
        );

      case AppRouteName.endShiftWithHandoverScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final isNavigatedFromCashier = args['isNavigatedFromCashier'] as bool;
        final shiftId = args['shiftId'] as String;
        final isOpenedFromShiftDetailsScreen =
            args['isOpenedFromShiftDetailsScreen'] as bool?;

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (_) => ValidationCubit(
                  requiredFields: {'totalSales', 'responsibilityType'},
                  optionalFields: {'attachments', 'reason', 'posReceipt'},
                ),
              ),
              BlocProvider(
                create: (_) => getIt<EndShiftCubit>(param1: shiftId),
              ),
              BlocProvider(create: (context) => ChooseEmployeeCubit()),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => getIt<AggregatorCubit>()),
            ],
            child: EndShiftWithHandoverScreen(
              isNavigatedFromCashier: isNavigatedFromCashier,
              isOpenedFromShiftDetailsScreen:
                  isOpenedFromShiftDetailsScreen ?? false,
            ),
          ),
        );
      case AppRouteName.purchaseScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<AddItemPurchaseCubit>()),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {'items'}),
              ),
              BlocProvider(
                create: (context) => getIt<GetPurchaseBranchItemsCubit>(),
              ),
              BlocProvider(
                create: (context) => SearchCubit<PurchaseBranchItemData>(),
              ),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
            ],
            child: PurchaseScreen(
              strategy: CreateNewOrderCreateOrderStrategy(),
            ),
          ),
        );
      case AppRouteName.purchaseHistoryScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<PurchaseHistoryCubit>()),
              BlocProvider(
                create: (context) => SearchCubit<PurchaseHistoryData>(),
              ),
            ],
            child: const PurchaseHistoryScreen(),
          ),
        );
      case AppRouteName.custodyScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<DateManagementCubit>()),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (context) => getIt<GetPersonalBalanceCubit>(),
              ),
              BlocProvider(create: (context) => getIt<GetBranchBalanceCubit>()),
            ],
            child: const CustodyScreen(),
          ),
        );
      case AppRouteName.accountStatementScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (context) =>
                    getIt<GetPersonalBalanceTransactionsCubit>(),
              ),
            ],
            child: const SeeAllPersonalCustodyActivities(),
          ),
        );
      case AppRouteName.custodyRequestSuccessScreen:
        return MaterialPageRoute(
          builder: (context) => const CustodyRequestSuccessScreen(),
        );
      // case AppRouteName.custodyRequestDetailsScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => MultiBlocProvider(
      //       providers: [
      //         BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
      //       ],
      //       child: CustodyRequestDetailsScreen(
      //         requestId: settings.arguments as String,
      //       ),
      //     ),
      //   );
      case AppRouteName.custodyHandoverToCashierDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
            ],
            child: const CustodyHandoverToCashierDetailsScreen(),
          ),
        );
      case AppRouteName.custodyBalanceTrendState:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<DateManagementCubit>()),
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (context) => getIt<GetCustodyTrendStateCubit>(),
              ),
            ],
            child: const CustodyBalanceTrendState(),
          ),
        );
      case AppRouteName.createPurchaseOrderSuccessScreen:
        return MaterialPageRoute(
          builder: (context) => const CreatePurchaseOrderSuccessScreen(),
        );
      case AppRouteName.receiveGoodsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 4)),
              BlocProvider(
                create: (context) => getIt<GetReceivingOrdersCubit>(),
              ),
            ],
            child: const ReceiveGoodsScreen(),
          ),
        );
      case AppRouteName.receiveWithoutPriorOrderScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'supplier',
                    'product',
                    'unit',
                    'quantity',
                    'price',
                    'paymentTerms',
                    'file',
                  },
                  optionalFields: {'deliveryRefNo', 'note'},
                ),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
            ],
            child: const ReceiveWithoutPriorOrderScreen(),
          ),
        );
      case AppRouteName.returnsManagementScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
              BlocProvider(create: (context) => getIt<GetReturnsCubit>()),
            ],
            child: const ReturnsManagementScreen(),
          ),
        );
      case AppRouteName.itemReturnDetailsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments;
            String returnId;
            UserTypeStrategy? role;
            void Function()? onEscalationUpdated;

            if (args is Map<String, dynamic>) {
              returnId = args['returnId'] as String;
              role = args['role'] as UserTypeStrategy?;
              onEscalationUpdated =
                  args['onEscalationUpdated'] as void Function()?;
            } else {
              returnId = args as String;
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
                BlocProvider(
                  create: (context) => getIt<GetReturnDetailsCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      ValidationCubit(requiredFields: {'info'}),
                ),
              ],
              child: ItemReturnDetailsScreen(
                returnId: returnId,
                role: role,
                onEscalationUpdated: onEscalationUpdated,
              ),
            );
          },
        );
      case AppRouteName.supplierItemReturnDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {'info'}),
              ),
              BlocProvider(
                create: (context) => getIt<SupplierGetReturnDetailsCubit>(),
              ),
            ],
            child: SupplierItemReturnDetailsScreen(
              returnId: settings.arguments as String,
            ),
          ),
        );
      case AppRouteName.handoverScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final shiftArguments = args['shiftArguments'] as ShiftArguments;
        final isOpenedFromShiftDetailsScreen =
            args['isOpenedFromShiftDetailsScreen'] as bool?;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (_) => ValidationCubit(
                  requiredFields: {'cashierName', 'handOverAmount'},
                  optionalFields: {'notes'},
                ),
              ),
              BlocProvider(
                create: (_) =>
                    getIt<HandoverCubit>(param1: shiftArguments.shiftId),
              ),
            ],
            child: HandoverOnlyScreen(
              shiftArguments: shiftArguments,
              isOpenedFromShiftDetailsScreen:
                  isOpenedFromShiftDetailsScreen ?? false,
            ),
          ),
        );
      case AppRouteName.handoverSuccessScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final shift = args['shiftArguments'] as ShiftArguments;
        final isOpenedFromShiftDetailsScreen =
            args['isOpenedFromShiftDetailsScreen'] as bool?;

        return MaterialPageRoute(
          builder: (context) => HandoverSuccessWidget(
            shiftArguments: shift,
            isOpenedFromShiftDetailsScreen:
                isOpenedFromShiftDetailsScreen ?? false,
          ),
        );

      case AppRouteName.endManagerShiftScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final handovers = args['handovers'] as List<HandoverDetailsEntity>;
        final managerName = args['managerName'] as String;
        final managerCubit = args['managerCubit'] as ManagerShiftCubit;

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (_) => ValidationCubit(
                  requiredFields: {'cashierName', 'handOverAmount'},
                  optionalFields: {'notes'},
                ),
              ),
              BlocProvider(
                create: (_) => getIt<EndAndUpdateManagerShiftCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<FinalDailyCloseCubit>()..getDailyClose(managerWorkdayId: managerCubit.managerShift.shift.id),
              ),
              BlocProvider.value(value: managerCubit),
            ],
            child: EndManagerShiftScreen(
              handovers: handovers,
              managerName: managerName,
            ),
          ),
        );
      case AppRouteName.updateManagerFinalDailyCloseScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final branchName = args['branchName'] as String;
        final managerCubit = args['managerCubit'] as ManagerShiftCubit;

        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => getIt<EndAndUpdateManagerShiftCubit>(),
              ),
              BlocProvider(
                create: (_) => getIt<FinalDailyCloseCubit>()..getDailyClose(managerWorkdayId: args['manager_workday_id'] as String? ?? managerCubit.managerShift.shift.id),
              ),
              BlocProvider.value(value: managerCubit),
            ],
            child: UpdateManagerFinalDailyCloseScreen(branchName: branchName),
          ),
        );
      case AppRouteName.inventoryScreen:
        return MaterialPageRoute(
          builder: (context) => const InventoryScreen(),
          settings: settings,
        );
      case AppRouteName.dailyInventoryScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<GetDailyInventoryItemsCubit>(),
            child: const DailyInventoryScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.dailyInventoryChooseInventoryMethodScreen:
        final items = settings.arguments as List<DailyInventoryItem>? ?? [];
        return MaterialPageRoute(
          builder: (context) =>
              DailyInventoryChooseInventoryMethodScreen(items: items),
          settings: settings,
        );
      case AppRouteName.dailyPersonalInventory:
        final args = settings.arguments as DailyInventoryLocalModel;

        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ValidationCubit(
              requiredFields: {
                for (var i = 0; i < args.items.length; i++)
                  'quantity_${args.items[i].id}',
              },
              optionalFields: {
                for (var i = 0; i < args.items.length; i++)
                  'note_${args.items[i].id}',
              },
            ),
            child: DailyPersonalInventory(
              items: args.items,
              userType: args.userType,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.inventoryHowToSliderWorkScreen:
        return MaterialPageRoute(
          builder: (context) => const InventoryHowToSliderWorkScreen(),
          settings: settings,
        );
      case AppRouteName.inventorySliderScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ValidationCubit(
              requiredFields: {
                'sliderType',
                'sliderPercentage',
                'totalNumberOfMilkContainers',
                // 'volumePerContainer',
              },
            ),
            child: const InventorySliderScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.monthlyInventoryScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<GetMonthlySetupInfoCubit>(),
              ),
              BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
              BlocProvider(
                create: (context) => getIt<StartMonthlyInventoryCubit>(),
              ),
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {},
                  optionalFields: {'staffName', 'staffId'},
                ),
              ),
            ],
            child: const MonthlyInventoryScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.monthlyInventoryStartScreen:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments as MonthlyInventoryLocalModel;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ValidationCubit(requiredFields: {}),
                ),
                BlocProvider(
                  create: (context) => getIt<GetMonthlyCompletedProductsCubit>()
                    ..getMonthlyInventoryCompletedProducts(
                      inventoryId: args.sessionId,
                    ),
                ),
              ],
              child: MonthlyInventoryStartScreen(
                sessionId: args.sessionId,
                userType: args.userType,
              ),
            );
          },
          settings: settings,
        );
      case AppRouteName.monthlyInventoryPendingProductsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<GetMonthlyPendingProductsCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    SearchCubit<MonthlyInventoryPendingProduct>(),
              ),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {}),
              ),
              BlocProvider(
                create: (context) => getIt<UpdateQtyMonthlyInventoryBloc>(),
              ),
            ],
            child: MonthlyInventoryPendingProductsScreen(
              sessionId: settings.arguments as String,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.wastedInventoryScreen:
        return MaterialPageRoute(
          builder: (context) => const WastedInventoryScreen(),
          settings: settings,
        );
      case AppRouteName.wastedInventoryChooseInventoryMethodScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {}),
              ),
              BlocProvider(
                create: (context) => getIt<CreateWasteDamageCubit>(),
              ),
            ],
            child: const WastedInventoryChooseInventoryMethodScreen(),
          ),
          settings: settings,
        );
      // case AppRouteName.wastedMandatoryAwarenessScreen:
      //   return MaterialPageRoute(
      //     builder: (context) => const WastedMandatoryAwarenessScreen(),
      //     settings: settings,
      //   );
      case AppRouteName.wastedRegesterProductesScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<WastedSelectedItemsCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<CreateWasteDamageCubit>(),
              ),
              BlocProvider(
                create: (context) => ValidationCubit(requiredFields: {}),
              ),
            ],
            child: WastedRegesterProductesScreen(
              userType: settings.arguments as InventoryUserType,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.recurringOrdersScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<GetInProgressRecurringOrdersCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<GetNextScheduledRecurringOrdersCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<GetPausedRecurringOrdersCubit>(),
              ),
            ],
            child: const RecurringOrdersScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.recurringOrderDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (context) => getIt<GetRecurringOrderDetailsCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<RecurringOrderActionsCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    ValidationCubit(requiredFields: {'scheduleStatus'}),
              ),
            ],
            child: RecurringOrderDetailsScreen(
              orderId: settings.arguments as String,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.recurringOrderCreatedSuccessfullyScreen:
        return MaterialPageRoute(
          builder: (context) => const RecurringOrderCreatedSuccessfullyScreen(),
          settings: settings,
        );
      case AppRouteName.cashierMainScreen:
        return _cashierMainScreenRoute(settings);
      case AppRouteName.fixedAssetsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    getIt<GetFixedAssetsOverviewCubit>()..getOverview(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<FixedAssetsHandoverSessionRealtimeCubit>(),
              ),
            ],
            child: const FixedAssetsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.fixedAssetsReceiveAssetsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final args = settings.arguments as Map<String, dynamic>;
            final transferTypeStrategy =
                args['type'] as FixedAssetsTransferTypesStrategy;
            final requestId = args['requestId'] as String;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (_) =>
                      getIt<FixedAssetsGetReceiveAssetsCubit>()
                        ..getReceiveAssets(requestId: requestId),
                ),
                BlocProvider(
                  create: (_) => getIt<FixedAssetsReceiveAssetsCubit>(),
                ),
                BlocProvider(
                  create: (context) => ValidationCubit(requiredFields: {}),
                ),
              ],
              child: FixedAssetsReceiveAssetsScreen(
                transferTypeStrategy: transferTypeStrategy,
                requestId: requestId,
              ),
            );
          },
          settings: settings,
        );
      case AppRouteName.fixedAssetsSearchScreen:
        return MaterialPageRoute(
          builder: (context) => const FixedAssetsSearchScreen(),
          settings: settings,
        );
      case AppRouteName.fixedAssetsSearchResultScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ValidationCubit(requiredFields: {}),
            child: FixedAssetsSearchResultScreen(
              searchResults: settings.arguments as FixedAssetsSearchResponse,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.fixedAssetsModifyAssetStatusScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'newStatus',
                    'reason',
                    'photos',
                    'initialCheck',
                    'cleaning',
                    'next',
                    'approvalRequestOwnerNote',
                  },
                ),
              ),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(create: (context) => getIt<ModifyAssetCubit>()),
            ],
            child: FixedAssetsModifyAssetStatusScreen(
              asset: settings.arguments as FixedAssetsSearchItem,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.cashierNewAssignmentsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<GetTasksCubit>()..getTasks(),
            child: const CashierNewAssignmentsScreen(),
          ),
        );
      case AppRouteName.fixedAssetsRequestsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 4)),
              BlocProvider(
                create: (context) => getIt<FixedAssetsGetRequestsCubit>(),
              ),
            ],
            child: const FixedAssetsRequestsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerFixedAssetsRequestsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 5)),
            ],
            child: const BrandOwnerFixedAssetsRequestsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerFinancialReportingScreen:
        return MaterialPageRoute(
          builder: (context) => const BrandOwnerFinancialReportingScreen(),
          settings: settings,
        );
      case AppRouteName.brandOwnerProfitAndLossStatementScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<ProfitAndLossStatementCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<ExportProfitAndLossStatementCubit>(),
              ),
            ],
            child: const BrandOwnerProfitAndLossStatementScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerSalesChannelAnalysisScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<SalesChannelAnalysisCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<ExportSalesChannelAnalysisCubit>(),
              ),
            ],
            child: const BrandOwnerSalesChannelAnalysisScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerSalesChannelLevel2Screen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getIt<SalesChannelLevel2Cubit>(),
            child: const BrandOwnerSalesChannelLevel2Screen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerSmartComparisonsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<SmartComparisonCubit>()),
              BlocProvider(
                create: (context) => getIt<ExportSmartComparisonCubit>(),
              ),
            ],
            child: const BrandOwnerSmartComparisonsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerProfitVsCashReconciliationScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<ProfitVsCashReconciliationCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<ExportProfitVsCashReconciliationCubit>(),
              ),
            ],
            child: const BrandOwnerProfitVsCashReconciliationScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerBreakEvenAnalysisScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<BreakEvenAnalysisCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<ExportBreakEvenAnalysisCubit>(),
              ),
            ],
            child: const BrandOwnerBreakEvenAnalysisScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerOperationalProfitabilityScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<OperationalProfitabilityCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<ExportOperationalProfitabilityCubit>(),
              ),
            ],
            child: const BrandOwnerOperationalProfitabilityScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerMenuEngineeringScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<MenuEngineeringCubit>()),
              BlocProvider(
                create: (context) => getIt<ExportMenuEngineeringCubit>(),
              ),
            ],
            child: const BrandOwnerMenuEngineeringScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerPriceSimulatorScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<BrandOwnerBranchesForFilterCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<PriceSimulatorScreenCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<PriceSimulatorItemsCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<PriceSimulatorSavedScenariosCubit>(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<PriceSimulatorScenarioDetailsCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<PriceSimulatorSaveScenarioCubit>(),
              ),
            ],
            child: const BrandOwnerPriceSimulatorScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerTestItemScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => getIt<BrandOwnerBranchesForFilterCubit>(),
              ),
              BlocProvider(
                create: (context) => getIt<ItemTestScreenCubit>(),
              ),
            ],
            child: const BrandOwnerTestItemScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.fixedAssetsTransfersAndDisposalScreen:
        return MaterialPageRoute(
          builder: (context) {
            final args = FixedAssetsTransfersAndDisposalArguments.from(
              settings.arguments,
            );

            final validationCubit = ValidationCubit(
              requiredFields: {
                'requestType',
                'acknowledgments1',
                'acknowledgments2',
              },
            );

            args.applyTo(validationCubit);

            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: validationCubit),
                BlocProvider(
                  create: (context) =>
                      getIt<FixedAssetsGetZoneAndTypeCubit>()..getAllAssets(),
                ),
                BlocProvider(
                  create: (context) => SearchCubit<FixedAssetsSearchItem>(),
                ),
                BlocProvider(
                  create: (context) => getIt<TransferOrDisposeAssetsCubit>(),
                ),
              ],
              child: FixedAssetsTransfersAndDisposalScreen(
                strategy: args.strategy,
                assets: args.assets,
              ),
            );
          },
          settings: settings,
        );
      case AppRouteName.fixedAssetsTransferDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (context) => getIt<FixedAssetsTransferDetailsCubit>()
                  ..getTransferDetails(
                    requestId: settings.arguments as String? ?? '',
                  ),
              ),
            ],
            child: const FixedAssetsTransferDetailsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.fixedAssetsDisposalsDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (context) => getIt<FixedAssetsDisposalsDetailsCubit>()
                  ..getDisposalsDetails(
                    requestId: settings.arguments as String? ?? '',
                  ),
              ),
            ],
            child: const FixedAssetsDisposalsDetailsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.fixedAssetsHandoverScreen:
        return MaterialPageRoute(
          builder: (context) {
            final statusFilter =
                settings.arguments as String? ??
                FixedAssetsHandoverStatusFilterEnum.global.value;

            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ValidationCubit(
                    requiredFields: {
                      'responsibleId',
                      'selectedAssetIds',
                      'sendInvitations',
                      'confirmRecipientInPerson',
                      'confirmAssetsReady',
                      'note',
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<GetHandoverIncludedZonesCubit>()
                        ..getHandoverIncludedZones(statusFilter: statusFilter),
                ),
                BlocProvider(
                  create: (context) => getIt<FixdAssetsStartHandoverCubit>(),
                ),
              ],
              child: const FixedAssetsHandoverScreen(),
            );
          },
          settings: settings,
        );
      case AppRouteName.fixedAssetsJoinHandoverScreen:
        return MaterialPageRoute(
          builder: (context) {
            final sessionId = settings.arguments as String? ?? '';
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ValidationCubit(
                    requiredFields: {
                      'confirmTransferPolicy',
                      'confirmReviewedAssetList',
                    },
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<GetJoinHandoverSessionDetailsCubit>()
                        ..getJoinHandoverSessionDetails(sessionId: sessionId),
                ),
                BlocProvider(
                  create: (context) => getIt<FixdAssetsJoinHandoverCubit>(),
                ),
              ],
              child: FixedAssetsJoinHandoverScreen(sessionId: sessionId),
            );
          },
          settings: settings,
        );
      case AppRouteName.fixedAssetsActiveHandoverSessionScreen:
        return MaterialPageRoute(
          builder: (context) {
            final sessionId = settings.arguments as String? ?? '';
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      getIt<GetActiveHandoverSessionDetailsCubit>()
                        ..getActiveHandoverSessionDetails(sessionId: sessionId),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<FixdAssetsActiveHandoverApprovalCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<GetActiveHandoverSessionPreviewAssetsCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<ConfirmActiveHandoverSignatureCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<GetActiveHandoverSessionSignatureCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<GetActiveHandoverSessionSummaryCubit>(),
                ),
                BlocProvider(
                  create: (context) => getIt<CompleteHandoverSessionCubit>(),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<FixedAssetsHandoverSessionRealtimeCubit>(),
                ),
                BlocProvider(
                  create: (context) => ValidationCubit(requiredFields: {}),
                ),
                BlocProvider(create: (context) => PagingCubit(totalSteps: 4)),
              ],
              child: FixedAssetsActiveHandoverSessionScreen(
                sessionId: sessionId,
              ),
            );
          },
          settings: settings,
        );
      case AppRouteName.fixedAssetsHandoverDetailsScreen:
        return MaterialPageRoute(
          builder: (context) {
            final handoverId = settings.arguments as String;

            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
                BlocProvider(
                  create: (context) =>
                      getIt<GetFixedAssetsHandoverDetailsCubit>()
                        ..getHandoverDetails(handoverId: handoverId),
                ),
                BlocProvider(
                  create: (context) =>
                      getIt<FixedAssetsHandoverSessionRealtimeCubit>(),
                ),
              ],
              child: FixedAssetsHandoverDetailsScreen(handoverId: handoverId),
            );
          },
          settings: settings,
        );
      case AppRouteName.brandOwnerPaymentScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ValidationCubit(
                  requiredFields: {
                    'handoverRecipientId',
                    'handoverRecipientName',
                    'recipientType',
                    'handoverAmount',
                    'handoverOrTransferDate',
                    'preferredReceiptMethod',
                  },
                  optionalFields: {'additionalNote', 'purposeOfTransfer'},
                ),
              ),
              BlocProvider(create: (context) => getIt<ChooseItemCubit>()),
              BlocProvider(create: (context) => getIt<MediaCubit>()),
              BlocProvider(
                create: (context) => getIt<BrandOwnerPaymentCubit>(),
              ),
            ],
            child: const BrandOwnerPaymentScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerPaymentLogScreen:
        return MaterialPageRoute(
          builder: (context) => const BrandOwnerPaymentLogScreen(),
          settings: settings,
        );
      case AppRouteName.brandOwnerInventoryManagementScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
            ],
            child: const BrandOwnerInventoryManagementScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerEscalationRequestsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
              BlocProvider(
                create: (context) =>
                    getIt<GetPendingEscelationsCubit>()
                      ..getInprogressEscelations(),
              ),
              BlocProvider(
                create: (context) =>
                    getIt<GetCompletedEscelationsCubit>()
                      ..getCompletedEscelations(),
              ),
            ],
            child: const BrandOwnerEscalationRequestsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.branchManagerViewReportsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 2)),
            ],
            child: const BranchManagerViewReportsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.branchManagerViewReportsPriceComparisonDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                getIt<BranchManagerCreateOrderWithRecommendedSourceCubit>(),
            child: BranchManagerViewReportsPriceComparisonDetailsScreen(
              comparisonId: settings.arguments as String,
            ),
          ),
          settings: settings,
        );
      case AppRouteName.branchManagerSettingAndAggregatorsScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
              BlocProvider(
                create: (context) =>
                    getIt<BranchManagerSettingAndAggregatorsCubit>()
                      ..loadData(),
              ),
            ],
            child: const BranchManagerSettingAndAggregatorsScreen(),
          ),
          settings: settings,
        );
      case AppRouteName.brandOwnerFixedAssetsControlPanalScreen:
        return MaterialPageRoute(
          builder: (context) => const BrandOwnerFixedAssetsControlPanalScreen(),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Unknown Route')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
