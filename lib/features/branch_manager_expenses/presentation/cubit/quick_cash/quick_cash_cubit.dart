import 'dart:io';

import 'package:assab/features/branch_manager_expenses/data/models/update_draft_quick_cash_request_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/utils/api_result.dart';
import '../../../data/models/create_quick_cash_request_model.dart';
import '../../../data/models/upload_draft_attachments_request.dart';
import '../../../data/repository/branch_manager_expenses_repository.dart';
import '../../../domain/entities/quick_cash_entity.dart';
import 'quick_cash_state.dart';

@injectable
class QuickCashCubit extends SafeCubit<QuickCashState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  QuickCashCubit(this._branchManagerExpensesRepository)
    : super(const QuickCashInitial());

  Future<void> createQuickCashExpense({
    required CreateQuickCashRequestModel model,
  }) async {
    emit(const QuickCashLoading());

    final result = await _branchManagerExpensesRepository
        .createQuickCashExpense(model: model);

    handle(
      result,
      success: (response) => emit(QuickCashSuccess(response)),
      failure: (failure) => emit(QuickCashFailure(failure)),
    );
  }

  Future<void> updateDraftQuickCashExpense({
    required final String id,
    required UpdateDraftQuickCashRequestModel model,
    required final List<File> attachments,
  }) async {
    emit(const QuickCashLoading());

    final result = await Future.wait<ApiResult>([
      _branchManagerExpensesRepository.updateDraftQuickCashExpense(
        id: id,
        model: model,
      ),
      _branchManagerExpensesRepository.uploadDraftAttachments(
        id: id,
        model: UploadDraftAttachmentsDefaultRequest(attachments: attachments),
      ),
    ]);

    final updateResult = result[0] as ApiResult<QuickCashEntity>;
    final uploadResult = result[1] as ApiResult<void>;

    handle(
      updateResult,
      success: (response) {
        handle(
          uploadResult,
          success: (_) => emit(QuickCashSuccess(response)),
          failure: (failure) => emit(QuickCashFailure(failure)),
        );
      },
      failure: (failure) => emit(QuickCashFailure(failure)),
    );
  }
}
