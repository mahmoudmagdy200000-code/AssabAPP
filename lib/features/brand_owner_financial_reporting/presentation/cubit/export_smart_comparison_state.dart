import 'package:assab/core/errors/api_failure.dart';
import 'package:equatable/equatable.dart';

sealed class ExportSmartComparisonState extends Equatable {
  const ExportSmartComparisonState();

  @override
  List<Object> get props => [];
}

final class ExportSmartComparisonInit extends ExportSmartComparisonState {
  const ExportSmartComparisonInit();
}

final class ExportSmartComparisonLoading extends ExportSmartComparisonState {
  const ExportSmartComparisonLoading();
}

final class ExportSmartComparisonSuccess extends ExportSmartComparisonState {
  final String fileUrl;

  const ExportSmartComparisonSuccess(this.fileUrl);

  @override
  List<Object> get props => [fileUrl];
}

final class ExportSmartComparisonFailure extends ExportSmartComparisonState {
  final ApiFailure failure;

  const ExportSmartComparisonFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class ExportSmartComparisonEmailLoading
    extends ExportSmartComparisonState {
  const ExportSmartComparisonEmailLoading();
}

final class ExportSmartComparisonEmailSuccess
    extends ExportSmartComparisonState {
  const ExportSmartComparisonEmailSuccess();
}

final class ExportSmartComparisonEmailFailure
    extends ExportSmartComparisonState {
  final ApiFailure failure;

  const ExportSmartComparisonEmailFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
