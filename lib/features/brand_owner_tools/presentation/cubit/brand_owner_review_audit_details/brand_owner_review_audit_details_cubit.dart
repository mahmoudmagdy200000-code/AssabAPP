import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/brand_owner_fixed_assets_review_audit_details_response.dart';
import '../../../domain/use_cases/approve_brand_owner_fixed_assets_review_audit_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_review_audit_details_use_case.dart';
import '../../../domain/use_cases/reject_brand_owner_fixed_assets_review_audit_use_case.dart';
import 'brand_owner_review_audit_details_state.dart';

@injectable
class BrandOwnerReviewAuditDetailsCubit
    extends SafeCubit<BrandOwnerReviewAuditDetailsState> {
  final GetBrandOwnerFixedAssetsReviewAuditDetailsUseCase _getDetailsUseCase;
  final ApproveBrandOwnerFixedAssetsReviewAuditUseCase _approveUseCase;
  final RejectBrandOwnerFixedAssetsReviewAuditUseCase _rejectUseCase;

  BrandOwnerReviewAuditDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._rejectUseCase,
  ) : super(const BrandOwnerReviewAuditDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerReviewAuditDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(BrandOwnerReviewAuditDetailsFailure(failure)),
      success: (details) => emit(BrandOwnerReviewAuditDetailsSuccess(details)),
    );
  }

  Future<void> approve({required String requestId}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(BrandOwnerReviewAuditDetailsActionLoading(details, true));

    final result = await _approveUseCase(requestId: requestId);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerReviewAuditDetailsActionFailure(details, failure, true),
      ),
      success: (_) {
        emit(
          BrandOwnerReviewAuditDetailsActionSuccess(details, true),
        );
        load(requestId: requestId);
      },
    );
  }

  Future<void> reject({
    required String requestId,
    required String reason,
  }) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(BrandOwnerReviewAuditDetailsActionLoading(details, false));

    final result = await _rejectUseCase(requestId: requestId, reason: reason);

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerReviewAuditDetailsActionFailure(details, failure, false),
      ),
      success: (_) {
        emit(
          BrandOwnerReviewAuditDetailsActionSuccess(details, false),
        );
        load(requestId: requestId);
      },
    );
  }

  BrandOwnerFixedAssetsReviewAuditDetailsResponse? _currentDetails() {
    return switch (state) {
      BrandOwnerReviewAuditDetailsSuccess(:final details) ||
      BrandOwnerReviewAuditDetailsActionLoading(:final details) ||
      BrandOwnerReviewAuditDetailsActionSuccess(:final details) ||
      BrandOwnerReviewAuditDetailsActionFailure(:final details) => details,
      _ => null,
    };
  }
}
