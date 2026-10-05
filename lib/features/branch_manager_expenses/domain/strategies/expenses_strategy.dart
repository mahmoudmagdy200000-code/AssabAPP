import 'package:assab/core/cubits/paging_cubit/paging_cubit.dart';
import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/extensions/build_context_extensions.dart';
import 'package:assab/core/services/navigation/navigation_service.dart';
import 'package:assab/features/branch_manager_expenses/data/models/expense_type_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/grouped_invoice_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/pre_approval_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/domain/strategies/quick_cash_draft_strategy.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/expense_details/expense_details_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/pre_approval/pre_approval_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/cubit/single_expense/single_expense_cubit.dart';
import 'package:assab/features/branch_manager_expenses/presentation/screens/expense_details_screen.dart';
import 'package:assab/features/branch_manager_expenses/presentation/screens/expense_pre_approval_details_details_view.dart';
import 'package:assab/features/branch_manager_expenses/presentation/widgets/single_invoice_reuse_past_request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/cubits/add_item/add_item_cubit.dart';
import '../../../../core/cubits/choose_item/choose_item_cubit.dart';
import '../../../../core/cubits/media/media_cubit.dart';
import '../../../../core/cubits/payment_method/payment_method_cubit.dart';
import '../../../../core/cubits/search/search_cubit.dart';
import '../../../../core/cubits/select_priority/select_priority_cubit.dart';
import '../../../../core/cubits/switch_button/switch_button_cubit.dart';
import '../../../../core/cubits/validation/validation_cubit.dart';
import '../../../../core/enums/expenses_steragies_keys.dart';
import '../../../../core/strategies/user_type_strategy.dart';
import '../../data/models/expense_status_model.dart';
import '../../data/models/pre_approval_data_model.dart';
import '../../data/models/single_invoice_data_model.dart';
import '../../presentation/cubit/categories/categories_cubit.dart';
import '../../presentation/cubit/create_expense_previous_request/create_expense_previous_request_cubit.dart';
import '../../presentation/cubit/grouped_invoice/grouped_invoice_cubit.dart';
import '../../presentation/cubit/suppliers/suppliers_cubit.dart';
import '../../presentation/screens/expense_grouped_invoice_details_details_view.dart';
import '../../presentation/screens/expense_quick_cash_details_details_view.dart';
import '../../presentation/screens/expense_single_invoice_details_details_view.dart';
import '../../presentation/screens/grouped_invoices_screen.dart';
import '../../presentation/screens/pre_approval_request_screen.dart';
import '../../presentation/screens/quick_cash_expense_screen.dart';
import '../../presentation/screens/single_expense_screen.dart';
import '../../presentation/widgets/pre_approval_reuse_past_request_view.dart';
import 'single_invoice_draft_strategy.dart';

abstract class ExpensesStrategy {
  Widget expenseDetailsView(String id, {bool isDraft = false});

  Widget expenseScreen(BuildContext context, String id);

  String get expenseType;

  String get assetName;

  String displayName(BuildContext context);

  String description(BuildContext context);

  Widget reusePastRequestWidget(
    ScrollController scrollController,
    ValueNotifier<int?> selectedInvoice,
  ) {
    return const SizedBox.shrink();
  }

  void navigateToDetailsScreen(
    String expenseId,
    ExpenseTypeModel expenseTypeModel,
    UserTypeStrategy userTypeStrategy,
    ExpenseStatusModel status,
  ) {
    NavigationService.I.replaceWith(
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PagingCubit(totalSteps: 3)),
            BlocProvider(create: (context) => getIt<ExpenseDetailsCubit>()),
          ],
          child: ExpenseDetailsScreen(
            id: expenseId,
            expenseTypeModel: expenseTypeModel,
            userTypeStrategy: userTypeStrategy,
            expenseStatusModel: status,
          ),
        ),
      ),
    );
  }

  void getPastRequests(BuildContext context, {bool loadMore = false}) {}

  void createPastRequests(BuildContext context) {}

  void searchPastRequests(BuildContext context, String query) {}

  bool pastRequestsHasMore(BuildContext context) => false;
}

class QuickCashExpensesStrategy extends ExpensesStrategy {
  @override
  Widget expenseDetailsView(String id, {bool isDraft = false}) {
    return ExpenseQuickCashDetailsDetailsView(id: id);
  }

  @override
  String get assetName => AppAssets.cash;

  @override
  String get expenseType => ExpensesStrategiesKeys.quickCash.key;

  @override
  String displayName(BuildContext context) => context.tr.quickCashExpense;

  @override
  String description(BuildContext context) => context.tr.quickCashExpenseDesc;

  @override
  Widget expenseScreen(BuildContext context, String id) {
    return MultiBlocProvider(
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
      child: QuickCashExpenseScreen(
        strategy: EditDraftQuickCashStrategy(),
        expenseId: id,
      ),
    );
  }
}

class SingleInvoiceExpensesStrategy extends ExpensesStrategy {
  @override
  Widget expenseDetailsView(String id, {bool isDraft = false}) {
    return ExpenseSingleInvoiceDetailsDetailsView(id: id);
  }

  @override
  String get assetName => AppAssets.invoice;

  @override
  String get expenseType => ExpensesStrategiesKeys.singleInvoice.key;

  @override
  String displayName(BuildContext context) => context.tr.singleInvoice;

  @override
  String description(BuildContext context) => context.tr.singleInvoiceDesc;

  @override
  void getPastRequests(BuildContext context, {bool loadMore = false}) {
    context.read<SingleExpenseCubit>().getPastRequests(loadMore: loadMore);
    super.getPastRequests(context);
  }

  late final String _selectedInvoiceId;

  set _setSelectedInvoiceId(String id) {
    _selectedInvoiceId = id;
  }

  String get _getSelectedInvoiceId => _selectedInvoiceId;

  @override
  Widget reusePastRequestWidget(
    ScrollController scrollController,
    ValueNotifier<int?> selectedInvoice,
  ) {
    return SingleInvoiceReusePastRequestView(
      scrollController: scrollController,
      selectedInvoice: selectedInvoice,
      selectedInvoiceId: (id) {
        _setSelectedInvoiceId = id;
      },
    );
  }

  @override
  void createPastRequests(BuildContext context) {
    context
        .read<CreateExpensePreviousRequestCubit>()
        .createPreviousSingleInvoice(id: _getSelectedInvoiceId);
    super.createPastRequests(context);
  }

  @override
  void searchPastRequests(BuildContext context, String query) {
    context.read<SearchCubit<SingleInvoiceDataModel>>().search(
      query,
      (item, query) => item.singleInvoice!.invoiceNumber!
          .toLowerCase()
          .contains(query.toLowerCase()),
    );
    super.searchPastRequests(context, query);
  }

  @override
  bool pastRequestsHasMore(BuildContext context) {
    return context.read<SingleExpenseCubit>().paginator.hasMore;
  }

  @override
  Widget expenseScreen(BuildContext context, String id) {
    return MultiBlocProvider(
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
      child: SingleExpenseScreen(
        strategy: EditDraftSingleInvoiceStrategy(),
        expenseId: id,
      ),
    );
  }
}

class PreApprovalExpensesStrategy extends ExpensesStrategy {
  @override
  Widget expenseDetailsView(String id, {bool isDraft = false}) {
    return ExpensePreApprovalDetailsDetailsView(id: id);
  }

  @override
  String get assetName => AppAssets.preApprovalRequest;

  @override
  String get expenseType => ExpensesStrategiesKeys.preApproval.key;

  @override
  String displayName(BuildContext context) => context.tr.preApprovalRequest;

  @override
  String description(BuildContext context) => context.tr.preApprovalRequestDesc;

  @override
  void getPastRequests(BuildContext context, {bool loadMore = false}) {
    context.read<PreApprovalCubit>().getPastRequests(loadMore: loadMore);
    super.getPastRequests(context);
  }

  late final String _selectedInvoiceId;

  set _setSelectedInvoiceId(String id) {
    _selectedInvoiceId = id;
  }

  String get _getSelectedInvoiceId => _selectedInvoiceId;

  @override
  Widget reusePastRequestWidget(
    ScrollController scrollController,
    ValueNotifier<int?> selectedInvoice,
  ) {
    return PreApprovalReusePastRequestView(
      scrollController: scrollController,
      selectedInvoice: selectedInvoice,
      selectedInvoiceId: (id) {
        _setSelectedInvoiceId = id;
      },
    );
  }

  @override
  void createPastRequests(BuildContext context) {
    context.read<CreateExpensePreviousRequestCubit>().createPreviousPreApproval(
      id: _getSelectedInvoiceId,
    );
    super.createPastRequests(context);
  }

  @override
  void searchPastRequests(BuildContext context, String query) {
    context.read<SearchCubit<PreApprovalDataModel>>().search(
      query,
      (item, query) =>
          item.data!.purpose!.toLowerCase().contains(query.toLowerCase()),
    );
    super.searchPastRequests(context, query);
  }

  @override
  bool pastRequestsHasMore(BuildContext context) {
    return context.read<PreApprovalCubit>().paginator.hasMore;
  }

  @override
  Widget expenseScreen(BuildContext context, String id) {
    return MultiBlocProvider(
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
        strategy: EditDraftPreApprovalDraftStrategy(),
        expenseId: id,
      ),
    );
  }
}

class GroupedInvoiceExpensesStrategy extends ExpensesStrategy {
  @override
  Widget expenseDetailsView(String id, {bool isDraft = false}) {
    return ExpenseGroupedInvoiceDetailsDetailsView(id: id);
  }

  @override
  String get assetName => AppAssets.preApprovalRequest;

  @override
  String get expenseType => ExpensesStrategiesKeys.groupedInvoice.key;

  @override
  String displayName(BuildContext context) => context.tr.groupedInvoices;

  @override
  String description(BuildContext context) => context.tr.groupedInvoicesDesc;

  @override
  Widget expenseScreen(BuildContext context, String id) {
    return MultiBlocProvider(
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
        strategy: EditDraftGroupedInvoiceDraftStrategy(),
        expenseId: id,
      ),
    );
  }
}
