import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/get_custody_report_details_usecase.dart';
import 'brand_owner_custody_report_details_state.dart';

@injectable
class BrandOwnerCustodyReportDetailsCubit
    extends SafeCubit<BrandOwnerCustodyReportDetailsState> {
  final GetCustodyReportDetailsUseCase _useCase;

  BrandOwnerCustodyReportDetailsCubit(this._useCase)
    : super(const BrandOwnerCustodyReportDetailsInitial());

  Future<void> loadCustodyReport({required String reportId}) async {
    emit(const BrandOwnerCustodyReportDetailsLoading());

    final result = await _useCase(reportId: reportId);

    handle(
      result,
      success: (data) {
        emit(BrandOwnerCustodyReportDetailsSuccess(data));
      },
      failure: (failure) =>
          emit(BrandOwnerCustodyReportDetailsFailure(failure)),
    );
  }
}
