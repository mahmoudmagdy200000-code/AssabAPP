import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportCustodyReportState extends Equatable {
  const ExportCustodyReportState();

  @override
  List<Object> get props => [];
}

final class ExportCustodyReportInit extends ExportCustodyReportState {
  const ExportCustodyReportInit();
}

final class ExportCustodyReportLoading extends ExportCustodyReportState {
  const ExportCustodyReportLoading();
}

final class ExportCustodyReportSuccess extends ExportCustodyReportState {
  final String fileUrl;

  const ExportCustodyReportSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportCustodyReportFailure extends ExportCustodyReportState {
  final ApiFailure failure;

  const ExportCustodyReportFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
