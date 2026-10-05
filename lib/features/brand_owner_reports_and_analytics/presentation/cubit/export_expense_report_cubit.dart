import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/repositories/brand_owner_reports_and_analytics_repository.dart';
import 'export_expense_report_state.dart';

@injectable
class ExportExpenseReportCubit extends SafeCubit<ExportExpenseReportState> {
  final BrandOwnerReportsAndAnalyticsRepository _repository;

  ExportExpenseReportCubit(this._repository)
    : super(const ExportExpenseReportInit());

  Future<void> exportExpenseReport({
    required int year,
    required int monthNumber,
    required String formatType,
    required String expenseType,
    VoidCallback? onSuccess,
  }) async {
    emit(const ExportExpenseReportLoading());

    final result = await _repository.exportExpenseReport(
      year: year,
      monthNumber: monthNumber,
      formatType: formatType,
      expenseType: expenseType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportExpenseReportSuccess(fileUrl));
        onSuccess?.call();
      },
      failure: (failure) => emit(ExportExpenseReportFailure(failure)),
    );
  }
}
