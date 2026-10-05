import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportBreakEvenAnalysisState extends Equatable {
  const ExportBreakEvenAnalysisState();

  @override
  List<Object> get props => [];
}

final class ExportBreakEvenAnalysisInit extends ExportBreakEvenAnalysisState {
  const ExportBreakEvenAnalysisInit();
}

final class ExportBreakEvenAnalysisLoading extends ExportBreakEvenAnalysisState {
  const ExportBreakEvenAnalysisLoading();
}

final class ExportBreakEvenAnalysisSuccess extends ExportBreakEvenAnalysisState {
  final String fileUrl;

  const ExportBreakEvenAnalysisSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportBreakEvenAnalysisFailure extends ExportBreakEvenAnalysisState {
  final ApiFailure failure;

  const ExportBreakEvenAnalysisFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
