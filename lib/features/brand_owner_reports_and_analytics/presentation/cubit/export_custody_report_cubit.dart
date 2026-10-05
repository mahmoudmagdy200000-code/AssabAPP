import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helpers/safe_cubit.dart';
import '../../domain/repositories/brand_owner_reports_and_analytics_repository.dart';
import 'export_custody_report_state.dart';

@injectable
class ExportCustodyReportCubit extends SafeCubit<ExportCustodyReportState> {
  final BrandOwnerReportsAndAnalyticsRepository _repository;

  ExportCustodyReportCubit(this._repository)
    : super(const ExportCustodyReportInit());

  Future<void> exportCustodyReport({
    required int year,
    required int monthNumber,
    required String formatType,
    VoidCallback? onSuccess,
  }) async {
    emit(const ExportCustodyReportLoading());

    final result = await _repository.exportCustodyReport(
      year: year,
      monthNumber: monthNumber,
      formatType: formatType,
    );

    handle(
      result,
      success: (fileUrl) {
        emit(ExportCustodyReportSuccess(fileUrl));
        onSuccess?.call();
      },
      failure: (failure) => emit(ExportCustodyReportFailure(failure)),
    );
  }
}
