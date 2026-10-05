import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/entities/brand_owner_expense_report_details_entity.dart';
import '../../domain/entities/brand_owner_expense_report_filter_entity.dart';
import '../../domain/enums/brand_owner_expense_report_type.dart';
import '../../domain/usecases/get_brand_owner_expense_report_details_usecase.dart';
import 'brand_owner_expense_report_details_state.dart';

@injectable
class BrandOwnerExpenseReportDetailsCubit
    extends SafeCubit<BrandOwnerExpenseReportDetailsState> {
  final GetBrandOwnerExpenseReportDetailsUseCase _useCase;

  BrandOwnerExpenseReportDetailsCubit(this._useCase)
    : super(const BrandOwnerExpenseReportDetailsInitial());

  Future<void> loadReport({
    required String reportId,
    BrandOwnerExpenseReportFilterEntity? filters,
  }) async {
    emit(const BrandOwnerExpenseReportDetailsLoading());

    final result = await _useCase(reportId: reportId, filters: filters);

    handle(
      result,
      success: (data) {
        emit(BrandOwnerExpenseReportDetailsSuccess(data));
      },
      failure: (failure) =>
          emit(BrandOwnerExpenseReportDetailsFailure(failure)),
    );
  }
}
