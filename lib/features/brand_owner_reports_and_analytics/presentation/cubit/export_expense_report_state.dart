import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportExpenseReportState extends Equatable {
  const ExportExpenseReportState();

  @override
  List<Object> get props => [];
}

final class ExportExpenseReportInit extends ExportExpenseReportState {
  const ExportExpenseReportInit();
}

final class ExportExpenseReportLoading extends ExportExpenseReportState {
  const ExportExpenseReportLoading();
}

final class ExportExpenseReportSuccess extends ExportExpenseReportState {
  final String fileUrl;

  const ExportExpenseReportSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportExpenseReportFailure extends ExportExpenseReportState {
  final ApiFailure failure;

  const ExportExpenseReportFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
