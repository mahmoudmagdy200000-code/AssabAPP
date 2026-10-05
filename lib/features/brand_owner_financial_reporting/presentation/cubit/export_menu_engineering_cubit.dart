import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/usecases/export_menu_engineering_usecase.dart';
import 'export_menu_engineering_state.dart';

@injectable
class ExportMenuEngineeringCubit
    extends SafeCubit<ExportMenuEngineeringState> {
  final ExportMenuEngineeringUseCase _exportUseCase;

  ExportMenuEngineeringCubit(this._exportUseCase)
    : super(const ExportMenuEngineeringInit());

  Future<void> exportMenuEngineering({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
  }) async {
    emit(const ExportMenuEngineeringLoading());

    final result = await _exportUseCase(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportMenuEngineeringSuccess(fileUrl));
      },
      failure: (failure) =>
          emit(ExportMenuEngineeringFailure(failure)),
    );
  }

  Future<void> exportMenuEngineeringByEmail({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required String branchId,
    required String email,
  }) async {
    emit(const ExportMenuEngineeringEmailLoading());

    final result = await _exportUseCase.emailReport(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      branchId: branchId,
      email: email,
    );

    handle(
      result,
      success: (_) {
        emit(const ExportMenuEngineeringEmailSuccess());
      },
      failure: (failure) =>
          emit(ExportMenuEngineeringEmailFailure(failure)),
    );
  }
}
