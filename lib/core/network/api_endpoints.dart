import 'package:flutter/foundation.dart';

class ApiEndpoint {
  ApiEndpoint._();

  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const bool isDemoBuild = bool.fromEnvironment(
    'DEMO_MODE',
    defaultValue: false,
  );

  static const bool rejectLegacyProdHosts = bool.fromEnvironment(
    'REJECT_LEGACY_PROD_HOSTS',
    defaultValue: true,
  );

  /// Normalizes and validates the API base URL according to strict staging/demo requirements.
  /// Enforces scheme, normalizes path to end with '/api/v1/', prevents empty configurations (fails closed),
  /// and forbids legacy Hostinger production hosts.
  static String normalizeBaseUrl(
    String url, {
    bool? demo,
    bool? forbidLegacyProd,
  }) {
    final isDemo = demo ?? isDemoBuild;
    final rejectLegacy = forbidLegacyProd ?? rejectLegacyProdHosts;
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      throw StateError(
        'Missing required build-time API base URL. Configure with --dart-define=API_BASE_URL=<url>',
      );
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        !uri.hasScheme ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw FormatException(
        'Invalid API base URL: must have http or https scheme ($trimmed)',
      );
    }

    if ((isDemo || rejectLegacy) &&
        (uri.host.contains('hostingersite.com') ||
            trimmed.contains('ivory-snail-183262'))) {
      throw StateError(
        'Legacy Hostinger production host is strictly forbidden: $trimmed',
      );
    }

    var path = uri.path;
    if (path.isEmpty || path == '/') {
      path = '/api/v1/';
    } else {
      if (!path.endsWith('/')) {
        path = '$path/';
      }
      if (!path.endsWith('/api/v1/')) {
        if (path.endsWith('/api/')) {
          path = '${path}v1/';
        } else {
          path = '${path}api/v1/';
        }
      }
    }
    // Clean any accidental duplicate slashes in the path
    path = path.replaceAll(RegExp(r'/+'), '/');

    return uri.replace(path: path).toString();
  }

  /// Derives the Pusher broadcasting auth endpoint on the same host and scheme as the given API URL.
  static String derivePusherAuthUrl(String apiUrl) {
    final uri = Uri.parse(apiUrl);
    return uri.replace(path: '/broadcasting/auth').toString();
  }

  /// Compile-time constant for Retrofit source definitions.
  static const String baseUrl = _envBaseUrl;

  /// Validated base URL for runtime client initialization.
  @visibleForTesting
  static String? debugTestBaseUrl;

  static String get validatedBaseUrl =>
      normalizeBaseUrl(debugTestBaseUrl ?? _envBaseUrl);

  /// Pusher auth URL evaluated on the same host as the active API base URL.
  static String get pusherAuth =>
      (debugTestBaseUrl ?? _envBaseUrl).isNotEmpty ? derivePusherAuthUrl(validatedBaseUrl) : '';

  static const String branchManager = 'branch-manager/';
  static const String auth = 'auth';
  static const String branchManagerFirstLogin =
      '$branchManager$auth/first-login';
  static const String branchManagerResetPasswordFirstLogin =
      '$branchManager$auth/reset-password-first-login';
  static const String branchManagerLogin = '$branchManager$auth/login';
  static const String branchManagerForgotPassword =
      '$branchManager$auth/forgot-password';
  static const String branchManagerVerifyOtp = '$branchManager$auth/verify-otp';
  static const String branchManagerResetPasswordUsingOtp =
      '$branchManager$auth/reset-password';
  static const String branchManagerLogout = '$branchManager$auth/logout';
  static const String branchManagerMe = '$branchManager$auth/me';
  static const String branchManagerExpenses = '${branchManager}expenses';
  static const String branchManagerExpensesDraft =
      '$branchManagerExpenses/drafts';
  static const String branchManagerExpensesQuickCash =
      '$branchManagerExpenses/quick-cash';
  static const String branchManagerExpensesSingleInvoice =
      '$branchManagerExpenses/single-invoice';
  static const String branchManagerExpensesPreApproval =
      '$branchManagerExpenses/pre-approval';
  static const String branchManagerExpensesGroupedInvoice =
      '$branchManagerExpenses/grouped-invoice';
  static const String branchManagerExpensesSearch =
      '$branchManagerExpenses/search';
  static const String branchManagerExpensesSuppliers =
      '$branchManagerExpenses/suppliers';
  static const String branchManagerExpensesCategories =
      '$branchManagerExpenses/categories';
  static const String branchManagerExpensesSummary =
      '$branchManagerExpenses/summary';
  static const String branchManagerExpensesRecent =
      '$branchManagerExpenses/recent';
  static const String branchManagerExpensesCreateQuickCash =
      '$branchManagerExpenses/quick-cash';
  static const String branchManagerExpensesCreateSingleInvoice =
      '$branchManagerExpenses/single-invoice';
  static const String branchManagerExpensesCreatePreApproval =
      '$branchManagerExpenses/pre-approval';
  static const String branchManagerExpensesCreateGroupedInvoice =
      '$branchManagerExpenses/grouped-invoice';
  static const String branchManagerExpensesPreviousSingleInvoice =
      '$branchManagerExpensesSingleInvoice/previous';
  static const String branchManagerExpensesPreviousPreApproval =
      '$branchManagerExpensesCreatePreApproval/previous';
  static const String branchManagerExpensesCustodyBalance =
      '$branchManagerExpenses/custody-balance';
  static const String branchManagerCashiers = '${branchManager}cashiers';

  // Retain the legacy public name used by existing Retrofit declarations.
  // ignore: constant_identifier_names
  static const String Aggregators = 'aggregators';

  // =================== Branch Manager Settings & Aggregators ===================
  static const String branchManagerSettings = '${branchManager}settings';
  static const String branchManagerSettingsAccountDetails =
      '$branchManagerSettings/account-details';
  static const String branchManagerSettingsAggregators =
      '$branchManagerSettings/aggregators';
  static const String branchManagerSettingsAggregatorsAvailable =
      '$branchManagerSettingsAggregators/available';
  static const String branchManagerSettingsAggregatorsAssigned =
      '$branchManagerSettingsAggregators/assigned';
  static const String branchManagerSettingsAggregatorsItem =
      '$branchManagerSettingsAggregators/{aggregatorId}';
  static const String branchManagerSettingsAggregatorsItemStatus =
      '$branchManagerSettingsAggregators/{aggregatorId}/status';

  static const String branchManagerSettingsNotifications =
      '$branchManagerSettings/notifications';
  static const String branchManagerSettingsNotificationsShiftVarianceAlerts =
      '$branchManagerSettingsNotifications/shift-variance-alerts';
  static const String
  branchManagerSettingsNotificationsDailyInventoryReminders =
      '$branchManagerSettingsNotifications/daily-inventory-reminders';
  static const String
  branchManagerSettingsNotificationsApprovedAggregatorsOnly =
      '$branchManagerSettingsNotifications/approved-aggregators-only';
  static const String branchManagerSettingsNotificationsAssetTransferRequests =
      '$branchManagerSettingsNotifications/asset-transfer-requests';
  static const String
  branchManagerSettingsNotificationsAllowSplitShiftHandovers =
      '$branchManagerSettingsNotifications/allow-split-shift-handovers';

  static const String branchManagerSettingsResetPassword =
      '$branchManagerSettings/reset-password';

  static const String branchManagerCashiersAvailableForShifts =
      '$branchManagerCashiers/available-cashiers';

  //  =================== Shift Management Endpoints ===================

  static const String branchManagerShifts = '${branchManager}shifts';
  static const String branchManagerBranches = '${branchManager}branches';

  // Branch Manager — Price Comparison
  static const String branchManagerPriceComparisons =
      '${branchManager}price-comparisons';
  static const String branchManagerPriceComparisonDetails =
      '$branchManagerPriceComparisons/{comparisonId}';
  static const String branchManagerPriceComparisonExport =
      '$branchManagerPriceComparisonDetails/export';
  static const String branchManagerPriceComparisonCreateOrder =
      '$branchManagerPriceComparisonDetails/orders';

  static const String branchManagerAllCashierShifts =
      '$branchManagerShifts/cashiers';

  static const String branchManagerPendingShifts =
      '$branchManagerShifts/pending';

  static const String branchManagerInProgressShifts =
      '$branchManagerShifts/in-progress';

  static const String branchManagerCompletedShifts =
      '$branchManagerShifts/completed';

  // =================== Cashier Endpoints ===================
  static const String cashier = 'cashier/';

  static const String cashierLogin = '$cashier$auth/login';
  static const String cashierFirstLogin = '$cashier$auth/first-login';
  static const String cashierActivate = '$cashier$auth/activate';
  static const String cashierResetPasswordFirstLogin =
      '$cashier$auth/reset-password-first-login';
  static const String cashierVerifyOtp = '$cashier$auth/verify-otp';
  static const String cashierResetPassword = '$cashier$auth/reset-password';
  static const String cashierForgotPassword = '$cashier$auth/forgot-password';
  static const String cashierMe = '${cashier}profile';
  static const String cashierLogout = '${cashier}logout';
  static const String cashierShifts = '${cashier}shifts';
  static const String cashierMyInfo = '${cashier}my-info';
  static const String cashierBranchInfo = '${cashier}branch-info';

  // =================== BranchManager Workday Endpoints ===================
  static const String branchWorkDayMgmt = '${branchManager}workday';

  /// =================== Purchase Endpoints ===================
  static const String purchase = 'purchase/';
  static const String purchaseOrders = '${purchase}orders/';
  static const String purchaseBranchItems = '${purchaseOrders}branch-items';
  static const String purchaseBranches = '${purchaseOrders}branches';
  static const String purchaseSuppliers = '${purchase}suppliers';
  static const String purchaseTransferItems = '${purchaseOrders}transfer-items';
  static const String purchasePurchasingOfficerItems =
      '${purchaseOrders}purchasing-officer-items';
  static const String purchaseDirectSupplierItems =
      '${purchaseOrders}direct-supplier-items';
  static const String purchaseSupplierItems = '${purchaseOrders}supplier-items';
  static const String purchaseCreateOrder = '${purchase}orders';
  static const String purchaseHistory = '${purchase}history';
  static const String purchaseComparePrices = '${purchaseOrders}compare-prices';
  static const String purchaseComparePricesSave =
      '${purchaseOrders}compare-prices/save';
  static const String purchasePending = '${purchase}pending/';
  static const String purchaseApproveRequest = 'approve';
  static const String purchasePartialApproveRequest = 'partial-approve';
  static const String purchaseRejectRequest = 'reject';
  static const String purchaseCancelItem =
      '${purchase}pending/{order_id}/items/{item_id}/cancel';
  static const String purchaseModification =
      '${purchase}pending/{id}/items/{itemId}/modification';
  static const String purchaseCancellationReason =
      '${purchase}pending/{id}/items/{itemId}/cancellation-reason';
  static const String purchaseApproveModification =
      '${purchase}pending/{order_id}/items/{item_id}/approve';
  static const String purchaseRejectModification =
      '${purchase}pending/{id}/items/{itemId}/cancel';
  static const String purchaseCancelOrder = '${purchase}pending/{id}/cancel';
  static const String purchaseReceivingOrdersInProgress =
      '${purchase}receiving/orders';
  static const String purchaseReceivingOrdersCompleted =
      '${purchase}receiving/completed';
  static const String purchaseReceivingOrdersMissing =
      '${purchase}receiving/missing';
  static const String purchaseReceivingOrderInspection =
      '${purchase}receiving/orders/{orderId}/inspection';
  static const String purchaseReceivingSupplierOrderStart =
      '${purchase}receiving/orders/{orderId}/start';
  static const String purchaseReceivingBranchOrderStart =
      '${purchase}receiving/orders/{orderId}/receive-internal-transfer';
  static const String purchaseCreateReturns = '${purchase}returns';
  static const String purchaseAcceptReturnRejection =
      '${purchase}returns/{id}/accept-rejection';
  static const String purchaseEscalateReturn =
      '${purchase}returns/{id}/escalate';
  static const String purchaseInProgressReturns =
      '${purchase}returns/in-progress';
  static const String purchaseCompletedReturns = '${purchase}returns/completed';
  static const String purchaseReturnDetails = '${purchase}returns/{id}';
  static const String purchaseOrderTracking =
      '${purchase}receiving/orders/{orderId}/tracking';
  static const String purchaseApproveDelay =
      '${purchase}pending/direct-supplier/{id}/approve-delay';
  static const String purchaseRejectDelay =
      '${purchase}pending/direct-supplier/{id}/reject-delay';
  static const String purchaseSubmitOrderDraft =
      '${purchase}orders/{id}/submit';
  static const String purchaseDeleteOrderDraft = '${purchase}orders/{id}/draft';
  static const String purchaseSuppliersForFilterPurchaseItems =
      '${purchase}suppliers';

  /// =================== Branch Manager Requests Endpoints ===================
  static const String branchManagerOrders = '${purchase}orders';
  static const String branchManagerRequestsHandovers =
      '${branchManager}requests/handovers';
  static const String branchManagerRequestsVariances =
      '${branchManager}requests/variances';

  static const String cashierRequestsReassignedShifts =
      '${cashier}requests/reassigned-shifts';

  /// =================== Custody Endpoints ===================
  static const String custody = 'custody/';
  static const String custodyRequestCashIn = '${custody}request-cashin';
  static const String custodyRequestCashInHistory =
      '$custodyRequestCashIn/history';
  static const String custodyRequestTransfer = '${custody}transfer';
  static const String custodyRequests = '${custody}requests';
  static const String custodyRequestsHistory =
      '${custody}request-cashin/history';
  static const String custodyPersonalBalanceOnly =
      '${branchManager}ledger/personal-balance-only';
  static const String custodyPersonalBalance =
      '${branchManager}ledger/personal-custody-balance';
  static const String custodyPersonalBalanceTransactions =
      '${branchManager}ledger/transactions';
  static const String custodyPersonalBalanceTransactionsExportPdf =
      '${branchManager}ledger/export-pdf';
  static const String custodyBranchTransactions = '${custody}transactions';
  static const String custodyBranchBalance =
      '${branchManager}ledger/branch-custody-balance';
  static const String custodyHandoverToCashier = '${custody}handover';
  static const String custodyGetBalanceTrendState = '${custody}balance-trends';
  static const String custodyGetRecipients = '${custody}recipients';
  static const String custodyRequestDetails = '${custody}requests/{id}';

  // =================== Brand Owner Auth Endpoints ===================
  static const String brandOwner = 'brand-owner/';
  static const String brandOwnerAuth = '$brandOwner$auth/';
  static const String brandOwnerFirstLogin = '${brandOwnerAuth}first-login';
  static const String brandOwnerLogin = '${brandOwnerAuth}login';
  static const String brandOwnerForgotPassword =
      '${brandOwnerAuth}forgot-password';
  static const String brandOwnerVerifyOtp = '${brandOwnerAuth}verify-otp';
  static const String brandOwnerResetPasswordUsingOtp =
      '${brandOwnerAuth}reset-password';
  static const String brandOwnerResetPasswordFirstLogin =
      '${brandOwnerAuth}reset-password-first-login';
  static const String brandOwnerLogout = '${brandOwnerAuth}logout';
  static const String brandOwnerMe = '${brandOwnerAuth}me';

  // =================== Brand Owner Endpoints ===================
  static const String brandOwnerPaymentForm = '${brandOwner}payment-form';
  static const String brandOwnerPaymentLogs = '${brandOwner}payment-logs';
  static const String brandOwnerPaymentLogDetails =
      '${brandOwner}payment-logs/{id}';
  static const String brandOwnerCashSalesTransfers =
      '${brandOwner}cash-sales-transfers';
  static const String brandOwnerCashSalesTransferDetails =
      '${brandOwner}cash-sales-transfers/{transferId}';
  static const String brandOwnerExpensesApprove =
      '${brandOwner}expenses/{id}/approve';
  static const String brandOwnerExpensesReject =
      '${brandOwner}expenses/{id}/reject';
  static const String brandOwnerCustodyRequestsApprove =
      'custody/requests/{id}/approve';
  static const String brandOwnerCustodyRequestsReject =
      'custody/requests/{id}/reject';
  static const String brandOwnerCashSalesTransfersApprove =
      '${brandOwner}cash-sales-transfers/{id}/approve';
  static const String brandOwnerCashSalesTransfersReject =
      '${brandOwner}cash-sales-transfers/{id}/reject';
  static const String brandOwnerPurchaseReturnsApproveEscalation =
      '${brandOwner}purchase/returns/{returnId}/approve-escalation';
  static const String brandOwnerPurchaseReturnsRejectEscalation =
      '${brandOwner}purchase/returns/{returnId}/reject-escalation';
  static const String brandOwnerHomeDashboard = '${brandOwner}dashboard';
  static const String brandOwnerBranchesDashboard =
      '$brandOwnerHomeDashboard/branches';

  /// =================== Supplier ===================
  static const String suppliers = 'supplier/';
  static const String supplierAuth = '$suppliers$auth/';
  static const String supplierLogin = '${supplierAuth}login';
  static const String supplierActiveAccount = '${supplierAuth}first-login';
  static const String supplierResetPasswordFirstLogin =
      '${supplierAuth}password/reset/first-login';
  static const String supplierSendOtp =
      '${supplierAuth}password/reset/send-otp';
  static const String supplierVerifyOtp =
      '${supplierAuth}password/reset/verify-otp';
  static const String supplierResetPassword = '${supplierAuth}password/reset';
  static const String supplierLogout = '${supplierAuth}logout';
  static const String supplierMe = '${supplierAuth}me';
  static const String supplierOrders = '${suppliers}orders';
  static const String supplierPartialConfirmItem =
      '${suppliers}pending-orders/{id}/partial-approve';
  static const String supplierFullConfirmItem =
      '${suppliers}pending-orders/{orderId}/items/{itemId}/confirm';
  static const String supplierCancelItem =
      '${suppliers}pending-orders/{orderId}/items/{itemId}/cancel';
  static const String supplierConfirmOrder = '${suppliers}orders/{id}/accept';
  static const String supplierCancelOrder = '${suppliers}orders/{id}/reject';
  static const String supplierNeedTimeItem =
      '${suppliers}pending-orders/{id}/items/{itemId}/request-time-change';
  static const String supplierAlternativeProductItem =
      '${suppliers}pending-orders/{id}/items/{itemId}/request-alternative';
  static const String supplierItems = '${suppliers}orders/supplier-items';
  static const String supplierCancellationReason =
      '${suppliers}pending-orders/{id}/items/{itemId}/cancellation-reason';
  static const String supplierModification =
      '${suppliers}pending-orders/{id}/items/{itemId}/modification';
  static const String supplierStartPreparingOrder =
      '${suppliers}fulfillment/start-preparation';
  static const String supplierMarkOrderAsDelivery =
      '${suppliers}fulfillment/orders/{order_id}/start-delivery';
  static const String supplierRepostDelayOrder =
      '${suppliers}fulfillment/orders/{order_id}/report-delay';
  static const String supplierMarkOrderAsDelivered =
      '${suppliers}fulfillment/orders/{order_id}/complete';
  static const String supplierReturns = '${suppliers}returns';
  static const String supplierReturnDetails = '${suppliers}returns/{id}';
  static const String supplierReturnReject = '${suppliers}returns/{id}/reject';
  static const String supplierReturnApprove =
      '${suppliers}returns/{id}/approve';

  // =================== Inventory Endpoints ===================
  static const String inventory = 'inventory/';
  static const String inventoryDailyQuickBranchItems =
      '${inventory}daily-quick/branch-items';
  static const String inventorycreateDaily = '${inventory}daily-quick/sessions';
  static const String inventoryEmployees = '${inventory}daily-quick/employees';
  static const String inventoryDailyQuickSessions =
      '${inventory}daily-quick/sessions';
  static const String inventoryWasteDamageProductsFromClosedOrders =
      '${inventory}waste-damage/products-from-closed-orders';
  static const String inventoryWasteDamageReports =
      '${inventory}waste-damage/reports';
  static const String inventoryWasteDamageListReports =
      '${inventory}waste-damage/reports';
  static const String inventoryMonthlySetupInfo =
      '${inventory}monthly/setup-info';
  static const String inventoryMonthly = '${inventory}monthly';
  static const String inventoryMonthlyProducts =
      '${inventory}monthly/{id}/products';
  static const String inventoryMonthlyProductsUpdate =
      '${inventory}monthly/{id}/products/{productId}';
  static const String inventoryMonthlyProgress =
      '${inventory}monthly/{id}/progress';
  static const String inventoryMonthlyDetails = '${inventory}monthly/{id}';
  static const String inventoryTasks = '${inventory}tasks';
  static const String inventoryMonthlySubmit =
      '${inventory}monthly/{id}/submit';

  // =================== Recurring Orders Endpoints ===================
  static const String recurringOrders = 'recurring-orders';
  static const String recurringOrdersInProgress =
      '$recurringOrders/in-progress';
  static const String recurringOrdersNextScheduling =
      '$recurringOrders/next-scheduling';
  static const String recurringOrdersPaused = '$recurringOrders/paused';

  // =================== Cashier Shifts Endpoints ===================
  static const String cashierMyShifts = '${cashier}my-shifts';
  static const String cashierMyPendingShifts = '$cashierMyShifts/pending';
  static const String cashierMyCompletedShifts = '$cashierMyShifts/completed';
  static const String cashierMyReassignedShifts = '$cashierMyShifts/reassigned';
  static const String cashierMyInProgressShifts =
      '$cashierMyShifts/in-progress';

  // =================== Brand Owner Inventory Management Endpoints ===================
  static const String brandOwnerInventory = '${brandOwner}inventory/';

  static const String brandManagerInventoryDailyRequests =
      '${brandOwnerInventory}daily-requests';

  static const String brandManagerInventoryDailyRequestDetails =
      '${brandOwnerInventory}daily-requests/{requestId}';

  static const String brandManagerInventoryDailyRequestApprove =
      '${brandOwnerInventory}daily-requests/{requestId}/approve';

  static const String brandManagerInventoryDailyRequestReject =
      '${brandOwnerInventory}daily-requests/{requestId}/reject';

  static const String brandManagerInventoryWasteDamageRequests =
      '${brandOwnerInventory}waste-damage-requests';

  static const String brandManagerInventoryWasteDamageRequestDetails =
      '${brandOwnerInventory}waste-damage-requests/{requestId}';

  static const String brandManagerInventoryWasteDamageRequestApprove =
      '${brandOwnerInventory}waste-damage-requests/{requestId}/approve';

  static const String brandManagerInventoryWasteDamageRequestReject =
      '${brandOwnerInventory}waste-damage-requests/{requestId}/reject';

  // =================== Fixed Assets Endpoints ===================
  static const String fixedAssets = '${branchManager}fixed-assets';
  static const String fixedAssetsZones = '$fixedAssets/zones';
  static const String fixedAssetsTypes = '$fixedAssets/types';
  static const String fixedAssetsEmployees = '$fixedAssets/employees';
  static const String fixedAssetsBranches = '$fixedAssets/branches';
  static const String fixedAssetsAssets = '$fixedAssets/assets';
  static const String fixedAssetsSearch = '$fixedAssetsAssets/search';
  static const String fixedAssetsSearchByImage =
      '$fixedAssetsAssets/search-image';
  static const String fixedAssetsReceiveAssets = '$fixedAssets/receive-assets';
  static const String fixedAssetsReceiveAssetsConfirm =
      '$fixedAssetsReceiveAssets/confirm';
  static const String fixedAssetsTransferDisposalRequests =
      '$fixedAssets/requests/transfer-disposal';
  static const String fixedAssetsModificationRequests =
      '$fixedAssets/requests/modifications';
  static const String fixedAssetsTransfersRequests =
      '$fixedAssets/requests/transfers';
  static const String fixedAssetsDisposalsRequests =
      '$fixedAssets/requests/disposals';
  static const String fixedAssetsHandoversRequests =
      '$fixedAssets/requests/handovers';
  static const String fixedAssetsOverview = '$fixedAssets/overview';
  static const String fixedAssetsAssetHistory =
      '$fixedAssetsAssets/{assetId}/history';
  static const String fixedAssetsAssetHistoryReport =
      '$fixedAssetsAssets/{assetId}/history/report';

  // Fixed Assets Handover
  static const String fixedAssetsHandover = '$fixedAssets/handover';
  static const String fixedAssetsHandoverIncludedZones =
      '$fixedAssetsHandover/included-zones';
  static const String fixedAssetsHandoverStart = '$fixedAssetsHandover/start';
  static const String fixedAssetsHandoverSessions =
      '$fixedAssetsHandover/sessions';
  static const String fixedAssetsHandoverSessionJoinDetails =
      '$fixedAssetsHandoverSessions/{sessionId}/join-details';
  static const String fixedAssetsHandoverSessionJoin =
      '$fixedAssetsHandoverSessions/{sessionId}/join';
  static const String fixedAssetsHandoverSessionDetails =
      '$fixedAssetsHandoverSessions/{sessionId}/details';
  static const String fixedAssetsHandoverSessionApproveZone =
      '$fixedAssetsHandoverSessions/{sessionId}/approve-zone';
  static const String fixedAssetsHandoverSessionApproveAll =
      '$fixedAssetsHandoverSessions/{sessionId}/approve-all';
  static const String fixedAssetsHandoverSessionSignatureReceiver =
      '$fixedAssetsHandoverSessions/{sessionId}/signature/receiver';
  static const String fixedAssetsHandoverSessionSignatureSender =
      '$fixedAssetsHandoverSessions/{sessionId}/signature/sender';
  static const String fixedAssetsHandoverSessionSignature =
      '$fixedAssetsHandoverSessions/{sessionId}/signature';
  static const String fixedAssetsHandoverSessionPreview =
      '$fixedAssetsHandoverSessions/{sessionId}/preview';
  static const String fixedAssetsHandoverSessionSummary =
      '$fixedAssetsHandoverSessions/{sessionId}/summary';
  static const String fixedAssetsHandoverSessionComplete =
      '$fixedAssetsHandoverSessions/{sessionId}/complete';
  static const String fixedAssetsHandoverDetails =
      '$fixedAssetsHandover/{handoverId}';

  // =================== Brand Owner Reports and Analytics Endpoints ===================
  static const String brandOwnerReportsAndAnalytics =
      '${brandOwner}reports-and-analytics';
  static const String brandOwnerExpenseReportDetails =
      '${brandOwner}reports/expense/{reportId}';
  static const String brandOwnerCustodyReportDetails =
      '${brandOwner}reports/custody/{reportId}';
  static const String brandOwnerExportExpenseReport =
      '${brandOwner}reports/expense/export';
  static const String brandOwnerExportCustodyReport =
      '${brandOwner}reports/custody/export';
  static const String brandOwnerBranches = '${brandOwner}branches';

  // =================== Brand Owner Fixed Assets Requests Endpoints ===================
  static const String brandOwnerFixedAssetsRequests =
      '${brandOwner}fixed-assets/requests/';

  // Modification
  static const String brandOwnerFixedAssetsModificationRequests =
      '${brandOwnerFixedAssetsRequests}modification';
  static const String brandOwnerFixedAssetsModificationDetails =
      '$brandOwnerFixedAssetsModificationRequests/{id}';
  static const String brandOwnerFixedAssetsModificationApprove =
      '$brandOwnerFixedAssetsModificationRequests/{id}/approve';
  static const String brandOwnerFixedAssetsModificationReject =
      '$brandOwnerFixedAssetsModificationRequests/{id}/reject';

  // Transfer
  static const String brandOwnerFixedAssetsTransferRequests =
      '${brandOwnerFixedAssetsRequests}transfer';
  static const String brandOwnerFixedAssetsTransferDetails =
      '$brandOwnerFixedAssetsTransferRequests/{id}';
  static const String brandOwnerFixedAssetsTransferApprove =
      '$brandOwnerFixedAssetsTransferRequests/{id}/approve';
  static const String brandOwnerFixedAssetsTransferReject =
      '$brandOwnerFixedAssetsTransferRequests/{id}/reject';

  // Disposal & External Transfer
  static const String brandOwnerFixedAssetsDisposalRequests =
      '${brandOwnerFixedAssetsRequests}disposal-and-external-transfer';
  static const String brandOwnerFixedAssetsDisposalDetails =
      '$brandOwnerFixedAssetsDisposalRequests/{id}';
  static const String brandOwnerFixedAssetsDisposalApprove =
      '$brandOwnerFixedAssetsDisposalRequests/{id}/approve';
  static const String brandOwnerFixedAssetsDisposalReject =
      '$brandOwnerFixedAssetsDisposalRequests/{id}/reject';

  // Handover Reports (Major Discrepancy)
  static const String brandOwnerFixedAssetsHandoverReports =
      '${brandOwnerFixedAssetsRequests}handover-reports';
  static const String brandOwnerFixedAssetsHandoverReportsDetails =
      '$brandOwnerFixedAssetsHandoverReports/{id}';
  static const String brandOwnerFixedAssetsHandoverReportsApprove =
      '$brandOwnerFixedAssetsHandoverReports/{id}/approve';
  static const String brandOwnerFixedAssetsHandoverReportsSalaryDeduction =
      '$brandOwnerFixedAssetsHandoverReports/{id}/salary-deduction';
  static const String brandOwnerFixedAssetsHandoverReportsReject =
      '$brandOwnerFixedAssetsHandoverReports/{id}/reject';

  // Review & Audit
  static const String brandOwnerFixedAssetsReviewAuditRequests =
      '${brandOwnerFixedAssetsRequests}review-audit';
  static const String brandOwnerFixedAssetsReviewAuditDetails =
      '$brandOwnerFixedAssetsReviewAuditRequests/{id}';
  static const String brandOwnerFixedAssetsReviewAuditApprove =
      '$brandOwnerFixedAssetsReviewAuditRequests/{id}/approve';
  static const String brandOwnerFixedAssetsReviewAuditReject =
      '$brandOwnerFixedAssetsReviewAuditRequests/{id}/reject';

  // =================== Brand Owner Asset Overview Endpoints ===================
  static const String brandOwnerAssetOverview = '${brandOwner}asset-overview';
  static const String brandOwnerAssetOverviewPerformanceSummary =
      '$brandOwnerAssetOverview/performance-summary';
  static const String brandOwnerAssetOverviewBranchDetails =
      '$brandOwnerAssetOverview/branch/{branchId}';
  static const String brandOwnerAssetOverviewExport =
      '$brandOwnerAssetOverview/export';
  static const String brandOwnerControlPanel = '${brandOwner}control-panel';

  // =================== Brand Owner Settings Endpoints ===================
  static const String brandOwnerSettings = '${brandOwner}settings/';
  static const String brandOwnerSettingsApproval =
      '${brandOwnerSettings}approval';
  static const String brandOwnerSettingsReport = '${brandOwnerSettings}report';
  static const String brandOwnerSettingsSecurity =
      '${brandOwnerSettings}security';
  static const String brandOwnerSettingsRetention =
      '${brandOwnerSettings}retention';
  static const String brandOwnerSettingsNotifications =
      '${brandOwnerSettings}notifications';

  // =================== Brand Owner Financial Reporting Endpoints ===================
  static const String brandOwnerFinancial = '${brandOwner}financial/';

  // GET
  static const String brandOwnerFinancialProfitAndLoss =
      '${brandOwnerFinancial}profit-and-loss';
  static const String brandOwnerFinancialSalesChannelAnalysis =
      '${brandOwnerFinancial}sales-channel-analysis';
  static const String brandOwnerFinancialSalesChannelLevel2 =
      '${brandOwnerFinancial}sales-channel-level2';
  static const String brandOwnerFinancialSmartComparison =
      '${brandOwnerFinancial}smart-comparison';
  static const String brandOwnerFinancialProfitVsCashReconciliation =
      '${brandOwnerFinancial}profit-vs-cash-reconciliation';
  static const String brandOwnerFinancialBreakEvenAnalysis =
      '${brandOwnerFinancial}break-even-analysis';
  static const String brandOwnerFinancialOperationalProfitability =
      '${brandOwnerFinancial}operational-profitability';
  static const String brandOwnerFinancialMenuEngineering =
      '${brandOwnerFinancial}menu-engineering';

  // Item Test
  static const String brandOwnerFinancialItemTest =
      '${brandOwnerFinancial}item-test/';
  static const String brandOwnerFinancialItemTestSubmit =
      '${brandOwnerFinancialItemTest}submit';
  static const String brandOwnerFinancialItemTestSavedTests =
      '${brandOwnerFinancialItemTest}saved-tests';
  static const String brandOwnerFinancialItemTestExport =
      '${brandOwnerFinancialItemTest}export';
  static const String brandOwnerFinancialItemTestEmail =
      '${brandOwnerFinancialItemTest}email';

  // Price Simulator
  static const String brandOwnerFinancialPriceSimulator =
      '${brandOwnerFinancial}price-simulator/';
  static const String brandOwnerFinancialPriceSimulatorItems =
      '${brandOwnerFinancialPriceSimulator}items';
  static const String brandOwnerFinancialPriceSimulatorItemInfo =
      '${brandOwnerFinancialPriceSimulator}item-info';
  static const String brandOwnerFinancialPriceSimulatorSimulate =
      '${brandOwnerFinancialPriceSimulator}simulate';
  static const String brandOwnerFinancialPriceSimulatorSavedScenarios =
      '${brandOwnerFinancialPriceSimulator}saved-scenarios';
  static const String brandOwnerFinancialPriceSimulatorExport =
      '${brandOwnerFinancialPriceSimulator}export';
  static const String brandOwnerFinancialPriceSimulatorEmail =
      '${brandOwnerFinancialPriceSimulator}email';

  // Export endpoints
  static const String brandOwnerFinancialProfitAndLossExport =
      '${brandOwnerFinancial}profit-and-loss/export';
  static const String brandOwnerFinancialSalesChannelAnalysisExport =
      '${brandOwnerFinancial}sales-channel-analysis/export';
  static const String brandOwnerFinancialSalesChannelLevel2Export =
      '${brandOwnerFinancial}sales-channel-level2/export';
  static const String brandOwnerFinancialSmartComparisonExport =
      '${brandOwnerFinancial}smart-comparison/export';
  static const String brandOwnerFinancialProfitVsCashReconciliationExport =
      '${brandOwnerFinancial}profit-vs-cash-reconciliation/export';
  static const String brandOwnerFinancialBreakEvenAnalysisExport =
      '${brandOwnerFinancial}break-even-analysis/export';
  static const String brandOwnerFinancialOperationalProfitabilityExport =
      '${brandOwnerFinancial}operational-profitability/export';
  static const String brandOwnerFinancialMenuEngineeringExport =
      '${brandOwnerFinancial}menu-engineering/export';

  // Email endpoints
  static const String brandOwnerFinancialProfitAndLossEmail =
      '${brandOwnerFinancial}profit-and-loss/email';
  static const String brandOwnerFinancialSalesChannelAnalysisEmail =
      '${brandOwnerFinancial}sales-channel-analysis/email';
  static const String brandOwnerFinancialSmartComparisonEmail =
      '${brandOwnerFinancial}smart-comparison/email';
  static const String brandOwnerFinancialProfitVsCashReconciliationEmail =
      '${brandOwnerFinancial}profit-vs-cash-reconciliation/email';
  static const String brandOwnerFinancialOperationalProfitabilityEmail =
      '${brandOwnerFinancial}operational-profitability/email';
  static const String brandOwnerFinancialMenuEngineeringEmail =
      '${brandOwnerFinancial}menu-engineering/email';
}
