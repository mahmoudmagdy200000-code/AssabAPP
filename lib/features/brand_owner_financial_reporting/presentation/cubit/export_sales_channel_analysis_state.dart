import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportSalesChannelAnalysisState extends Equatable {
  const ExportSalesChannelAnalysisState();

  @override
  List<Object> get props => [];
}

final class ExportSalesChannelAnalysisInit
    extends ExportSalesChannelAnalysisState {
  const ExportSalesChannelAnalysisInit();
}

final class ExportSalesChannelAnalysisLoading
    extends ExportSalesChannelAnalysisState {
  const ExportSalesChannelAnalysisLoading();
}

final class ExportSalesChannelAnalysisSuccess
    extends ExportSalesChannelAnalysisState {
  final String fileUrl;

  const ExportSalesChannelAnalysisSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportSalesChannelAnalysisFailure
    extends ExportSalesChannelAnalysisState {
  final ApiFailure failure;

  const ExportSalesChannelAnalysisFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ExportSalesChannelAnalysisEmailLoading
    extends ExportSalesChannelAnalysisState {
  const ExportSalesChannelAnalysisEmailLoading();
}

final class ExportSalesChannelAnalysisEmailSuccess
    extends ExportSalesChannelAnalysisState {
  const ExportSalesChannelAnalysisEmailSuccess();
}

final class ExportSalesChannelAnalysisEmailFailure
    extends ExportSalesChannelAnalysisState {
  final ApiFailure failure;

  const ExportSalesChannelAnalysisEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
