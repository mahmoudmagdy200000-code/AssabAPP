import 'package:assab/features/branch_manager_expenses/data/models/grouped_invoice_response_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/pre_approval_update_draft_request.dart';
import 'package:assab/features/branch_manager_expenses/data/models/quick_cash_response_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/single_invoice_update_draft_request.dart';
import 'package:assab/features/branch_manager_expenses/data/models/update_draft_quick_cash_request_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/api_endpoints.dart';
import '../models/add_sup_category_request.dart';
import '../models/all_expense_response_model.dart';
import '../models/expense_categories_response_model.dart';
import '../models/expenses_custody_balance_response.dart';
import '../models/expenses_response_model.dart';
import '../models/expenses_summary_response_model.dart';
import '../models/grouped_invoice_update_draft_request.dart';
import '../models/pre_approval_previous_response.dart';
import '../models/pre_approval_response_model.dart';
import '../models/single_invoice_previous_response.dart';
import '../models/single_invoice_response_model.dart';
import '../models/sup_categories_response.dart';
import '../models/supplier_response_model.dart';
import '../models/update_sup_category_request.dart';

part 'branch_manager_expenses_remote_data_source.g.dart';

@RestApi(baseUrl: ApiEndpoint.baseUrl)
abstract class BranchManagerExpensesRemoteDataSource {
  factory BranchManagerExpensesRemoteDataSource(Dio dio, {String? baseUrl}) =
      _BranchManagerExpensesRemoteDataSource;

  @POST(ApiEndpoint.branchManagerExpensesCreateQuickCash)
  Future<QuickCashResponseModel> createQuickCashExpense({
    @Body() required FormData formData,
  });

  @PUT('${ApiEndpoint.branchManagerExpensesCreateQuickCash}/{id}')
  Future<QuickCashResponseModel> updateDraftQuickCashExpense({
    @Path('id') required String id,
    @Body() required UpdateDraftQuickCashRequestModel model,
  });

  @POST(ApiEndpoint.branchManagerExpensesCreateSingleInvoice)
  Future<SingleInvoiceResponseModel> createSingleInvoiceExpense({
    @Body() required FormData formData,
  });

  @PUT('${ApiEndpoint.branchManagerExpensesCreateSingleInvoice}/{id}')
  Future<SingleInvoiceResponseModel> updateDraftSingleExpense({
    @Path('id') required String id,
    @Body() required SingleInvoiceUpdateDraftRequest model,
  });

  @POST(ApiEndpoint.branchManagerExpensesCreatePreApproval)
  Future<PreApprovalResponseModel> createPreApprovalExpense({
    @Body() required FormData formData,
  });

  @PUT('${ApiEndpoint.branchManagerExpensesCreatePreApproval}/{id}')
  Future<PreApprovalResponseModel> updateDraftPreApprovalExpense({
    @Path('id') required String id,
    @Body() required PreApprovalUpdateDraftRequest model,
  });

  @POST(ApiEndpoint.branchManagerExpensesCreateGroupedInvoice)
  Future<GroupedInvoiceResponseModel> createGroupedInvoiceExpense({
    @Body() required FormData formData,
  });

  @PUT('${ApiEndpoint.branchManagerExpensesCreateGroupedInvoice}/{id}')
  Future<GroupedInvoiceResponseModel> updateDraftGroupedInvoiceExpense({
    @Path('id') required String id,
    @Body() required GroupedInvoiceUpdateDraftRequest model,
  });

  @POST('${ApiEndpoint.branchManagerExpenses}/{id}/attachments')
  Future<void> uploadDraftAttachments({
    @Path('id') required String id,
    @Body() required FormData formData,
  });

  @GET(ApiEndpoint.branchManagerExpensesSuppliers)
  Future<SupplierResponseModel> getSuppliers();

  @GET(ApiEndpoint.branchManagerExpensesCategories)
  Future<ExpenseCategoriesResponseModel> getCategories();

  @GET('${ApiEndpoint.branchManagerExpensesCategories}/{id}/subcategories')
  Future<SupCategoriesResponse> getSupCategories({
    @Path('id') required String categoryId,
  });

  @DELETE('${ApiEndpoint.branchManagerExpensesCategories}/{id}')
  Future<void> deleteCategories({@Path('id') required String id});

  @PUT('${ApiEndpoint.branchManagerExpensesCategories}/{id}')
  Future<void> updateSupCategory({
    @Path('id') required String id,
    @Body() required UpdateSupCategoryRequest model,
  });

  @POST(ApiEndpoint.branchManagerExpensesCategories)
  Future<void> addSupCategory({@Body() required AddSupCategoryRequest model});

  @GET(ApiEndpoint.branchManagerExpensesSummary)
  Future<ExpensesSummaryResponseModel> getExpensesSummary({
    @Query('month') required int month,
    @Query('year') required int year,
  });

  @GET(ApiEndpoint.branchManagerExpensesRecent)
  Future<ExpensesResponseModel> getExpensesRecent();

  @GET(ApiEndpoint.branchManagerExpenses)
  Future<AllExpenseResponseModel> getAllExpenses({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesDraft)
  Future<AllExpenseResponseModel> getAllDraftExpenses({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesQuickCash)
  Future<AllExpenseResponseModel> getAllQuickCashExpenses({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesSingleInvoice)
  Future<AllExpenseResponseModel> getAllSingleInvoiceExpenses({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesPreApproval)
  Future<AllExpenseResponseModel> getAllPreApprovalExpenses({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesGroupedInvoice)
  Future<AllExpenseResponseModel> getAllGroupedInvoiceExpenses({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesSearch)
  Future<AllExpenseResponseModel> getSearchExpenses({
    @Query('page') required int page,
    @Query('type') required String type,
    @Query('status') required String status,
    @Query('period') required String period,
  });

  @GET('${ApiEndpoint.branchManagerExpenses}/{id}')
  Future<QuickCashResponseModel> getQuickCashExpensesDetails({
    @Path('id') required String id,
  });

  @GET('${ApiEndpoint.branchManagerExpenses}/{id}')
  Future<SingleInvoiceResponseModel> getSingleInvoiceExpensesDetails({
    @Path('id') required String id,
  });

  @GET('${ApiEndpoint.branchManagerExpenses}/{id}')
  Future<PreApprovalResponseModel> getPreApprovalExpensesDetails({
    @Path('id') required String id,
  });

  @GET('${ApiEndpoint.branchManagerExpenses}/{id}')
  Future<GroupedInvoiceResponseModel> getGroupedInvoiceExpensesDetails({
    @Path('id') required String id,
  });

  @DELETE('${ApiEndpoint.branchManagerExpenses}/{id}')
  Future<void> removeDraftExpense({@Path('id') required String id});

  @GET(ApiEndpoint.branchManagerExpensesPreviousSingleInvoice)
  Future<SingleInvoicePreviousResponseModel> getPreviousSingleInvoice({
    @Query('page') required int page,
  });

  @GET(ApiEndpoint.branchManagerExpensesPreviousPreApproval)
  Future<PreApprovalPreviousResponse> getPreviousPreApproval({
    @Query('page') required int page,
  });

  @POST('${ApiEndpoint.branchManagerExpensesCreatePreApproval}/{id}/duplicate')
  Future<void> createPreviousPreApproval({@Path('id') required String id});

  @POST('${ApiEndpoint.branchManagerExpensesSingleInvoice}/{id}/duplicate')
  Future<void> createPreviousSingleInvoice({@Path('id') required String id});

  @GET(ApiEndpoint.branchManagerExpensesCustodyBalance)
  Future<ExpensesCustodyBalanceResponse> getCustodyBalance();
}
