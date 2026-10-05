import 'package:assab/core/enums/expenses_filter_keys.dart';
import 'package:assab/core/enums/filter_status.dart';
import 'package:assab/core/errors/repository_mixin.dart';
import 'package:assab/core/utils/future_api_result.dart';
import 'package:assab/features/branch_manager_expenses/data/models/all_expense_response_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/create_quick_cash_request_model.dart';
import 'package:assab/features/branch_manager_expenses/data/models/pre_approval_update_draft_request.dart';
import 'package:assab/features/branch_manager_expenses/data/models/single_invoice_update_draft_request.dart';
import 'package:assab/features/branch_manager_expenses/data/models/update_draft_quick_cash_request_model.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/pre_approval_entity.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/enums/time_keys.dart';
import '../../domain/entities/expenses_entity.dart';
import '../../domain/entities/expenses_main_category_response_entity.dart';
import '../../domain/entities/expenses_summary_entity.dart';
import '../../domain/entities/expenses_sup_category_entity.dart';
import '../../domain/entities/grouped_invoice_entity.dart';
import '../../domain/entities/quick_cash_entity.dart';
import '../../domain/entities/single_invoice_entity.dart';
import '../data_source/branch_manager_expenses_remote_data_source.dart';
import '../models/add_sup_category_request.dart';
import '../models/create_grouped_invoice_request_model.dart';
import '../models/create_pre_approval_request_model.dart';
import '../models/create_single_invoice_request_model.dart';
import '../models/date_filter_model.dart';
import '../models/expense_categories_response_model.dart';
import '../models/expenses_custody_balance_response.dart';
import '../models/grouped_invoice_update_draft_request.dart';
import '../models/pre_approval_previous_response.dart';
import '../models/single_invoice_previous_response.dart';
import '../models/sup_categories_response.dart';
import '../models/supplier_response_model.dart';
import '../models/update_sup_category_request.dart';
import '../models/upload_draft_attachments_request.dart';

@LazySingleton()
class BranchManagerExpensesRepository with RepositoryMixin {
  final BranchManagerExpensesRemoteDataSource
  _branchManagerExpensesRemoteDataSource;

  BranchManagerExpensesRepository(this._branchManagerExpensesRemoteDataSource);

  FutureApiResult<QuickCashEntity> createQuickCashExpense({
    required CreateQuickCashRequestModel model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .createQuickCashExpense(formData: await model.toFormData());

      return response.toEntity();
    });
  }

  FutureApiResult<QuickCashEntity> updateDraftQuickCashExpense({
    required final String id,
    required UpdateDraftQuickCashRequestModel model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .updateDraftQuickCashExpense(id: id, model: model);

      return response.toEntity();
    });
  }

  FutureApiResult<SingleInvoiceEntity> createSingleInvoiceExpense({
    required CreateSingleInvoiceRequestModel model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .createSingleInvoiceExpense(formData: await model.toFormData());

      return response.toEntity();
    });
  }

  FutureApiResult<SingleInvoiceEntity> updateDraftSingleExpense({
    required final String id,
    required SingleInvoiceUpdateDraftRequest model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .updateDraftSingleExpense(model: model, id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<PreApprovalEntity> createPreApprovalExpense({
    required CreatePreApprovalRequestModel model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .createPreApprovalExpense(formData: await model.toFormData());

      return response.toEntity();
    });
  }

  FutureApiResult<PreApprovalEntity> updateDraftPreApprovalExpense({
    required final String id,
    required PreApprovalUpdateDraftRequest model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .updateDraftPreApprovalExpense(model: model, id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<GroupedInvoiceEntity> createGroupedInvoiceExpense({
    required GroupedInvoiceRequestModel model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .createGroupedInvoiceExpense(formData: await model.toFormData());

      return response.toEntity();
    });
  }

  FutureApiResult<GroupedInvoiceEntity> updateDraftGroupedInvoiceExpense({
    required String id,
    required GroupedInvoiceUpdateDraftRequest model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .updateDraftGroupedInvoiceExpense(model: model, id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<void> uploadDraftAttachments({
    required String id,
    required UploadDraftAttachmentsRequest model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .uploadDraftAttachments(formData: await model.toFormData(), id: id);

      return response;
    });
  }

  FutureApiResult<SupplierResponseModel> getSuppliers() async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getSuppliers();

      return response;
    });
  }

  FutureApiResult<ExpenseCategoriesResponseModel> getCategories() async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getCategories();

      return response;
    });
  }

  FutureApiResult<List<ExpensesMainCategoryResponseEntity>>
  getAllCategories() async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getCategories();

      final filtered = response.data;

      final mainCategories = filtered.where((e) => e.parent == null).toList();

      final entities = mainCategories.map((main) {
        final subCategories = filtered
            .where((e) => e.parent?.id == main.id)
            .map((sub) => ExpensesSupCategoryEntity(id: sub.id, name: sub.name))
            .toList();

        return ExpensesMainCategoryResponseEntity(
          id: main.id,
          name: main.name,
          type: main.type,
          subCategories: subCategories,
        );
      }).toList();

      return entities;
    });
  }

  FutureApiResult<SupCategoriesResponse> getSupCategories({
    required String categoryId,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getSupCategories(categoryId: categoryId);

      return response;
    });
  }

  FutureApiResult<void> deleteCategory({required String id}) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .deleteCategories(id: id);

      return response;
    });
  }

  FutureApiResult<void> updateSupCategory({
    required String id,
    required UpdateSupCategoryRequest model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .updateSupCategory(id: id, model: model);

      return response;
    });
  }

  FutureApiResult<void> addSupCategory({
    required AddSupCategoryRequest model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .addSupCategory(model: model);

      return response;
    });
  }

  FutureApiResult<ExpensesSummaryEntity> getExpensesSummary({
    required DateFilterModel model,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getExpensesSummary(month: model.month, year: model.year);

      return response.data.toEntity();
    });
  }

  FutureApiResult<List<ExpensesEntity>> getExpensesRecent() async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getExpensesRecent();

      return response.data.map((e) => e.toEntity()).toList();
    });
  }

  FutureApiResult<AllExpenseResponseModel> getAllExpenses({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getAllExpenses(page: page);

      return response;
    });
  }

  FutureApiResult<AllExpenseResponseModel> getAllDraftExpenses({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getAllDraftExpenses(page: page);

      return response;
    });
  }

  FutureApiResult<AllExpenseResponseModel> getAllQuickCashExpenses({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getAllQuickCashExpenses(page: page);

      return response;
    });
  }

  FutureApiResult<AllExpenseResponseModel> getAllSingleInvoiceExpenses({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getAllSingleInvoiceExpenses(page: page);

      return response;
    });
  }

  FutureApiResult<AllExpenseResponseModel> getAllPreApprovalExpenses({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getAllPreApprovalExpenses(page: page);

      return response;
    });
  }

  FutureApiResult<AllExpenseResponseModel> getAllGroupedInvoiceExpenses({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getAllGroupedInvoiceExpenses(page: page);

      return response;
    });
  }

  FutureApiResult<AllExpenseResponseModel> getSearchExpenses({
    required int page,
    required ExpensesFilterKeys? type,
    required FilterStatus? status,
    required TimeKeys? period,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getSearchExpenses(
            page: page,
            type: type?.key ?? '',
            status: status?.key ?? '',
            period: period?.key ?? '',
          );

      return response;
    });
  }

  FutureApiResult<QuickCashEntity> getQuickCashExpensesDetails({
    required String id,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getQuickCashExpensesDetails(id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<SingleInvoiceEntity> getSingleInvoiceExpensesDetails({
    required String id,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getSingleInvoiceExpensesDetails(id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<PreApprovalEntity> getPreApprovalExpensesDetails({
    required String id,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getPreApprovalExpensesDetails(id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<GroupedInvoiceEntity> getGroupedInvoiceExpensesDetails({
    required String id,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getGroupedInvoiceExpensesDetails(id: id);

      return response.toEntity();
    });
  }

  FutureApiResult<void> removeDraftExpense({required String id}) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .removeDraftExpense(id: id);

      return response;
    });
  }

  FutureApiResult<SingleInvoicePreviousResponseModel> getPreviousSingleInvoice({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getPreviousSingleInvoice(page: page);

      return response;
    });
  }

  FutureApiResult<PreApprovalPreviousResponse> getPreviousPreApproval({
    required int page,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getPreviousPreApproval(page: page);

      return response;
    });
  }

  FutureApiResult<void> createPreviousSingleInvoice({
    required String id,
  }) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .createPreviousSingleInvoice(id: id);

      return response;
    });
  }

  FutureApiResult<void> createPreviousPreApproval({required String id}) async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .createPreviousPreApproval(id: id);

      return response;
    });
  }

  FutureApiResult<ExpensesCustodyBalanceResponse> getCustodyBalance() async {
    return execute(() async {
      final response = await _branchManagerExpensesRemoteDataSource
          .getCustodyBalance();

      return response;
    });
  }
}
