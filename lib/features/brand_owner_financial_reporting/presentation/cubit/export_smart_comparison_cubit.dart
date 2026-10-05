import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/enums/brand_owner_smart_compare_type_enum.dart';
import '../../domain/usecases/export_smart_comparison_usecase.dart';
import 'export_smart_comparison_state.dart';

@injectable
class ExportSmartComparisonCubit
    extends SafeCubit<ExportSmartComparisonState> {
  final ExportSmartComparisonUseCase _exportUseCase;

  ExportSmartComparisonCubit(this._exportUseCase)
    : super(const ExportSmartComparisonInit());

  Future<void> exportSmartComparison({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String formatType,
  }) async {
    emit(const ExportSmartComparisonLoading());

    final result = await _exportUseCase(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      type: type,
      branchId: branchId,
      comparedBranchId: comparedBranchId,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportSmartComparisonSuccess(fileUrl));
      },
      failure: (failure) =>
          emit(ExportSmartComparisonFailure(failure)),
    );
  }

  Future<void> exportSmartComparisonByEmail({
    required int year,
    required int month,
    required int comparedYear,
    required int comparedMonth,
    required BrandOwnerSmartCompareTypeEnum type,
    required String branchId,
    String? comparedBranchId,
    required String email,
  }) async {
    emit(const ExportSmartComparisonEmailLoading());

    final result = await _exportUseCase.emailReport(
      year: year,
      month: month,
      comparedYear: comparedYear,
      comparedMonth: comparedMonth,
      type: type,
      branchId: branchId,
      comparedBranchId: comparedBranchId,
      email: email,
    );

    handle(
      result,
      success: (_) {
        emit(const ExportSmartComparisonEmailSuccess());
      },
      failure: (failure) =>
          emit(ExportSmartComparisonEmailFailure(failure)),
    );
  }
}
