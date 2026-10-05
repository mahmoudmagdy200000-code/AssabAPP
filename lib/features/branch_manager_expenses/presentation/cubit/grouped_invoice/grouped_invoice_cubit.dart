import 'dart:io';

import 'package:assab/core/errors/api_failure.dart';
import 'package:assab/features/branch_manager_expenses/data/models/upload_draft_attachments_request.dart';
import 'package:assab/features/branch_manager_expenses/data/repository/branch_manager_expenses_repository.dart';
import 'package:assab/features/branch_manager_expenses/domain/entities/grouped_invoice_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import '../../../../../core/utils/api_result.dart';
import '../../../data/models/create_grouped_invoice_request_model.dart';
import '../../../data/models/grouped_invoice_update_draft_request.dart';

part 'grouped_invoice_state.dart';

@injectable
class GroupedInvoiceCubit extends SafeCubit<GroupedInvoiceState> {
  final BranchManagerExpensesRepository _branchManagerExpensesRepository;

  GroupedInvoiceCubit(this._branchManagerExpensesRepository)
    : super(const GroupedInvoiceInitial());

  Future<void> createGroupedInvoiceExpense({
    required GroupedInvoiceRequestModel model,
  }) async {
    emit(const GroupedInvoiceLoading());
    final result = await _branchManagerExpensesRepository
        .createGroupedInvoiceExpense(model: model);
    handle(
      result,
      failure: (failure) => emit(GroupedInvoiceFailure(failure)),
      success: (response) => emit(GroupedInvoiceSuccess(response)),
    );
  }

  Future<void> updateDraftGroupedInvoiceExpense({
    required GroupedInvoiceUpdateDraftRequest model,
    required String id,
    required List<Map<String, List<File>>> attachments,
  }) async {
    emit(const GroupedInvoiceLoading());

    final result = await Future.wait<ApiResult>([
      _branchManagerExpensesRepository.updateDraftGroupedInvoiceExpense(
        model: model,
        id: id,
      ),
      _branchManagerExpensesRepository.uploadDraftAttachments(
        model: UploadDraftGroupedInvoiceAttachmentsRequest(
          attachments: attachments,
        ),
        id: id,
      ),
    ]);

    final updateResult = result[0] as ApiResult<GroupedInvoiceEntity>;
    final uploadResult = result[1] as ApiResult<void>;

    handle(
      updateResult,
      success: (response) {
        handle(
          uploadResult,
          failure: (failure) => emit(GroupedInvoiceFailure(failure)),
          success: (_) => emit(GroupedInvoiceSuccess(response)),
        );
      },
      failure: (failure) => emit(GroupedInvoiceFailure(failure)),
    );
  }
}
