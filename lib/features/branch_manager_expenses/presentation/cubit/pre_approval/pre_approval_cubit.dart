import 'dart:io';

import 'package:assab/core/utils/api_result.dart';
import 'package:assab/features/branch_manager_expenses/data/models/upload_draft_attachments_request.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/paginator.dart';
import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../shared/models/meta_model/meta_model.dart';
import '../../../data/models/create_pre_approval_request_model.dart';
import '../../../data/models/pre_approval_data_model.dart';
import '../../../data/models/pre_approval_previous_response.dart';
import '../../../data/models/pre_approval_update_draft_request.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';
import '../../../domain/entities/pre_approval_entity.dart';
import 'pre_approval_state.dart';

@injectable
class PreApprovalCubit extends SafeCubit<PreApprovalState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  late final Paginator<PreApprovalDataModel, PreApprovalPreviousResponse>
  paginator;

  PreApprovalCubit(this._branchManagerExpensesRepository)
    : super(const PreApprovalInitial()) {
    paginator = Paginator<PreApprovalDataModel, PreApprovalPreviousResponse>(
      fetchPage: (page) =>
          _branchManagerExpensesRepository.getPreviousPreApproval(page: page),
      extractData: (res) => res.data,
      extractMeta: (res) => MetaInfo(
        currentPage: res.meta.currentPage,
        lastPage: res.meta.lastPage,
        total: res.meta.total,
      ),
    );
  }

  Future<void> createPreApprovalExpense({
    required CreatePreApprovalRequestModel model,
  }) async {
    emit(const PreApprovalLoading());

    final result = await _branchManagerExpensesRepository
        .createPreApprovalExpense(model: model);

    handle(
      result,
      success: (data) => emit(PreApprovalSuccess(data)),
      failure: (failure) => emit(PreApprovalFailure(failure)),
    );
  }

  Future<void> updateDraftPreApprovalExpense({
    required String id,
    required PreApprovalUpdateDraftRequest model,
    required List<File> attachments,
  }) async {
    emit(const PreApprovalLoading());

    final result = await Future.wait<ApiResult>([
      _branchManagerExpensesRepository.updateDraftPreApprovalExpense(
        model: model,
        id: id,
      ),
      _branchManagerExpensesRepository.uploadDraftAttachments(
        model: UploadDraftAttachmentsDefaultRequest(attachments: attachments),
        id: id,
      ),
    ]);

    final updateResult = result[0] as ApiResult<PreApprovalEntity>;
    final uploadResult = result[1] as ApiResult<void>;

    handle(
      updateResult,
      success: (data) {
        handle(
          uploadResult,
          success: (_) => emit(PreApprovalSuccess(data)),
          failure: (failure) => emit(PreApprovalFailure(failure)),
        );
      },
      failure: (failure) => emit(PreApprovalFailure(failure)),
    );
  }

  void getPastRequests({bool loadMore = false}) async {
    if (!loadMore) emit(const GetPreviousPreApprovalLoading());

    final result = await paginator.loadNextPage();

    handle(
      result,
      failure: (failure) => emit(GetPreviousPreApprovalFailure(failure)),
      success: (items) {
        emit(
          GetPreviousPreApprovalSuccess(
            PreApprovalPreviousResponse(
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
