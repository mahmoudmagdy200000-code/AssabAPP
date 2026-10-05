import 'dart:io';

import 'package:assab/core/helpers/paginator.dart';
import 'package:assab/features/branch_manager_expenses/data/models/upload_draft_attachments_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/utils/api_result.dart';
import '../../../../../shared/models/meta_model/meta_model.dart';
import '../../../data/models/create_single_invoice_request_model.dart';
import '../../../data/models/single_invoice_data_model.dart';
import '../../../data/models/single_invoice_previous_response.dart';
import '../../../data/models/single_invoice_update_draft_request.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';
import '../../../domain/entities/single_invoice_entity.dart';
import 'single_expense_state.dart';

@injectable
class SingleExpenseCubit extends SafeCubit<SingleExpenseState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  late final Paginator<
    SingleInvoiceDataModel,
    SingleInvoicePreviousResponseModel
  >
  paginator;

  SingleExpenseCubit(this._branchManagerExpensesRepository)
    : super(const SingleExpenseInit()) {
    paginator =
        Paginator<SingleInvoiceDataModel, SingleInvoicePreviousResponseModel>(
          fetchPage: (page) => _branchManagerExpensesRepository
              .getPreviousSingleInvoice(page: page),
          extractData: (res) => res.data,
          extractMeta: (res) => MetaInfo(
            currentPage: res.meta.currentPage,
            lastPage: res.meta.lastPage,
            total: res.meta.total,
          ),
        );
  }

  void createSingleExpense({
    required CreateSingleInvoiceRequestModel model,
  }) async {
    emit(const SingleExpenseLoading());

    final result = await _branchManagerExpensesRepository
        .createSingleInvoiceExpense(model: model);

    handle(
      result,
      success: (response) => emit(SingleExpenseSuccess(response)),
      failure: (failure) => emit(SingleExpenseFailure(failure)),
    );
  }

  void updateDraftSingleExpense({
    required String id,
    required SingleInvoiceUpdateDraftRequest model,
    required List<File> attachments,
  }) async {
    emit(const SingleExpenseLoading());

    final result = await Future.wait<ApiResult>([
      _branchManagerExpensesRepository.updateDraftSingleExpense(
        model: model,
        id: id,
      ),
      _branchManagerExpensesRepository.uploadDraftAttachments(
        model: UploadDraftAttachmentsDefaultRequest(attachments: attachments),
        id: id,
      ),
    ]);

    final updateResult = result[0] as ApiResult<SingleInvoiceEntity>;
    final uploadResult = result[1] as ApiResult<void>;

    handle(
      updateResult,
      success: (response) {
        handle(
          uploadResult,
          success: (_) => emit(SingleExpenseSuccess(response)),
          failure: (failure) => emit(SingleExpenseFailure(failure)),
        );
      },
      failure: (failure) => emit(SingleExpenseFailure(failure)),
    );
  }

  void getPastRequests({bool loadMore = false}) async {
    if (!loadMore) emit(const GetPreviousSingleExpenseLoading());

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetPreviousSingleExpenseFailure(failure)),
      success: (items) {
        emit(
          GetPreviousSingleExpenseSuccess(
            SingleInvoicePreviousResponseModel(
              data: items,
              meta: MetaModel(
                currentPage: paginator.currentPage - 1,
                lastPage: paginator.hasMore
                    ? paginator.currentPage
                    : paginator.currentPage - 1,
                total: items.length,
              ),
            ),
          ),
        );
      },
    );
  }
}
