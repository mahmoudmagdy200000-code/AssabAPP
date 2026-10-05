import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/export_operational_profitability_usecase.dart';
import 'export_operational_profitability_state.dart';

@injectable
class ExportOperationalProfitabilityCubit
    extends SafeCubit<ExportOperationalProfitabilityState> {
  final ExportOperationalProfitabilityUseCase _exportUseCase;

  ExportOperationalProfitabilityCubit(this._exportUseCase)
    : super(const ExportOperationalProfitabilityInit());

  Future<void> exportOperationalProfitability({
    required String formatType,
  }) async {
    emit(const ExportOperationalProfitabilityLoading());

    final result = await _exportUseCase(
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportOperationalProfitabilitySuccess(fileUrl));
      },
      failure: (failure) =>
          emit(ExportOperationalProfitabilityFailure(failure)),
    );
  }

  Future<void> exportOperationalProfitabilityByEmail({
    required String email,
  }) async {
    emit(const ExportOperationalProfitabilityEmailLoading());

    final result = await _exportUseCase.emailReport(
      email: email,
    );

    handle(
      result,
      success: (_) {
        emit(const ExportOperationalProfitabilityEmailSuccess());
      },
      failure: (failure) =>
          emit(ExportOperationalProfitabilityEmailFailure(failure)),
    );
  }
}
