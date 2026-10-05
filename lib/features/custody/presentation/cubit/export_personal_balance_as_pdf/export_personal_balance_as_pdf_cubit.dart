import 'package:assab/features/custody/data/repository/custody_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helpers/safe_cubit.dart';
import 'export_personal_balance_as_pdf_state.dart';

@injectable
class ExportPersonalBalanceAsPdfCubit
    extends SafeCubit<ExportPersonalBalanceAsPdfState> {
  final CustodyRepository _custodyRepository;

  ExportPersonalBalanceAsPdfCubit(this._custodyRepository)
    : super(const ExportPersonalBalanceAsPdfInit());

  Future<void> exportPersonalBalanceAsPdf({
    String? timePeriod,
    String? type,
  }) async {
    emit(const ExportPersonalBalanceAsPdfLoading());

    final result = await _custodyRepository
        .getPersonalBalanceTransactionsExportPdf(
          timePeriod: timePeriod,
          type: type,
        );

    handle(
      result,
      success: (fileUrl) => emit(ExportPersonalBalanceAsPdfSuccess(fileUrl)),
      failure: (failure) => emit(ExportPersonalBalanceAsPdfFailure(failure)),
    );
  }
}
