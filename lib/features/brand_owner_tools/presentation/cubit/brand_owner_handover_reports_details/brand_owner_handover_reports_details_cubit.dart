import 'package:assab/core/helpers/safe_cubit.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/brand_owner_fixed_assets_handover_report_details_response.dart';
import '../../../domain/use_cases/approve_brand_owner_fixed_assets_handover_report_use_case.dart';
import '../../../domain/use_cases/get_brand_owner_fixed_assets_handover_report_details_use_case.dart';
import '../../../domain/use_cases/salary_deduction_brand_owner_fixed_assets_handover_report_use_case.dart';
import 'brand_owner_handover_reports_details_state.dart';

@injectable
class BrandOwnerHandoverReportsDetailsCubit
    extends SafeCubit<BrandOwnerHandoverReportsDetailsState> {
  final GetBrandOwnerFixedAssetsHandoverReportDetailsUseCase _getDetailsUseCase;
  final ApproveBrandOwnerFixedAssetsHandoverReportUseCase _approveUseCase;
  final SalaryDeductionBrandOwnerFixedAssetsHandoverReportUseCase
  _salaryDeductionUseCase;

  BrandOwnerHandoverReportsDetailsCubit(
    this._getDetailsUseCase,
    this._approveUseCase,
    this._salaryDeductionUseCase,
  ) : super(const BrandOwnerHandoverReportsDetailsInitial());

  Future<void> load({required String requestId}) async {
    emit(const BrandOwnerHandoverReportsDetailsLoading());

    final result = await _getDetailsUseCase(requestId: requestId);

    handle(
      result,
      success: (details) => emit(BrandOwnerHandoverReportsDetailsSuccess(details)),
      failure: (failure) => emit(BrandOwnerHandoverReportsDetailsFailure(failure)),
    );
  }

  Future<void> approve({required String requestId, required String warningNote}) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(BrandOwnerHandoverReportsDetailsActionLoading(details, false));

    final result = await _approveUseCase(
      requestId: requestId,
      warningNote: warningNote,
    );

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerHandoverReportsDetailsActionFailure(details, failure, false),
      ),
      success: (_) {
        emit(
          BrandOwnerHandoverReportsDetailsActionSuccess(details, false),
        );
        load(requestId: requestId);
      },
    );
  }

  Future<void> salaryDeduction({
    required String requestId,
    required String amount,
    required String reason,
  }) async {
    final details = _currentDetails();
    if (details == null) return;

    emit(BrandOwnerHandoverReportsDetailsActionLoading(details, true));

    final result = await _salaryDeductionUseCase(
      requestId: requestId,
      amount: amount,
      reason: reason,
    );

    handle(
      result,
      failure: (failure) => emit(
        BrandOwnerHandoverReportsDetailsActionFailure(details, failure, true),
      ),
      success: (_) {
        emit(
          BrandOwnerHandoverReportsDetailsActionSuccess(details, true),
        );
        load(requestId: requestId);
      },
    );
  }

  BrandOwnerFixedAssetsHandoverReportDetailsResponse? _currentDetails() {
    return switch (state) {
      BrandOwnerHandoverReportsDetailsSuccess(:final details) ||
      BrandOwnerHandoverReportsDetailsActionLoading(:final details) ||
      BrandOwnerHandoverReportsDetailsActionSuccess(:final details) ||
      BrandOwnerHandoverReportsDetailsActionFailure(:final details) => details,
      _ => null,
    };
  }
}
